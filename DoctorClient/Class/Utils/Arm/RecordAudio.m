//
//  RecordAudio.m
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"

@implementation RecordAudio


-(id)init {
    self = [super init];
    if (self) {
        //Instanciate an instance of the AVAudioSession object.
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        //Setup the audioSession for playback and record. 
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride);
        
        //Activate the session
        [audioSession setActive:YES error: nil];
    }
    return self;
}

- (NSData *) stopRecord {
    if (_timer) {
        [_timer invalidate];
    }
    if (recorder.isRecording) {
        NSURL *url =[[NSURL alloc]initWithString:recorder.url.absoluteString];
        [recorder stop];
        NSData * data=EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        return data;
    }else{
        return nil;
    }
}

-(void) startRecord {
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
                                       //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                       [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                       [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                       //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                       [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                       nil];
    
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
    NSLog(@"Using File called: %@",recordedTmpFile);
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:nil];
    [recorder setDelegate:self];
    recorder.meteringEnabled=YES;
    [recorder recordForDuration:65];
    //We call this to start the recording process and initialize 
    //the subsstems so that when we actually say "record" it starts right away.
    [recorder prepareToRecord];
    
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

-(void)cancelRecord
{
    if (recorder.isRecording) {
        [recorder stop];
    }
    if (_timer) {
        [_timer invalidate];
    }
}



- (void)updateMeters {
    /*  发送updateMeters消息来刷新平均和峰值功率。
     *  此计数是以对数刻度计量的，-160表示完全安静，
     *  0表示最大输入值
     */
    if (recorder) {
        [recorder updateMeters];
    }
    float peakPower = [recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    NSLog(@"peakPowerForChannel :%f",peakPowerForChannel);
    int level=1;
    if (0<peakPowerForChannel<=0.10) {
        level=1;
    }else if (0.10<peakPowerForChannel<=0.20) {
        level=2;
    }else if (0.20<peakPowerForChannel<=0.30) {
        level=3;
    }else if (0.30<peakPowerForChannel<=0.40) {
        level=4;
    }else if (0.40<peakPowerForChannel<=0.55) {
       level=5;
    }else if (0.55<peakPowerForChannel<=0.70) {
       level=6;
    }else if (0.70<peakPowerForChannel<=0.85) {
       level=7;
    }else{
       level=8;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(updateMeters:level:)]) {
        [self.delegate updateMeters:self level:level];
    }
}

@end
