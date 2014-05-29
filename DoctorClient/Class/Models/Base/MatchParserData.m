//
//  MatchParserData.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "MatchParserData.h"

@implementation MatchParserData

+(NSCache*)shareCache
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        [cache setTotalCostLimit:0.2*1024*1024];
    });
    return cache;
}

-(MatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        return _match;
    }else{
        NSString *key=[[NSString stringWithFormat:@"%@:%@",[self class],self.content] md5];
        MatchParser *parser=[[MatchParserData shareCache] objectForKey:key];
        if (parser) {
            _match=parser;
            parser.data=self;
            self.height=parser.height;
            return parser;
        }else{
            MatchParser* parser=[self createMatch:self.width];
            if (parser) {
                [[MatchParserData shareCache]  setObject:parser forKey:key];
            }
            return _match;
        }
    }
}
-(void)getMatch:(void (^)(MatchParser *, id))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        if (complete) {
            complete(_match,data);
        }
    }else{
        NSString *key=[[NSString stringWithFormat:@"%@:%@",[self class],self.content] md5];
        MatchParser *parser=[[MatchParserData shareCache] objectForKey:key];
        if (parser) {
            _match=parser;
            parser.data=self;
            self.height=parser.height;
            if (complete) {
                complete(_match,data);
            }
        }else{
            MatchParser* parser=[self createMatch:self.width];
            if (parser) {
                [[MatchParserData shareCache]  setObject:parser forKey:key];
            }
            if (complete) {
                complete(_match,data);
            }
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        return;
    }else{
        NSString *key=[[NSString stringWithFormat:@"%@:%@",[self class],self.content] md5];
        MatchParser *parser=[[MatchParserData shareCache] objectForKey:key];
        if (parser) {
            _match=parser;
            self.height=parser.height;
            parser.data=self;
        }else{
            MatchParser* parser=[self createMatch:200];
            if (parser) {
                [[MatchParserData shareCache]  setObject:parser forKey:key];
            }
        }
    }
}
-(void)setMatch:(MatchParser *)match1
{
    _match=match1;
}
-(MatchParser*)createMatch:(float)width
{
    NSString * content1=(NSString*)self.content;
    if(_match==nil||![_match isKindOfClass:[MatchParser class]]){
        MatchParser * parser=[[MatchParser alloc]init];
        parser.font=[UIFont systemFontOfSize:15];
        parser.iconSize=18;
        parser.keyWorkColor=[UIColor colorWithIntegerValue:HEIGHT_TEXT_COLOR alpha:1];
        parser.width=width;
        [parser match:content1];
        _match=parser;
        parser.data=self;
        self.height=parser.height;
        return parser;
    }
    return nil;
}

-(void)updateMatch:(void (^)(NSMutableAttributedString *, NSRange))link
{
    NSString * content1=(NSString*)self.content;
    if(_match!=nil||[_match isKindOfClass:[MatchParser class]]){
        [_match match:content1 atCallBack:nil title:nil link:link];
    }
}

@end
