//
//  XHBTalkViewController.m
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkViewController.h"
#import "XHBVoiceRecordProgressView.h"
#import "UITableView+Scroll.h"
#import "NSTimeUtil.h"
#import "BrowseViewController.h"
#import "NetworkUtil.h"
#import "HBFileCache.h"
#import "SelectImageTool.h"
#import "LookBigImageTool.h"
@interface XHBTalkViewController ()
{
    NSString * phoneNumber;
    UIWebView * webView;
}
@end

@implementation XHBTalkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[XHBDBHelper shareDBHelper] createTableWithModelClass:[XHBTalkData class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceive:) name:XHBTalkNewMenssageNotification object:nil];
    // Do any additional setup after loading the view.
    _chatView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-108)];
    [_chatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _chatView.delegate=self;
    _chatView.dataSource=self;
    [self.view addSubview:_chatView];
    
    XHBTalkToolBar * toolBar=[XHBTalkToolBar newTalkToolBar:self];
    CGRect frame=toolBar.frame;
    frame.origin.y=self.view.frame.size.height-44;
    toolBar.frame=frame;
    [self.view addSubview:toolBar];
    _toolBar=toolBar;
    _toolBar.delegate=self;
    _toolBar.recordVoice.delegate=self;
    
    [self.view addTapAction:self action:@selector(tapAction)];
    _chatArray=[NSMutableArray array];
    
    _record=[[RecordAudio alloc]init];
    _record.delegate=self;
    
    _palyaudio=[[PlayAudio alloc]init];
    _palyaudio.delegate=self;
    
    [self loadTalkDatas];
    
    _headView=[[PageHeadView alloc]initWithFrame:CGRectMake(0, -60, 320, 60)];
    [self.chatView addSubview:_headView];
    [_headView setTarget:self];
    [_headView addBeginLoadAction:@selector(headViewBeginLoad)];
    
    [[XHBDBHelper shareDBHelper] updateToDB:[XHBTalkData class] set:[NSString stringWithFormat:@"readed=1"] where:[NSString stringWithFormat:@"friendId='%@' and loginId='%@'",self.friendJid,self.loginJid]];
    
    self.navigationItem.title=self.friendName;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectNotification:) name:XHBTalkConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange) name:NetWorkStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiptNotification:) name:XHBTalkReceiptNotification object:nil];
    
    if ([[[XHBTalkTransfersCenter shareCenter] xmppStream]isConnected]&&[NetworkUtil getNetworkStatue]) {
        self.disconnectView.hidden=YES;
    }else{
        self.disconnectView.hidden=NO;
    }
    [self.view bringSubviewToFront:self.disconnectView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)tapAction
{
    [_toolBar  dismissKeyBoard];
}
-(void)headViewBeginLoad
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadTalkDatas];
    });
}

-(void)loadTalkDatas
{
    [NSGCDThread dispatchAsync:^{
        NSUInteger count=_chatArray.count;
        NSArray * array=[[XHBDBHelper shareDBHelper] search:[XHBTalkData class] where:[NSString stringWithFormat:@"friendId='%@' and loginId='%@'",self.friendJid,self.loginJid] orderBy:@"time desc" offset:count count:10];
        NSMutableArray * datas=[NSMutableArray array];
        if (array.count>0) {
            for (int i=array.count-1;i>=0;i--) {
                XHBTalkData * data=[array objectAtIndex:i];
                XHBTalkData * talk=[[XHBTalkTransfersCenter shareCenter].uploadMsgs objectForKey:[NSNumber numberWithInteger:data.talkId]];
                if (talk) {
                    [datas addObject:talk];
                }else{
                    if (data.type==XHBTalkContentTypeText) {
                        [data setMatch];
                    }
                    [datas addObject:data];
                }
            }
        }
        if (self.chatArray) {
            [datas addObjectsFromArray:self.chatArray];
        }
        [self initShowTime:datas];
        [NSGCDThread dispatchAsyncInMailThread:^{
            [_headView loadFinish];
            self.chatArray=datas;
            [self.chatView reloadData];
            if (count==0) {
                [_chatView scrollToBottom:NO];
            }
        }];
    }];
}

-(void)initShowTime:(NSArray*)array
{
    XHBTalkData * preData=nil;
    for (int i=0; i<array.count; i++) {
        XHBTalkData * data=[array objectAtIndex:i];
        if (data.time.intValue-preData.time.intValue>5*60*60) {
            data.showTime=YES;
        }
        preData=data;
    }
}

-(void)newMessageReceive:(NSNotification*)notification
{
    XHBTalkData * data=[notification object];
    if ([data.friendId isEqual:self.friendJid]) {
        for (XHBTalkData * talk in self.chatArray) {
            if (talk.talkId==data.talkId) {
                return;
            }
        }
        if (data.type==XHBTalkContentTypeText) {
            [data setMatch];
        }
        XHBTalkData * preData=[self.chatArray lastObject];
        if (data.time.intValue-preData.time.intValue>5*60*60) {
            data.showTime=YES;
        }
        data.readed=YES;
        [data  formatUpdateToDb];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_chatArray addObject:data];
           [self.chatView reloadData];
            [_chatView scrollToBottom];
        });
    }
}
-(void)connectNotification:(NSNotification*)notification
{
    NSNumber * number=[notification object];
    if (number.boolValue) {
        self.disconnectView.hidden=YES;
    }else{
        self.disconnectView.hidden=NO;
        if ([NetworkUtil getNetworkStatue]) {
           [[XHBTalkTransfersCenter shareCenter]  connectToServer:[NSString stringWithFormat:@"%@@%@",self.loginJid,self.host] password:@"123" host:self.host];
        }
    }
}
-(void)receiptNotification:(NSNotification*)notification
{
    NSNumber * number=[notification object];
    if (number) {
        NSUInteger talkId=number.integerValue;
        for (XHBTalkData  * data in self.chatArray) {
            if (data.talkId==talkId) {
                data.receipts=XHBTalkReachStatuReach;
                break;
            }
        }
    }
    [self.chatView reloadData];
}
-(void)netChange
{
    if ([NetworkUtil getNetworkStatue] ) {
        if ([[[XHBTalkTransfersCenter shareCenter] xmppStream] isConnected]) {
            self.disconnectView.hidden=YES;
        }else{
            self.disconnectView.hidden=NO;
            [[XHBTalkTransfersCenter shareCenter]  connectToServer:[NSString stringWithFormat:@"%@@%@",self.loginJid,self.host] password:@"123" host:self.host];
        }
    }else{
        self.disconnectView.hidden=NO;
    }
}

#pragma -mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBTalkData * talk=[self.chatArray objectAtIndex:indexPath.row];
    return [XHBTalkTableViewCell heightForData:talk];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBTalkData * talk=[self.chatArray objectAtIndex:indexPath.row];
    XHBTalkTableViewCell* cell= [XHBTalkTableViewCell tableViewCellFor:talk tableView:self.chatView controller:self];
    cell.delegate=self;
    cell.tableView=self.chatView;
    [cell loadContent:talk];
    return  cell;
}
#pragma mark scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate //手指弹开时调用的委托方法
{
    [_headView scrollViewDidEndDecelerating:scrollView];
}

-(void)talkTableCell:(XHBTalkTableViewCell *)cell palySoundAction:(XHBTalkData *)data readyCallback:(void(^)(BOOL ready))callback
{
    if (_playData!=data) {
        _playData.soundStatu=XHBTalkSoundStatusNormal;
    }
    [_palyaudio play:data.content readyCallback:callback];
    _playData=(XHBTalkData*)data;
}
-(void)talkTableCell:(XHBTalkTableViewCell*)cell  deleteAction:(XHBTalkData*)data
{
    NSUInteger index=-1;
    for (NSUInteger i =0; i<_chatArray.count; i++) {
        XHBTalkData * talk=[_chatArray objectAtIndex:i];
        if (talk.talkId==data.talkId) {
            index=i;
            break;
        }
    }
    if (index>=0) {
        [_chatArray removeObjectAtIndex:index];
    }
    [[XHBDBHelper shareDBHelper] deleteToDB:data];
    [_chatView reloadData];
    
}

-(void)talkTableCell:(XHBTalkTableViewCell *)cell stopPalySoundAction:(XHBTalkData *)data
{
    [_palyaudio stopPlay];
    _playData=nil;
}


#pragma  -mark XHBVoiceRecordButtonDelegate
-(void)voiceRecordBeginRecord:(XHBVoiceRecordButton*)button
{
    [[XHBVoiceRecordProgressView shareButton] show];
    [self startRecord];
}

-(void)voiceRecordEndRecord:(XHBVoiceRecordButton *)button timeDuration:(float)duration
{
    [[XHBVoiceRecordProgressView shareButton] hide];
    [self stopRecord:duration];
}

-(void)voiceRecordCancelRecord:(XHBVoiceRecordButton *)button
{
    [[XHBVoiceRecordProgressView shareButton] hide];
    [self cancelRecord];
}

-(void)voiceRecordContinueRecord:(XHBVoiceRecordButton *)button
{
    [[XHBVoiceRecordProgressView shareButton] reShow];
}

-(void)voiceRecordWillCancelRecord:(XHBVoiceRecordButton *)button
{
    [[XHBVoiceRecordProgressView shareButton] willHide];
}
-(void)voiceRecordRecordTimeSmall:(XHBVoiceRecordButton *)button
{
    [[XHBVoiceRecordProgressView shareButton] recordTimeSmall];
    [self cancelRecord];
}
-(void)voiceRecordRecordTimeBig:(XHBVoiceRecordButton *)button
{

    [self stopRecord:60];
    [[XHBVoiceRecordProgressView shareButton]  recordTimeBig];
}

#pragma  -makr XHBTalkToolBarDelegate
-(void)talkToolBar:(XHBTalkToolBar*)toolBar sendText:(NSString*)text
{
    [self.chatView scrollToBottom];
    [self sendTextMessage:text];
}
-(void)talkToolBar:(XHBTalkToolBar*)toolBar changeHeight:(float)height
{
    [self.chatView scrollToBottom];
    if (self.chatView.contentSize.height<self.chatView.frame.size.height) {
        float y=44-height+(self.chatView.frame.size.height-self.chatView.contentSize.height);
        if (y>0) {
            y=0;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.chatView.frame=CGRectMake(0, y, 320, self.chatView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.chatView.frame=CGRectMake(0, 44-height, 320, self.chatView.frame.size.height);
        }];
    }
}
-(void)talkToolBarSelectImage:(XHBTalkToolBar*)toolBar
{
    if (self.selectImage&&[self.selectImage respondsToSelector:@selector(selectImage:viewController:sourceType:)]) {
        [self.selectImage selectImage:^(UIImage *image) {
            if (image) {
                [self sendImageMessage:image];
            }
        } viewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

-(void)talkToolBarTakeImage:(XHBTalkToolBar*)toolBar
{
    if (self.selectImage&&[self.selectImage respondsToSelector:@selector(selectImage:viewController:sourceType:)]) {
        [self.selectImage selectImage:^(UIImage *image) {
            if (image) {
                [self sendImageMessage:image];
            }
        } viewController:self sourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma -mark RecordAudioDelegate
- (void)updateMeters:(RecordAudio*)record level:(int)level
{
    [[XHBVoiceRecordProgressView shareButton] setStrength:level];
}

#pragma -mark PlayAudioDelegate
-(void)PlayStatus:(int)status
{
    if (status==1) {
        _playData.soundStatu=XHBTalkSoundStatusNormal;
        [self.chatView reloadData];
    }
}

#pragma -mark  XHBTalkTableViewCellDelegate
-(void)talkTableViewCell:(XHBTalkTableViewCell*)cell lookImage:(UIImageView*)imageView
{
    if (self.lookBigImage&&[self.lookBigImage respondsToSelector:@selector(lookBigImage:smallImageViews:bigImageUrls:viewController:)]) {
        if (cell.talk.content) {
            NSArray * smalls=[NSArray arrayWithObject:imageView];
            NSMutableString * url=[NSMutableString stringWithString:cell.talk.content];
            NSRange range=[url rangeOfString:@"_small"];
            if (range.location!=NSNotFound) {
                [url replaceCharactersInRange:range withString:@"_large"];
                NSArray * bigs=[NSArray arrayWithObject:url];
                 [self.lookBigImage lookBigImage:imageView smallImageViews:smalls bigImageUrls:bigs viewController:self];
            }else{
                NSArray * bigs=[NSArray arrayWithObject:cell.talk.content];
                [self.lookBigImage lookBigImage:imageView smallImageViews:smalls bigImageUrls:bigs viewController:self];
            }
        }
    }
}


#pragma -mark  HBCoreLabelDelegate
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{
    BrowseViewController * controller=(BrowseViewController*)[self viewControllerForName:@"BrowseViewController" Class:[BrowseViewController class]];
    controller.url=linkStr;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",nil, nil];
    action.tag=102;
    phoneNumber=linkStr;
    [action showInView:self.view.window];
}
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",nil, nil];
    action.tag=102;
    phoneNumber=linkStr;
    [action showInView:self.view.window];
}
#pragma mark -ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==102){
        if(0==buttonIndex){
            NSString * string=[NSString stringWithFormat:@"tel:%@",phoneNumber];
            if(webView==nil)
                webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            webView.hidden=YES;
            [self.view addSubview:webView];
        }
    }else if (actionSheet.tag==103){
        if(0==buttonIndex){
            NSString * string=[NSString stringWithFormat:@"tel:%@",phoneNumber];
            if(webView==nil)
                webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            webView.hidden=YES;
            [self.view addSubview:webView];
        }else if(1==buttonIndex){
            MFMessageComposeViewController* contrller=[[MFMessageComposeViewController alloc]init];
            contrller.recipients=[NSArray arrayWithObject:phoneNumber];
            [self presentViewController:contrller animated:YES completion:nil];
        }
    }
}

#pragma -mark 私有
-(void) startRecord {
     [_record startRecord];
}
// 发送语音消息
-(void)stopRecord:(NSUInteger)duration {
    NSData *data = [_record stopRecord];
    [self sendSoundMessage:data durtion:duration];
}
-(void)cancelRecord{
    [_record cancelRecord];
}

-(void)sendTextMessage:(NSString*)text
{
    if ([NSStrUtil isEmptyOrNull:text]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"内容不能为空"];
        return;
    }
    XHBTalkData * data=[[XHBTalkData alloc]init];
    data.type=XHBTalkContentTypeText;
    data.content=text;
    data.width=200;
    [data setMatch];
    [self sendMessage:data];
}

-(void)sendImageMessage:(UIImage*)image
{
    XHBTalkData * data=[[XHBTalkData alloc]init];
    data.type=XHBTalkContentTypeImage;
    data.content=[[HBFileCache shareCache] storeFile:UIImagePNGRepresentation(image)];
    [self sendMessage:data];
}

-(void)sendSoundMessage:(NSData*)sound durtion:(NSUInteger)durtion
{
    XHBTalkData * data=[[XHBTalkData alloc]init];
    data.type=XHBTalkContentTypeSound;
    data.soundTime=durtion;
    data.content=[[HBFileCache shareCache] storeFile:sound];
    [self sendMessage:data];
}

-(NSString*)getRandom
{
    int y = (arc4random() % 1000) + 8999;
    NSDate *date=[NSDate date];
    NSTimeInterval  time=[date timeIntervalSince1970];
    NSString * string=[NSString stringWithFormat:@"%.0f_%d",time*100000,y];
    return string;
}

-(void)sendMessage:(XHBTalkData*)data
{
    data.receiptsId=[self getRandom];
    data.readed=YES;
    data.time=[NSTimeUtil getNowTime];
    data.status=XHBTalkStatusIsUploading;
    data.fromSelf=YES;
    data.width=200;
    if (!self.loginHeadUrl) {
        data.friendHeadUrl=@"http://ejt.s2.c2d.me/images/common/noavatar_large.png";
    }else{
        data.friendHeadUrl=self.loginHeadUrl;
    }
    if (!self.loginCname) {
        data.friendName=@"1111";
    }else{
        data.friendName=self.loginCname;
    }
    
    XHBTalkData * preData=[self.chatArray lastObject];
    if (data.time.intValue-preData.time.intValue>5*60*60) {
        data.showTime=YES;
    }
    [_chatArray addObject:data];
    [_chatView reloadData];
    [_chatView scrollToBottom];
    NSString * friend=[NSString stringWithFormat:@"%@@%@",self.friendJid,self.host];
    data.friendJid=friend;
    data.loginJid=[NSString stringWithFormat:@"%@@%@",self.loginJid,self.host];
    data.friendId=self.friendJid;
    data.loginId=self.loginJid;
    [data formatInsertToDB];
    [[XHBTalkTransfersCenter shareCenter] sendMessage:data complete:^(BOOL success) {
        [self.chatView reloadData];
    }];
}

+(void)getGrouptTalkData:(NSString*)loginJid offset:(NSUInteger)offset limit:(NSUInteger)limit callback:(void(^)(NSArray* groups))callback
{
   [[XHBDBHelper shareDBHelper] search:[XHBTalkData class] where:[NSString stringWithFormat:@"loginId='%@'",loginJid] orderBy:@"time desc" offset:(int)offset count:(int)limit groupby:@"friendJid" callback:^(NSMutableArray *array) {
       NSMutableArray * groups=[NSMutableArray array];
       for (XHBTalkData * data in array) {
           XHBTalkGroupData * group=[[XHBTalkGroupData alloc]init];
           group.cname=data.friendName;
           group.friendJid=data.friendId;
           group.loginJid=data.loginId;
           group.cheadUrl=data.friendHeadUrl;
           if (data.type==XHBTalkContentTypeText) {
               group.lastMsg=data.content;
           }else if (data.type==XHBTalkContentTypeImage){
               group.lastMsg=@"[图片]";
           }else if(data.type==XHBTalkContentTypeSound){
               group.lastMsg=@"[语音]";
           }
           group.lastTime=data.time;
           group.newCount=[[XHBDBHelper shareDBHelper] rowCount:[XHBTalkData class] where:[NSString stringWithFormat:@"friendId='%@' and loginId='%@' and readed=0",group.friendJid,group.loginJid]];
           [groups addObject:group];
       }
       if (callback) {
           callback(groups);
       }
    }];
}



@end
