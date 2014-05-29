//
//  HBCoreLabel
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "HBCoreLabel.h"
#import "NSStrUtil.h"
@implementation HBCoreLabel
@synthesize match=_match,linesLimit;

#pragma -mark 接口方法

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch=YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self){
        _copyEnableAlready=NO;
        self.exclusiveTouch=YES;
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _attributed=NO;
    [super setText:text];
}

-(void)setMatch:(MatchParser *)match
{
    if(match==_match)
        return;
    if (match.titleOnly) {
        _attributed=NO;
        if (IOS_VERSION>=6.0) {
            self.attributedText=match.attrString;
            [self setNeedsDisplay];
        }else{
            self.text=match.attrString.string;
        }
    }else{
        _attributed=YES;
        _match=match;
        [self setNeedsDisplay];
    }
}
-(void)registerCopyAction
{
    if(_copyEnableAlready)
        return;
    _copyEnableAlready=YES;
    self.userInteractionEnabled=YES;
    NSArray * gestures=self.gestureRecognizers;
    for(UIGestureRecognizer * gesture in gestures){
        if([gestures isKindOfClass:[UILongPressGestureRecognizer class]]){
            UILongPressGestureRecognizer * longPress=(UILongPressGestureRecognizer*)gestures;
            [longPress addTarget:self action:@selector(longPressAction:)];
            return;
        }
    }
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [longPress setMinimumPressDuration:0.8];

    [self addGestureRecognizer:longPress];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(!_attributed){
        [super drawRect:rect];
        return;
    }
    if(self.match!=nil&&[self.match isKindOfClass:[MatchParser class]]){
        CGContextRef context = UIGraphicsGetCurrentContext();
            // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextSaveGState(context); 
        CGContextTranslateCTM(context, 0, 10000);
        CGContextScaleCTM(context, 1.0, -1.0);
        if(self.match.numberOfLimitLines==0||(self.match.numberOfLimitLines>=self.match.numberOfTotalLines)||!self.linesLimit){
            CTFrameDraw((__bridge CTFrameRef)(self.match.ctFrame), context);
            for (NSDictionary* imageData in self.match.images) {
                NSString* img = [imageData objectForKey:MatchParserImage];
                UIImage * image=[UIImage imageNamed:img];
                NSValue * value=[imageData objectForKey:MatchParserRects];
                CGRect imgBounds;
                if(![value isKindOfClass:[NSNull class]])
                    imgBounds=[[imageData objectForKey:MatchParserRects] CGRectValue];
                CGContextDrawImage(context, imgBounds, image.CGImage);
                
            }
        }
        else{
            NSArray *lines = (__bridge NSArray *)CTFrameGetLines((__bridge CTFrameRef)(self.match.ctFrame));
            CGPoint origins[[lines count]];
            CTFrameGetLineOrigins((__bridge CTFrameRef)(self.match.ctFrame), CFRangeMake(0, 0), origins); //2
            for(int lineIndex=0;lineIndex<self.match.numberOfLimitLines;lineIndex++){
                CTLineRef line=(__bridge CTLineRef)(lines[lineIndex]);
                CGContextSetTextPosition(context,origins[lineIndex].x,origins[lineIndex].y);
             //   NSLog(@"%d: %f,%f",lineIndex,origins[lineIndex].x,origins[lineIndex].y);
                CTLineDraw(line, context);
            }
            for (NSDictionary* imageData in self.match.images) {
                NSString* img = [imageData objectForKey:MatchParserImage];
                UIImage * image=[UIImage imageNamed:img];
                NSValue * value=[imageData objectForKey:MatchParserRects];
                CGRect imgBounds;
                if(![value isKindOfClass:[NSNull class]])
                {
                    imgBounds=[[imageData objectForKey:MatchParserRects] CGRectValue];
                    NSNumber * number=[imageData objectForKey:MatchParserLine];
                    int line=[number intValue];
                    if(line<self.match.numberOfLimitLines){
                        CGContextDrawImage(context, imgBounds, image.CGImage);
                    }
                }
            }
        }
    }
}

#pragma -mark 事件响应方法

-(void)longPressAction:(UIGestureRecognizer*)gesture
{
    if (gesture.view!=self) {
        return;
    }
    self.backgroundColor=[UIColor lightGrayColor];
    if(gesture.state==UIGestureRecognizerStateBegan){
        UIActionSheet * action =[[UIActionSheet alloc]initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"复制"
                                                  otherButtonTitles:nil, nil];
        [action showInView:[UIApplication sharedApplication].keyWindow];

    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch1=[touches anyObject];
    CGPoint point=[touch1 locationInView:self];
    for(NSDictionary * dic in self.match.links){
        NSArray * rects=[dic objectForKey:MatchParserRects];
        for(NSValue * value in rects){
            CGRect rect= [value CGRectValue];
            if(point.x>rect.origin.x&&point.y>rect.origin.y&&point.x<(rect.origin.x+rect.size.width)&&point.y<(rect.origin.y+rect.size.height)){
                NSValue * rangeValue=[dic objectForKey:MatchParserRange];
                NSRange range1=[rangeValue rangeValue];
                id<MatchParserDelegate> data=self.match.data;
                _data=data;
                [data updateMatch:^(NSMutableAttributedString *string, NSRange range) {
                        CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
                    if(range.location==range1.location){
                        NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.match.keyWorkColor.CGColor,kCTForegroundColorAttributeName,[NSNumber numberWithFloat:1],kCTStrokeWidthAttributeName,nil];
                        [string addAttributes:attribute range:range];
                    }else{
                        NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.match.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
                        [string addAttributes:attribute range:range];
                    }
                    CFRelease(fontRef);
                }];
                NSArray * ges=[self.superview gestureRecognizers];
                for(UIGestureRecognizer * recognizer in ges){
                    recognizer.enabled=NO;
                }
                ges=[self gestureRecognizers];
                for(UIGestureRecognizer * recognizer in ges){
                    recognizer.enabled=NO;
                }
                _linkStr=[self.match.attrString.string substringWithRange:range1];
                _linkType=[dic objectForKey:MatchParserLinkType];
                [self setNeedsDisplay];
                touch=YES;
                return;
            }
        }
    }
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touch) {
        touch=NO;
        if(_data){
            [_data updateMatch:^(NSMutableAttributedString *string, NSRange range) {
                CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
                NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.match.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
                [string addAttributes:attribute range:range];
            }];
            NSArray * ges=[self.superview gestureRecognizers];
            for(UIGestureRecognizer * recognizer in ges){
                recognizer.enabled=YES;
            }
            ges=[self gestureRecognizers];
            for(UIGestureRecognizer * recognizer in ges){
                recognizer.enabled=YES;
            }
            [self setNeedsDisplay];
            if([_linkType isEqualToString:MatchParserLinkTypeUrl]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:linkClick:)]){
                    [self.delegate coreLabel:self linkClick:_linkStr];
                }
            }else if ([_linkType isEqualToString:MatchParserLinkTypePhone]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:phoneClick:)]){
                    [self.delegate coreLabel:self phoneClick:_linkStr];
                }
            }else if ([_linkType isEqualToString:MatchParserLinkTypeMobie]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:mobieClick:)]){
                    [self.delegate coreLabel:self mobieClick:_linkStr];
                }
            }
            return;
        }
    }
    [super touchesCancelled:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touch){
        touch=NO;
        if(_data){
            [_data updateMatch:^(NSMutableAttributedString *string, NSRange range) {
                CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
                NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.match.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
                [string addAttributes:attribute range:range];
                CFRelease(fontRef);
            }];
            NSArray * ges=[self.superview gestureRecognizers];
            for(UIGestureRecognizer * recognizer in ges){
                recognizer.enabled=YES;
            }
            ges=[self gestureRecognizers];
            for(UIGestureRecognizer * recognizer in ges){
                recognizer.enabled=YES;
            }
            [self setNeedsDisplay];
            if([_linkType isEqualToString:MatchParserLinkTypeUrl]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:linkClick:)]){
                    [self.delegate coreLabel:self linkClick:_linkStr];
                }
            }else if ([_linkType isEqualToString:MatchParserLinkTypePhone]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:phoneClick:)]){
                    [self.delegate coreLabel:self phoneClick:_linkStr];
                }
            }else if ([_linkType isEqualToString:MatchParserLinkTypeMobie]){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(coreLabel:mobieClick:)]){
                    [self.delegate coreLabel:self mobieClick:_linkStr];
                }
            }
            return;
        }
    }
    [super touchesEnded:touches withEvent:event];
}


#pragma -mark 回调方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.backgroundColor=[UIColor clearColor];
    if(buttonIndex==0){
        if([self.match.source isKindOfClass:[NSString  class]]){
            [UIPasteboard generalPasteboard].string=self.match.source;
        }
    }
}


@end
