//
//  MatchParser.m
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "MatchParser.h"
#import "NSStrUtil.h"


static CGFloat ascentCallback( void *ref ){
    return 0;
}
static CGFloat descentCallback( void *ref ){
    return 0;
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
   // return 5;
}
static void deallocCallback(void * ref){

}

@implementation MatchParser
@synthesize attrString,images,font,textColor,keyWorkColor,iconSize,ctFrame=_ctFrame,height=_height,width,line,paragraph,data,source=_source,miniWidth=_miniWidth,numberOfTotalLines=_numberOfTotalLines,heightOflimit=_heightOflimit,urlLink,phoneLink,mobieLink;

-(id)init
{
    self=[super init];
    if(self){
        _strs=[[NSMutableArray alloc]init];
        self.font=[UIFont systemFontOfSize:14];
        self.textColor=[UIColor blackColor];
        self.keyWorkColor=[UIColor grayColor];
        self.iconSize=16.0f;
        self.line=5.0f;
        self.paragraph=5.0f;
        self.MutiHeight=18.0f;
        self.fristlineindent=5.0f;
        self.mobieLink=YES;
        self.urlLink=YES;
        self.phoneLink=YES;
    }
    return self;
}

+(NSDictionary*)getFaceMap
{
    static NSDictionary * dic=nil;
    if(dic==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dic;
}
+(NSString*)faceKeyForValue:(NSString*)value  map:(NSDictionary*) map
{
    NSArray * keys=[map allKeys];
    int count=[keys count];
    for(int i=0;i<count;i++)
    {
        NSString * key=[keys objectAtIndex:i];
        if([[map objectForKey:key] isEqualToString:value])
            return key;
    }
    return nil;
}

-(void)match:(NSString*)source
{
    if([NSStrUtil isEmptyOrNull:source])
        return;
    _source=source;
    source=[NSStrUtil trimString:source];
    NSMutableString * text=[[NSMutableString alloc]init];
    NSMutableArray * imageArr=[[NSMutableArray alloc]init];
    NSRegularExpression * regular=[[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray * array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    
    NSInteger location=0;
    int count=[array count];
    for(int i=0;i<count;i++){
        NSTextCheckingResult * result=[array objectAtIndex:i];
        NSString * string=[source substringWithRange:result.range];
        NSString * icon=[MatchParser faceKeyForValue:string map:[MatchParser getFaceMap]];
        [text appendString:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
        if(icon!=nil){
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
            NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:iconStr,MatchParserImage,[NSNumber numberWithInteger:[text length]],MatchParserLocation,[NSNull null],MatchParserRects, nil];
            [imageArr addObject:dic];
            [text appendString:@" "];
        }else{
            [text appendString:string];
        }
        location=result.range.location+result.range.length;
    }
    [text appendString:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]initWithString:text attributes:attribute];
  
    for(NSDictionary * dic in imageArr){
        NSInteger location= [[dic objectForKey:MatchParserLocation] integerValue];
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.getDescent=descentCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                 [NSNumber numberWithFloat:(self.iconSize+2)], @"width",
                                 nil] ;
        CTRunDelegateRef delegate=CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary* attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                //set the delegate
                                                (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                nil];

        [attStr addAttributes:attrDictionaryDelegate range:NSMakeRange(location, 1)];
    }
    [self matchLink:text attrString:attStr offset:0 link:nil];
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    CGFloat lineSpace=self.line;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //设置  段落间距
    CGFloat paragraphs = self.paragraph;
    CTParagraphStyleSetting paragraphStyle;
    paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphStyle.valueSize = sizeof(CGFloat);
    paragraphStyle.value = &paragraphs;
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,lineSpaceStyle,paragraphStyle
    };
    
    //设置样式
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [attStr addAttributes:attributes range:NSMakeRange(0, [text length])];
    CFRelease(fontRef);
    CFRelease(style);
    self.attrString=attStr;
    self.images=imageArr;
    [self buildFrames];

}

-(void)match:(NSString*)source    atCallBack:(BOOL(^)(NSString*))atString
{
    [self match:source atCallBack:atString title:nil];
}

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString*)title1
{
    [self match:source atCallBack:atString title:title1 link:nil];
}

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title1   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    if([NSStrUtil isEmptyOrNull:source]){
        if (title1!=nil&&[title1 isKindOfClass:[NSAttributedString class]]) {
            CGSize size=[title1.string sizeWithFont:self.font];
            _height=size.height;
            self.attrString=[[NSMutableAttributedString alloc]initWithAttributedString:title1];
            _titleOnly=YES;
        }
        return;
    }
    _title=title1;
    _source=source;
    source=[NSStrUtil trimString:source];
    NSMutableString * text=[[NSMutableString alloc]init];
    NSMutableArray * imageArr=[[NSMutableArray alloc]init];
    NSRegularExpression * regular=[[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray * array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    int offset=0;
    if(title1){
        offset=[title1 length];
    }
    NSInteger location=0;
    int count=[array count];
    for(int i=0;i<count;i++){
        NSTextCheckingResult * result=[array objectAtIndex:i];
        NSString * string=[source substringWithRange:result.range];
        NSString * icon=[MatchParser faceKeyForValue:string map:[MatchParser getFaceMap]];
        [text appendString:[source substringWithRange:NSMakeRange(location, result.range.location-location)]];
        if(icon!=nil){
            NSMutableString * iconStr=[NSMutableString stringWithFormat:@"%@.png",icon];
            NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:iconStr,MatchParserImage,[NSNumber numberWithInteger:[text length]+offset],MatchParserLocation,[NSNull null],MatchParserRects,[NSNull null],MatchParserLine, nil];
            [imageArr addObject:dic];
            [text appendString:@" "];
        }else{
            [text appendString:string];
        }
        location=result.range.location+result.range.length;
    }
    [text appendString:[source substringWithRange:NSMakeRange(location, [source length]-location)]];
    CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]init];
    if(title1!=nil&&[title1 isKindOfClass:[NSAttributedString class]])
        [attStr appendAttributedString:title1];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attribute]];
    
    for(NSDictionary * dic in imageArr){
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.getDescent=descentCallback;
        callbacks.dealloc=deallocCallback;
        
        NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                 [NSNumber numberWithFloat:(self.iconSize+2)], @"width",
                                 nil] ;
        CTRunDelegateRef  delegate=CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr));
        NSDictionary*attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                  //set the delegate
                                  (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                  nil];
        NSInteger location= [[dic objectForKey:MatchParserLocation] integerValue];
        [attStr addAttributes:attrDictionaryDelegate range:NSMakeRange(location, 1)];
    }
    regular=[[NSRegularExpression alloc]initWithPattern:@"@[^@\\s]+" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    array=[regular matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    for( NSTextCheckingResult * result in array){
        NSString * string =[text substringWithRange:result.range];
        if([string hasPrefix:@"@"]){
            string=[string substringFromIndex:1];
            if(atString){
                if(atString(string)){
                    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
                    [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
                }else{
                    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
                    [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
                }
            }else{
                NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.textColor.CGColor,kCTForegroundColorAttributeName,nil];
                [attStr addAttributes:attribute range:NSMakeRange(result.range.location+offset, result.range.length)];
            }
        }
    }
    [self matchLink:text attrString:attStr offset:offset link:link];
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    CGFloat lineSpace=self.line;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //设置  段落间距
    CGFloat paragraphs = self.paragraph;
    CTParagraphStyleSetting paragraphStyle;
    paragraphStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphStyle.valueSize = sizeof(CGFloat);
    paragraphStyle.value = &paragraphs;
        
    //多行行高
    CGFloat MutiHeight =self.MutiHeight;
    CTParagraphStyleSetting Muti;
    Muti.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Muti.value = &MutiHeight;
    Muti.valueSize = sizeof(float);
    
    
    //首行缩进
    CGFloat fristlineindent =self.fristlineindent;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(float);
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,lineSpaceStyle,paragraphStyle,Muti,fristline
    };
    
    
    //设置样式
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [attStr addAttributes:attributes range:NSMakeRange(0, [text length]+offset)];
    CFRelease(fontRef);
    CFRelease(style);
    self.attrString=attStr;
    self.images=imageArr;
    [self buildFrames];
}

#pragma -mark 私有方法

-(void)buildFrames
{
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(0,0, width, 10000);
    CGPathAddRect(path, NULL, textFrame );
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attrString length]), path, NULL);
 
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    
#pragma -mark 获得内容的总高度
    //获得内容的总高度
    if([lines count]>=1){
        float line_y = (float) origins[[lines count] -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineRef line1 = (__bridge CTLineRef) [lines lastObject];
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height =10000- line_y + descent+1 ;    //+1为了纠正descent转换成int小数点后舍去的值
       _height=total_height+2;
    }else{
        _height=0;
    }
    
    lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    CGPoint Origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), Origins); //2

#pragma -mark 获取内容行数 以及 一行时，内容的宽度
    // 获取内容行数 以及 一行时，内容的宽度
    _numberOfTotalLines=[lines count];
    if(_numberOfTotalLines>1){
        _miniWidth=self.width;
    }else{
        CTLineRef lineOne=(__bridge CTLineRef)lines[0];
        _miniWidth=CTLineGetTypographicBounds(lineOne, nil, nil, nil);
    }
    
#pragma -mark 获取限定行数后内容的高度
    //  获取限定行数后内容的高度
    if(_numberOfTotalLines<=_numberOfLimitLines||_numberOfLimitLines==0){
        _heightOflimit=_height;
    }else{
        CTLineRef line1=(__bridge CTLineRef)(lines[_numberOfLimitLines-1]);
        float line_y = (float) origins[_numberOfLimitLines -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height =10000- line_y + descent+1 ;    //+1为了纠正descent转换成int小数点后舍去的值
        _heightOflimit=total_height+2;
    }

    
#pragma -mark  解析表情图片
    // 解析表情图片
    if([self.images count]>0){
        int imgIndex = 0; //3
        NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
        NSRange imgLocation =[[nextImage objectForKey:MatchParserLocation] rangeValue];
        NSUInteger lineIndex = 0;
        for (id lineObj in lines) { //5
            CTLineRef line1 = (__bridge CTLineRef)lineObj;
            for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line1)) { //6
                CTRunRef run = (__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                if ( runRange.location==imgLocation.location) { //7
                    CGRect runBounds;
                    runBounds.size.width =iconSize; //8
                    runBounds.size.height =iconSize;
                    
                    CGPoint point;
                    CTRunGetPositions(run, CFRangeMake(0, 0), &point);
                    runBounds.origin.x = point.x+Origins[lineIndex].x+1;
                    runBounds.origin.y = point.y-4+Origins[lineIndex].y;
                    
                    //      NSLog(@"poing x: %f, y:%f",point.x,point.y);
                    NSMutableDictionary * dic=[self.images objectAtIndex:imgIndex];
                    [dic setObject:[NSValue valueWithCGRect:runBounds] forKey:MatchParserRects];
                    [dic setObject:[NSNumber numberWithInt:lineIndex] forKey:MatchParserLine];
                    //load the next image //12
                    
                    imgIndex++;
                    if (imgIndex < [self.images count]) {
                        nextImage = [self.images objectAtIndex: imgIndex];
                        imgLocation = [[nextImage objectForKey: MatchParserLocation] rangeValue];
                    }else{
                        lineIndex=[lines count];
                        break;
                    }
                }
            }
            if(lineIndex>=[lines count])
                break;
            lineIndex++;
        }
    }
    
#pragma -mark  解析网址链接
    // 解析网址链接
    if([self.links count]>0){
        int linkIndex = 0; //3
        NSDictionary* nextLink = [self.links objectAtIndex:linkIndex];
        NSRange linkRange =[[nextLink objectForKey:MatchParserRange] rangeValue];
        int lineIndex = 0;
        for (id lineObj in lines) { //5
            CTLineRef line1 = (__bridge CTLineRef)lineObj;
            for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line1)) { //6
                CTRunRef run = (__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                if ( runRange.location>=linkRange.location&&runRange.location<(linkRange.location+linkRange.length)) { //7
                    CGRect runBounds;
                    
                    CGFloat ascent;
                    CGFloat descent;
                    
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line1, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = Origins[lineIndex].x  + xOffset ;
                    runBounds.origin.y = Origins[lineIndex].y ;
                    runBounds.origin.y=10000-runBounds.origin.y-runBounds.size.height;
                    //      NSLog(@"poing x: %f, y:%f",point.x,point.y);
                    NSMutableDictionary * dic=[self.links objectAtIndex:linkIndex];
                    NSMutableArray * rects=[dic objectForKey:MatchParserRects];
                    [rects addObject:[NSValue valueWithCGRect:runBounds]];
                    //load the next image //12
                    if((runRange.location+runRange.length)>=(linkRange.location+linkRange.length)){
                        linkIndex++;
                        if (linkIndex < [self.links count]) {
                            nextLink = [self.links objectAtIndex: linkIndex];
                            linkRange = [[nextLink objectForKey: MatchParserRange] rangeValue];
                        }else{
                            _ctFrame=(__bridge id)frame;
                            CFRelease(frame);
                            CFRelease(path);
                            CFRelease(framesetter);
                            return;
                        }
                    }
                }
            }
            lineIndex++;
        }
    }
    _ctFrame=(__bridge id)frame;
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}
-(void)matchLink:(NSString*)text attrString:(NSMutableAttributedString*)attStr offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    _links=[[NSMutableArray alloc]init];
    if(self.urlLink){
        [self matchUrlLink:text attrString:attStr offset:offset link:link];
    }
    if(self.phoneLink){
        [self matchPhoneLink:text attrString:attStr offset:offset link:link];
    }
    if(self.mobieLink){
        [self matchMobieLink:text attrString:attStr offset:offset link:link];
    }
    [_links sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary * dic1=obj1;
        NSDictionary * dic2=obj2;
        NSRange range1=((NSValue *)[dic1 objectForKey:MatchParserRange]).rangeValue;
        NSRange range2=((NSValue *)[dic2 objectForKey:MatchParserRange]).rangeValue;
        if (range1.location<range2.location) {
            return  NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
}


//匹配网址
-(void)matchUrlLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypeUrl,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

//匹配手机号
-(void)matchMobieLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypeMobie,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}
//匹配座机号
-(void)matchPhoneLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\d{11,12})|(\\d{7,8})|((\\d{4}|\\d{3})-(\\d{7,8}))|((\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|((\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        NSRegularExpression*regular1=[[NSRegularExpression alloc]initWithPattern:@"^(\\(86\\))?(13[0-9]|15[7-9]|152|153|156|18[7-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
        NSString * string=[source substringWithRange:result.range];
        NSUInteger numberOfMatches = [regular1 numberOfMatchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
        if (numberOfMatches>0) {
            return;
        }
        if(link==nil){
            CTFontRef fontRef=CTFontCreateWithName((__bridge CFStringRef)(self.font.fontName),self.font.pointSize,NULL);
            NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(id)self.keyWorkColor.CGColor,kCTForegroundColorAttributeName,nil];
            [attrString1 addAttributes:attribute range:NSMakeRange(result.range.location+offset,result.range.length)];
            CFRelease(fontRef);
        }else{
            link(attrString1,NSMakeRange(result.range.location+offset,result.range.length));
        }
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:NSMakeRange(result.range.location+offset,result.range.length)],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypePhone,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}


@end
