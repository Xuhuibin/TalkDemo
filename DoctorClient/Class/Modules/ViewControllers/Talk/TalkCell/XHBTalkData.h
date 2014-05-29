//
//  XHBTalkData.h
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//
#define IMAGE_MAX_WIDTH  150
#define IMAGE_MAX_HEIGHT  100
#import "MatchParserData.h"
typedef NS_ENUM(NSUInteger, XHBTalkContentType) {
    XHBTalkContentTypeText,
    XHBTalkContentTypeImage,
    XHBTalkContentTypeSound,
    XHBTalkContentTypeFile,
    XHBTalkContentTypeVedio,
    XHBTalkContentTypePlace
};

typedef NS_ENUM(NSUInteger, XHBTalkStatus) {
    XHBTalkStatusNone,
    XHBTalkStatusIsUploading,
    XHBTalkStatusDownloadFailed,
    XHBTalkStatusUploadFailed,
    XHBTalkStatusDownloadFinish,
    XHBTalkStatusUploadFinish,
    XHBTalkStatusShouldDownlad
};

typedef NS_ENUM(NSUInteger, XHBTalkSoundStatus) {
    XHBTalkSoundStatusNormal,
    XHBTalkSoundStatusIsplaying,
    XHBTalkSoundStatusISRecording
};

typedef NS_ENUM(NSUInteger, XHBTalkReachStatu) {
    XHBTalkReachStatuOut,
    XHBTalkReachStatuReach,
    XHBTalkReachStatuRead
};


@interface XHBTalkData : MatchParserData
@property(nonatomic)XHBTalkContentType type;
@property(nonatomic)XHBTalkStatus status;
@property(nonatomic)XHBTalkSoundStatus soundStatu;
@property(nonatomic,strong)NSString * time;
@property(nonatomic,strong)NSString * friendJid;
@property(nonatomic,strong)NSString * loginJid;
@property(nonatomic,strong)NSString * friendId;
@property(nonatomic,strong)NSString * loginId;

@property(nonatomic,strong)NSString * friendHeadUrl;
@property(nonatomic,strong)NSString * friendName;
@property(nonatomic)NSUInteger talkId;

@property(nonatomic)NSInteger soundTime;
@property(nonatomic)BOOL fromSelf;
@property(nonatomic)BOOL soundPlaying;
@property(nonatomic)BOOL soundRecording;
@property(nonatomic)BOOL fileUploaded;
@property(nonatomic)BOOL showTime;
@property(nonatomic)BOOL readed;
@property(nonatomic)XHBTalkReachStatu receipts;
@property(nonatomic,strong)NSString * receiptsId;
-(void)covert:(NSString*)msgBody;
-(NSString*)getMsgBody;

@end
