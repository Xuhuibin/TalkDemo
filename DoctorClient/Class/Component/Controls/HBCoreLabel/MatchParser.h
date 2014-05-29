//
//  MatchParser.h
//  CoreTextMagazine
//
//  Created by weqia on 13-10-27.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#define BEGIN_TAG @"["
#define END_TAG @"]"

#define MatchParserString @"string"
#define MatchParserRange @"range"
#define MatchParserRects @"rects"
#define MatchParserImage @"image"
#define MatchParserLocation @"location"
#define MatchParserLine @"line"
#define MatchParserLinkType @"lineType"

#define  MatchParserLinkTypeUrl @"MatchParserLinkTypeUrl"
#define  MatchParserLinkTypePhone @"MatchParserLinkTypePhone"
#define  MatchParserLinkTypeMobie   @"MatchParserLinkTypeMobie"

@class MatchParser;
@protocol MatchParserDelegate <NSObject>
@property(nonatomic,weak,getter = getMatch,setter = setMatch:) MatchParser * match;
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;
-(MatchParser*)createMatch:(float)width;

@optional
-(void)setMatch;
-(void)setMatch:(MatchParser *)match;
-(MatchParser*)getMatch;
-(void)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data;


@end


@interface MatchParser : NSObject
{
    NSMutableArray * _strs;
    
    NSString * _source;
    
    float _height;
    
    id _ctFrame;
    
    float _miniWidth;
    
    int _numberOfTotalLines;
    
    float _heightOflimit;

}
@property(nonatomic,strong) NSMutableAttributedString * attrString;
@property(nonatomic,strong) NSArray * images;
@property(nonatomic,readonly) NSMutableArray * links;


@property(nonatomic,strong) UIFont * font;

@property(nonatomic,strong) UIColor * textColor;
@property(nonatomic,strong) UIColor * keyWorkColor;

@property(nonatomic) float line;            //行距
@property(nonatomic) float paragraph;   // 段落间距
@property(nonatomic) float MutiHeight;  //多行行高
@property(nonatomic) float fristlineindent; // 首行缩进
@property(nonatomic) float iconSize;    // 表情Size
@property(nonatomic) float width;       // 宽度
@property(nonatomic) int numberOfLimitLines;   // 行数限定 (等于0 代表 行数不限)
@property(nonatomic) BOOL phoneLink;
@property(nonatomic) BOOL mobieLink;
@property(nonatomic) BOOL urlLink;
@property(nonatomic,readonly) BOOL titleOnly;
@property(nonatomic,readonly) NSAttributedString * title;
@property(nonatomic,readonly) id ctFrame;
@property(nonatomic,readonly)float height;        // 总内容的高度
@property(nonatomic,readonly)float heightOflimit;   // 限定行数后的内容高度
@property(nonatomic,readonly)float miniWidth;       //只有一行时，内容宽度
@property(nonatomic,readonly)int numberOfTotalLines;         //内容行数
@property(nonatomic,readonly) NSString * source;      //原始内容

@property(nonatomic,weak) id<MatchParserDelegate> data;

-(void)match:(NSString*)text;

-(void)match:(NSString*)text   atCallBack:(BOOL(^)(NSString*))atString;

-(void)match:(NSString *)source  atCallBack:(BOOL (^)(NSString *))atString title:(NSAttributedString*)title;

-(void)match:(NSString *)source   atCallBack:(BOOL (^)(NSString *))atString   title:(NSAttributedString *)title   link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link;

@end
