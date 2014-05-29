//
//  XHBTalkUploadCenter.h
//  DoctorClient
//
//  Created by weqia on 14-5-10.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBTalkData.h"
@interface XHBTalkUploadCenter : NSObject
+(instancetype)shareCenter;

-(void)sendMessage:(XHBTalkData*)data complete:(void(^)(BOOL success))complete;


@end
