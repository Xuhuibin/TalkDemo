//
//  XHBTalkGroupData.h
//  DoctorClient
//
//  Created by weqia on 14-5-13.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBTalkGroupData : NSObject
@property(nonatomic,strong)NSString * friendJid;
@property(nonatomic,strong)NSString * loginJid;
@property(nonatomic,strong)NSString * cname;
@property(nonatomic,strong)NSString * cheadUrl;
@property(nonatomic,strong)NSString * lastMsg;
@property(nonatomic,strong)NSString * lastTime;
@property(nonatomic)NSUInteger  newCount;
@end
