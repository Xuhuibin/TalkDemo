//
//  XHBTalkViewController.h
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBTalkToolBar.h"
#import "XHBBaseViewController.h"
#import "RecordAudio.h"
#import "PlayAudio.h"
#import "XHBTalkTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "PageHeadView.h"
#import "XHBTalkTransfersCenter.h"
#import "XHBTalkGroupData.h"
@interface XHBTalkViewController : XHBBaseViewController<XHBTalkToolBarDelegate,XHBVoiceRecordButtonDelegate,RecordAudioDelegate,UITableViewDelegate,UITableViewDataSource,XHBTalkTableViewCellDelegate,HBCoreLabelDelegate,PlayAudioDelegate,UIActionSheetDelegate>

@property(nonatomic,strong,readonly)XHBTalkToolBar * toolBar;
@property(nonatomic,strong,readonly)UITableView * chatView;
@property(nonatomic,strong)NSMutableArray * chatArray;
@property(nonatomic,strong)PageHeadView * headView;
@property(nonatomic,strong,readonly)RecordAudio* record;
@property(nonatomic,strong,readonly)PlayAudio * palyaudio;
@property(nonatomic,strong,readonly)XHBTalkData * playData;

@property(nonatomic,weak)IBOutlet UIView * disconnectView;


@property(nonatomic,strong)IBOutlet id<UIViewControllerOperationDelegate>selectImage;

@property(nonatomic,strong)IBOutlet id<UIViewControllerOperationDelegate>selectVedio;

@property(nonatomic,strong)IBOutlet id<UIViewControllerOperationDelegate>selectPlace;

@property(nonatomic,strong)IBOutlet id<UIViewControllerOperationDelegate>selectFile;

@property(nonatomic,strong)IBOutlet id<UIViewControllerOperationDelegate>lookBigImage;


///////////以下为调用聊天界面的接口

@property(nonatomic,strong)NSString * loginJid;
@property(nonatomic,strong)NSString * friendJid;
@property(nonatomic,strong)NSString * loginHeadUrl;
@property(nonatomic,strong)NSString * loginCname;
@property(nonatomic,strong)NSString * host;
@property(nonatomic,strong)NSString * friendName;
+(void)getGrouptTalkData:(NSString*)loginJid offset:(NSUInteger)offset limit:(NSUInteger)limit callback:(void(^)(NSArray* groups))callback; //获取聊天记录的分组信息。
@end
