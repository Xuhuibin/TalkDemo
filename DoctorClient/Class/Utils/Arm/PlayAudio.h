//
//  PlayAudio.h
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordAudio.h"

@protocol PlayAudioDelegate <NSObject>
//0 播放 1 播放完成 2出错
-(void)PlayStatus:(int)status;

@end
@interface PlayAudio : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer * avPlayer;
}
@property (nonatomic,strong) id<PlayAudioDelegate>delegate;
@property (nonatomic) BOOL playStatu; // 0 : 停止 ， 1: 正在播放
@property (nonatomic) BOOL playMode;  // 0: 扬声器模式   1:听筒模式
+(NSTimeInterval) getAudioTime:(NSData *) data;

-(void)play:(NSData*)data;

-(void)play:(NSString*)key readyCallback:(void(^)(BOOL ready))callback;

-(void)stopPlay;

@end
