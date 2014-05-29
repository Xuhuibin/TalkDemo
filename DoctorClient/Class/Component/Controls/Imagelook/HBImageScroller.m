//
//  HBImageScroller.m
//  MyTest
//
//  Created by weqia on 13-7-31.
//  Copyright (c) 2013年 weqia. All rights reserved.
//

#import "HBImageScroller.h"
#import "HBFileCache.h"
#import "UIImageView+Cache.h"
#import "DialogUtil.h"
#import "XHBImageUtil.h"
@implementation HBImageScroller
@synthesize imageView=_imageView,controller;

#pragma -mark 覆盖父类的方法


#pragma -mark 事件响应方法
-(void)longPressAction:(UIGestureRecognizer*)sender
{
    if(sender.state==UIGestureRecognizerStateBegan){
        if(self.controller){
            UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",@"分享到", nil];
            [action showInView:[UIApplication sharedApplication].keyWindow];
        }else{
            UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
            [action showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}


-(void)imageTapTwoAction:(UIGestureRecognizer*)recognizer
{
        if(max)
        {
            [self setZoomScale:1 animated:YES];
            [self setImageFrameAndContentSize];
            max=NO;
        }else{
            [self setZoomScale:2.5 animated:YES];
            region=[self getLocationRegion:[recognizer locationInView:self]];
            max=YES;
        }
}

-(void)imageTapOnceAction:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.numberOfTapsRequired==1) {
        if(_tapOnceAction&&_target&&[_target respondsToSelector:_tapOnceAction])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_tapOnceAction withObject:_imageView];
        
#pragma clang diagnostic pop
    }

}

#pragma -mark 回调方法

-(void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
    if(error){
        [[DialogUtil sharedInstance] showDlg:self textOnly:@"图片保存失败"];
    }else{
        [[DialogUtil sharedInstance] showDlg:self textOnly:@"图片保存成功"];
    }
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    CGRect frame=_imageView.frame;
    self.contentSize=frame.size;
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    switch (region) {
        case RegionTopLeft:
            [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:YES];
            break;
        case RegionBottomLeft:
            [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:YES];
            break;
        case RegionTopRight:
            [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
            break;
        case RegionBottomRight:
            [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:YES];
            break;
        default:
            break;
    }
    region=0;
}

#pragma -mark 私有方法
-(void)setImageFrameAndContentSize
{
    CGRect frame=[XHBImageUtil frameForImageView:_imageView.image.size inRect:self.frame];
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    CGPoint center=CGPointMake(self.contentSize.width * 0.5 + offsetX,
                               self.contentSize.height * 0.5 + offsetY);
    _imageView.frame=CGRectMake(center.x-0.5*frame.size.width, center.y-0.5*frame.size.height, frame.size.width, frame.size.height);
    _imageView.center =center;
}

-(LocationRegion)getLocationRegion:(CGPoint)point
{
    float width=self.frame.size.width;
    float height=self.frame.size.height;
    point=[self convertPoint:point toView:self.superview];
    if(point.x<width/6)
    {
        if(point.y<height/6)
            return RegionTopLeft;
        else if(point.y>5*height/6)
            return RegionBottomLeft;

    }
    else if(point.x>5*width/6)
    {
        if(point.y<height/6)
            return RegionTopRight;
        else if(point.y>5*height/6)
            return RegionBottomRight;
    }return RegionCenter;
}

#pragma -mark 接口方法
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapOnceAction:)];
        tapOnce.numberOfTapsRequired=1;
        tapOnce.numberOfTouchesRequired=1;
        [self addGestureRecognizer:tapOnce];
        _imageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* tapTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapTwoAction:)];
        tapTwo.numberOfTapsRequired=2;
        tapTwo.numberOfTouchesRequired=1;
        [tapOnce requireGestureRecognizerToFail:tapTwo];
        
        [self addGestureRecognizer:tapTwo];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        max=NO;
        _tapOnceAction=nil;
        _target=nil;
        self.contentSize=self.frame.size;
        self.delegate=self;
        self.minimumZoomScale=0.1;
        self.maximumZoomScale=10;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self)
    {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapOnceAction:)];
        tapOnce.numberOfTapsRequired=1;
        tapOnce.numberOfTouchesRequired=1;
        [self addGestureRecognizer:tapOnce];
        _imageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* tapTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapTwoAction:)];
        tapTwo.numberOfTapsRequired=2;
        tapTwo.numberOfTouchesRequired=1;
        [tapOnce requireGestureRecognizerToFail:tapTwo];
        [self addGestureRecognizer:tapTwo];
        
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        _imageView.autoresizingMask=UIViewAutoresizingNone;
        max=NO;
        _tapOnceAction=nil;
        _target=nil;
        self.contentSize=self.frame.size;
        self.delegate=self;
        self.minimumZoomScale=0.1;
        self.maximumZoomScale=10;
    }
    return self;
}

-(id)initWithImage:(UIImage*)image andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:image];
    }
    return self;
}

-(void)setImage:(UIImage*)image
{
    // Initialization code
    _imageView.image=image;
    [self setImageFrameAndContentSize];
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

-(void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url andSmallImage:nil];
}

-(void)setImageWithURL:(NSString*)url  andSmallImage:(UIImage*)image
{
    if ([image isKindOfClass:[UIImageView class]]) {
        image=((UIImageView*)image).image;
    }
    UIImage* image1=[[HBFileCache shareCache] getImageFromMemory:url];
    if(image1){
        _imageView.image=image1;
        [self setImageFrameAndContentSize];
        _imageView.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }else{
        UIImage *image1=[[HBFileCache shareCache] getImageFromDisk:url];
        if(image1){
            _imageView.image=image1;
            [self setImageFrameAndContentSize];
            _imageView.userInteractionEnabled=YES;
            UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
            [self addGestureRecognizer:longPress];
        }else{
            _imageView.image=image;
            [self setImageFrameAndContentSize];
            _imageView.userInteractionEnabled=NO;
            UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicator.frame=CGRectMake((self.frame.size.width-20)/2, (self.frame.size.height-20)/2, 20, 20);
            [self addSubview:indicator];
            [indicator startAnimating];
            [[HBImageDownloader shareDownLoader]downloadImageWithURL:[NSURL URLWithString:url] progress:nil complete:^(UIImage *image, NSData *data, NSError *error, BOOL finished, HBImageGetFrom imageFrom) {
                if (imageFrom==HBImageGetFromWeb&&image) {
                    [indicator stopAnimating];
                    [indicator removeFromSuperview];
                    _imageView.image=image;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self setImageFrameAndContentSize];
                    } completion:^(BOOL finished) {
                        _imageView.userInteractionEnabled=YES;
                        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
                        [self addGestureRecognizer:longPress];
                    }];
                }
            } cacheType:HBImageCacheTypeMemory];
        }
    }
}

-(void)reset
{
    [self setZoomScale:1 animated:YES];
    [self setImageFrameAndContentSize];
}

@end
