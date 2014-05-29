//
//  XHBTalkUploadCenter.m
//  DoctorClient
//
//  Created by weqia on 14-5-10.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkUploadCenter.h"

@implementation XHBTalkUploadCenter

+(instancetype)shareCenter
{
    static XHBTalkUploadCenter * center=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center=[[XHBTalkUploadCenter alloc]init];
    });
    return center;
}
-(void)sendMessage:(XHBTalkData*)data complete:(void(^)(BOOL success))complete
{
    if (data.type==XHBTalkContentTypeText) {
    }else if(data.type==XHBTalkContentTypeImage){
    }else if(data.type==XHBTalkContentTypeSound){
    }
}

@end
