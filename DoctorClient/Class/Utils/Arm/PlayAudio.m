//
//  PlayAudio.m
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "PlayAudio.h"
#import "HBFileCache.h"
#import "UserService.h"
@implementation PlayAudio

-(id)init{
    self=[super init];
    if (self) {
         [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:NULL];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker; AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(audioRouteOverride), &audioRouteOverride);
    }
    return self;
}

-(void) play:(NSData*) data{
	//Setup the AVAudioPlayer to play the file that we just recorded.
    //在播放时，只停止
    if (avPlayer!=nil) {
        [avPlayer stop];
       // return;
    }
    _playStatu=1;
    NSLog(@"start decode");
    NSData* o = [self decodeAmr:data];
    NSLog(@"end decode");
    avPlayer = [[AVAudioPlayer alloc] initWithData:o error:nil];
    avPlayer.delegate = self;
	[avPlayer prepareToPlay];
    [avPlayer setVolume:1.0];
	if(![avPlayer play]){
        [self sendStatus:1];
    } else {
        [self sendStatus:0];
    }
}
-(void)play:(NSString*)key readyCallback:(void(^)(BOOL ready))callback
{
    NSData * data=[[HBFileCache  shareCache] getDataFromCache:key];
    if (data) {
        if (callback) {
            callback(YES);
        }
        [self play:data];
    }else{
        ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:key]];
        __weak ASIHTTPRequest * wrequest=request;
        [request setTimeOutSeconds:5];
        [request setCompletionBlock:^{
            if (wrequest==nil) {
                if (callback) {
                    callback(NO);
                }
                return;
            }
            __strong ASIHTTPRequest * srequest=wrequest;
            NSData * fileData=[srequest responseData];
            if (fileData) {
                if (callback) {
                    callback(YES);
                }
                [self play:fileData];
                [[HBFileCache shareCache] storeFile:fileData forUrl:key];
            }else{
                if (callback) {
                    callback(NO);
                }
            }
        }];
        [request setFailedBlock:^{
            if (callback) {
                callback(NO);
            }
        }];
        [[NSOperationQueue downLoadQueue] addOperation:request];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self sendStatus:1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self sendStatus:2];
}


//0 播放 1 播放完成 2出错
-(void)sendStatus:(int)status {
    if (status==1) {
        _playStatu=0;
    }
    if ([self.delegate respondsToSelector:@selector(PlayStatus:)]) {
        [self.delegate PlayStatus:status];
    }
    
    if (status!=0) {
        if (avPlayer!=nil) {
            [avPlayer stop];
        }
    }
}
+(NSTimeInterval) getAudioTime:(NSData *) data {
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    return n;
}

-(void) stopPlay {
    if (avPlayer!=nil) {
        [avPlayer stop];
        [self sendStatus:1];
    }
}

-(NSData *)decodeAmr:(NSData *)data{
    if (!data) {
        return data;
    }
    
    return DecodeAMRToWAVE(data);
}

@end
