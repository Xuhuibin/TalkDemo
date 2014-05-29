
//
//  XHBTalkData.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkData.h"

@implementation XHBTalkData

+(NSString *)getPrimaryKey
{
    return @"talkId";
}
+(NSString *)getTableName
{
    return @"XHBTalkData";
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.talkId=[[XHBDBHelper shareDBHelper] newIdforTable:[self class]];
    }
    return self;
}

-(void)formatInsertToDB:(void(^)(BOOL success))callback
{
    [[XHBDBHelper shareDBHelper] insertToDB:self callback:callback];
}
-(void)formatInsertToDB
{
    [self formatInsertToDB:nil];
}
-(void)formatUpdateToDb:(void (^)(BOOL))callback
{
    [[XHBDBHelper shareDBHelper] updateToDB:self where:[NSString stringWithFormat:@"talkId=%d",self.talkId] callback:callback];
}
-(void)formatUpdateToDb
{
    [self formatUpdateToDb:nil];
}


-(void)covert:(NSString*)msgBody
{
    NSDictionary * dic=[msgBody objectFromJSONString];
    if ([dic isKindOfClass:[NSDictionary class] ]) {
        NSString * type=[dic objectForKey:@"type"];
        if ([type isEqual:@"1"]) {
            self.type=XHBTalkContentTypeText;
        }else if([type isEqual:@"2"]){
            self.type=XHBTalkContentTypeImage;
        }else if([type isEqual:@"3"]){
            self.type=XHBTalkContentTypeSound;
        }
    }
    self.content=[dic objectForKey:@"content"];
}
-(NSString*)getMsgBody
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    if (self.type==XHBTalkContentTypeText) {
        [dic setObject:@"1" forKey:@"type"];
    }else if(self.type==XHBTalkContentTypeImage){
        [dic setObject:@"2" forKey:@"type"];
    }else if(self.type==XHBTalkContentTypeSound){
        [dic setObject:@"3" forKey:@"type"];
    }
    [dic setObject:self.content forKey:@"content"];
    return [dic JSONString];
}

@end
