//
//  XHBTalkPresence.h
//  DoctorClient
//
//  Created by weqia on 14-5-13.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XHBTalkPresenceStatus) {
    XHBTalkPresenceStatusAvailable,     //在线
    XHBTalkPresenceStatusAway,      //离开
    XHBTalkPresenceStatusDoNotDisturb,  //忙碌
    XHBTalkPresenceStatusUnavailable // 离线
};

@interface XHBTalkPresence : NSObject
@property(nonatomic,strong)NSString * friendJid;
@property(nonatomic)XHBTalkPresenceStatus status ;
@end
