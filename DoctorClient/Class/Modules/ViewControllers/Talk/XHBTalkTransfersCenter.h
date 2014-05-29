//
//  XHBTalkTransfersCenter.h
//  DoctorClient
//
//  Created by weqia on 14-5-10.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBTalkData.h"
#import "XMPP.h"
#import "XHBTalkPresence.h"

#define XHBTalkNewMenssageNotification  @"XHBTalkNewMenssageNotification"       //object  XHBTalkData
#define XHBTalkReceiptNotification  @"XHBTalkReceiptNotification"               // object NSString talkId
#define XHBTalkPresenceNotification @"XHBTalkPresenceNotification"          //  object XHBTalkPresence
#define XHBTalkConnectNotification @"XHBTalkConnectNotification"
@interface XHBTalkTransfersCenter : NSObject
@property(nonatomic,strong)XMPPStream * xmppStream;
@property(nonatomic,strong,readonly)NSMutableDictionary * uploadMsgs;
@property(nonatomic,strong,readonly)NSString * userName;
@property(nonatomic,strong,readonly)NSString * password;
@property(nonatomic,strong,readonly)NSString * host;
@property(nonatomic)BOOL connect;

+(instancetype)shareCenter;

-(void)connectToServer:(NSString*)userName password:(NSString*)password host:(NSString*)host;

-(void)sendMessage:(XHBTalkData*)data complete:(void(^)(BOOL success))complete;
@end
