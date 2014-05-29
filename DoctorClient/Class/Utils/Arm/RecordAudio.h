//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "amrFileCodec.h"
#define WAVE_UPDATE_FREQUENCY   0.05
@class RecordAudio;
@protocol RecordAudioDelegate <NSObject>

- (void)updateMeters:(RecordAudio*)record level:(int)level;

@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
    NSTimer * _timer;
}

@property (nonatomic,assign)id<RecordAudioDelegate> delegate;

- (NSData *)stopRecord;
- (void)startRecord;
-(void)cancelRecord;

@end
