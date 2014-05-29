//
//  XHBTalkTransfersCenter.m
//  DoctorClient
//
//  Created by weqia on 14-5-10.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkTransfersCenter.h"
#import "HBFileCache.h"
#import "UserService.h"
#import "NSTimeUtil.h"
#import "NSXMLProperty.h"
#import "NetworkUtil.h"
@implementation XHBTalkTransfersCenter
@synthesize xmppStream;
+(instancetype)shareCenter
{
    static XHBTalkTransfersCenter * center=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center=[[XHBTalkTransfersCenter alloc]init];
    });
    return center;
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _uploadMsgs=[NSMutableDictionary dictionary];
    }
    return self;
}

-(void)connectToServer:(NSString*)userName password:(NSString*)password host:(NSString*)host
{
    [xmppStream disconnect];
    xmppStream=nil;
    if (userName==nil||password==nil||host==nil) {
        return;
    }
    _userName=userName;
    _password=password;
    _host=host;
    _connect=[self connect];
}



-(void)sendMessage:(XHBTalkData*)data complete:(void(^)(BOOL success))complete
{
    if (![NetworkUtil getNetworkStatue]) {
        data.status=XHBTalkStatusUploadFailed;
        [data formatUpdateToDb];
        if (complete) {
            complete(NO);
        }
        [self removeTalkDataForTalkID:data.talkId];
        return;
    }
    [_uploadMsgs setObject:data forKey:[NSNumber numberWithInteger:data.talkId]];
    if (data.type==XHBTalkContentTypeText) {
        [self sendXmppMessage:data complete:complete];
    }else if(data.type==XHBTalkContentTypeImage){
        [self uploadData:^(BOOL success, id url) {
            if (success) {
                [[HBFileCache shareCache] forwardDataFromKey:data.content forKey:url];
                data.content=url;
                [self sendXmppMessage:data complete:complete];
            }else{
                data.status=XHBTalkStatusUploadFailed;
                [data formatUpdateToDb];
                if (complete) {
                    complete(NO);
                }
                [self removeTalkDataForTalkID:data.talkId];
            }
        } data:data];
    }else if(data.type==XHBTalkContentTypeSound){
        [self uploadData:^(BOOL success, id url) {
            if (success) {
                [[HBFileCache shareCache] forwardDataFromKey:data.content forKey:url];
                data.content=url;
                [self sendXmppMessage:data complete:complete];
            }else{
                data.status=XHBTalkStatusUploadFailed;
                [data formatUpdateToDb];
                if (complete) {
                    complete(NO);
                }
                [self removeTalkDataForTalkID:data.talkId];
            }
        }data:data];
    }
}
-(void)removeTalkDataForTalkID:(NSInteger)talkID
{
    [_uploadMsgs removeObjectForKey:[NSNumber numberWithInteger:talkID]];
}


-(void)uploadData:(void(^)(BOOL success,id url))complete data:(XHBTalkData*)data
{
    if (data.fileUploaded) {
        if (complete) {
            complete(YES,data.content);
        }
    }else{
        ServiceParam * param=[[ServiceParam alloc]init];
        
        
        [param put:@"from" withValue:data.loginId];
        [param put:@"to" withValue:data.friendId];
        NSString * fileName,*type;
        if (data.type==XHBTalkContentTypeImage) {
            fileName=@"file.jpg";
            type=@"image";
        }else{
            fileName=@"file.amr";
            type=@"voice";
            [param put:@"recodTime" withValue:[NSString stringWithFormat:@"%ld",(long)data.soundTime]];
        }
        [param put:@"type" withValue:type];
         [param putFile:@"file" withValue:[[HBFileCache shareCache] filePathForKey:data.content]  name:fileName  mimeType:nil fileType:nil];
        [[[UserService alloc]init] uploadFileToServer:param completeBlock:^(id result) {
            if (complete) {
                complete(YES,result);
            }
        } failedBlock:^(id result) {
            if (complete) {
                complete(NO ,nil);
            }
        } view:nil];
    }
}
// XMPP

-(void)setupStream{
    
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream setEnableBackgroundingOnSocket:YES];
}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)connect{
    [self setupStream];
    //从本地取得用户名，密码和服务器地址
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:_userName]];
    //设置服务器
    [xmppStream setHostName:_host];
    //密码
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:20 error:&error]) {
        NSLog(@"cant connect ");
        return NO;
    }
    return YES;
}

-(void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
    _connect=NO;
}
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:_password error:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkConnectNotification object:[NSNumber numberWithBool:YES ] userInfo:nil];
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkConnectNotification object:[NSNumber numberWithBool:NO ] userInfo:nil];
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self goOnline];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSXMLElement *received = [message elementForName:@"received"];
    if (received)
    {
        if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            NSString*  receiptsId;
            if([received attributeForName:@"id"]){
                receiptsId=[[received attributeForName:@"id"]stringValue];
            }else{
                receiptsId=[[message attributeForName:@"id"]stringValue];
            }
            XHBTalkData* data=[[XHBDBHelper shareDBHelper] searchSingle:[XHBTalkData class] where:[NSString stringWithFormat:@"receiptsId='%@'",receiptsId] orderBy:nil];
            data.receipts=XHBTalkReachStatuReach;
            [data formatUpdateToDb];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkReceiptNotification object:[NSNumber numberWithDouble:data.talkId] userInfo:nil];
            return;
        }
    }
    //    NSLog(@"message = %@", message);
    NSXMLElement *request = [message elementForName:@"request"];
	if (request)
	{
		if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
		{
			//组装消息回执
			XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
			NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [received addAttributeWithName:@"id" stringValue:[message attributeStringValueForName:@"id"]];
			[msg addChild:recieved];
			
			//发送回执
			[self.xmppStream sendElement:msg];
		}
	}
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString * to=[[message attributeForName:@"to"] stringValue];
    NSString * subject=[[message elementForName:@"subject"]stringValue];
    
    NSRange range=[to rangeOfString:@"@"];
    NSMutableString * too=[NSMutableString stringWithString:[to substringToIndex:range.location]];
    
    
    range=[from rangeOfString:@"@"];
    NSMutableString * fromm=[NSMutableString stringWithString:[from substringToIndex:range.location]];
    
    //消息委托(这个后面讲)
    XHBTalkData * data=[[XHBTalkData alloc]init];
    data.friendId=[NSString stringWithString:fromm];
    data.loginId=[NSString stringWithString:too];
    
    [too appendFormat:@"@%@",_host];
    [fromm appendFormat:@"@%@",_host];
    data.friendJid=fromm;
    data.loginJid=too;
    
    NSXMLElement *properties=[message elementForName:@"properties"];
    for (NSXMLElement * ele in properties.children) {
        if ([ele.name isEqualToString:@"property"]) {
            [NSXMLProperty parserElement:ele callback:^(NSString *name, NSString *value) {
                if ([name isEqualToString:@"friendHeadUrl"]) {
                    data.friendHeadUrl=value;
                }else if([name isEqualToString:@"cname"]){
                    data.friendName=value;
                }else if([name isEqualToString:@"property"]){
                    data.soundTime=value.integerValue;
                }
            }];
        }
    }
    data.content=msg;
    data.time=[NSTimeUtil getNowTime];
    if ([subject isEqualToString:@"voice"]) {
        data.type=XHBTalkContentTypeSound;
    }else if([subject isEqualToString:@"image"]){
        data.type=XHBTalkContentTypeImage;
    }else{
        data.type=XHBTalkContentTypeText;
        data.width=200;
    }
    
    [data formatInsertToDB:^(BOOL success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkNewMenssageNotification object:data userInfo:nil];
    }];
}


//消息发送失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSXMLElement * ele=[message elementForName:@"talkId"];
    XHBTalkData * data=[[XHBDBHelper shareDBHelper] searchSingle:[XHBTalkData class] where:[NSString stringWithFormat:@"talkId=%d",ele.stringValueAsInt] orderBy:nil];
    data.status=XHBTalkStatusUploadFailed;
    [data formatUpdateToDb];
}

// 获取好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type];
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
        XHBTalkPresence * presence=[[XHBTalkPresence alloc]init];
        presence.friendJid=presenceFromUser;
        if ([presenceType isEqualToString:@"available"]) {
            presence.status=XHBTalkPresenceStatusAvailable;
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            presence.status=XHBTalkPresenceStatusUnavailable;
        }else if ([presenceType isEqualToString:@"do not disturb"]){
            presence.status=XHBTalkPresenceStatusDoNotDisturb;
        }else if ([presenceType isEqualToString:@"away"]){
            presence.status=XHBTalkPresenceStatusAway;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkPresenceNotification object:presence userInfo:nil];
}



-(void)sendXmppMessage:(XHBTalkData*)data complete:(void(^)(BOOL success))complete
{
    if (xmppStream.isConnected&&[NetworkUtil getNetworkStatue]) {
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        [mes addAttributeWithName:@"id" stringValue:data.receiptsId];
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:data.content];
        
        [mes addChild:body];
        //生成XML消息文档
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:data.friendJid];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:_userName];
        
        NSXMLElement *properties=[NSXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];   //<properties xmlns="http://www.jivesoftware.com/xmlns/xmpp/properties">
        NSXMLElement * ele=[NSXMLProperty propertyElement:_userName forName:@"LoginJid"];
        [properties addChild:ele];
        
        ele=[NSXMLProperty propertyElement:data.friendHeadUrl forName:@"friendHeadUrl"];
        [properties addChild:ele];
        
        ele=[NSXMLProperty propertyElement:data.friendName forName:@"cname"];
        [properties addChild:ele];
        
        if (data.type==XHBTalkContentTypeSound) {
            ele=[NSXMLProperty propertyElement:[NSString stringWithFormat:@"%ld",(long)data.soundTime] forName:@"property"];
            [properties addChild:ele];
        }else if(data.type==XHBTalkContentTypeImage){
            ele=[NSXMLProperty propertyElement:[NSString stringWithFormat:@"%ld",(long)data.soundTime] forName:@"property"];
            [properties addChild:ele];
        }
        ele=[NSXMLProperty propertyElement:[NSString stringWithFormat:@"%@",data.content] forName:@"fileSendPath"];
        [properties addChild:ele];
       
        ele=[NSXMLProperty propertyElement:data.receiptsId forName:@"packetID"];
        [properties addChild:ele];
        
        [mes addChild:properties];
        NSXMLElement * subject=[NSXMLElement elementWithName:@"subject"];
        if (data.type==XHBTalkContentTypeImage) {
            [subject setStringValue:@"image"];
        }else if(data.type==XHBTalkContentTypeSound){
            [subject setStringValue:@"voice"];
        }else{
            [subject setStringValue:@"text"];
        }
        [mes addChild:subject];
        
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [mes addChild:receipt];
        //发送消息
        [[self xmppStream] sendElement:mes];
        data.status=XHBTalkStatusUploadFinish;
        [data formatUpdateToDb];
        if (complete) {
            complete(YES);
        }
        [self removeTalkDataForTalkID:data.talkId];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:XHBTalkConnectNotification object:[NSNumber numberWithBool:NO ] userInfo:nil];
        data.status=XHBTalkStatusUploadFailed;
        [data formatUpdateToDb];
        if (complete) {
            complete(NO);
        }
        [self removeTalkDataForTalkID:data.talkId];
    }
}


@end
