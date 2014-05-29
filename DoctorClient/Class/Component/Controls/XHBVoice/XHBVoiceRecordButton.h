//
//  XHBVoiceRecordButton.h
//  webox
//
//  Created by weqia on 14-2-24.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class XHBVoiceRecordButton;
@protocol XHBVoiceRecordButtonDelegate <NSObject>

-(void)voiceRecordBeginRecord:(XHBVoiceRecordButton*)button;

-(void)voiceRecordEndRecord:(XHBVoiceRecordButton *)button timeDuration:(float)duration;

-(void)voiceRecordCancelRecord:(XHBVoiceRecordButton *)button;

-(void)voiceRecordContinueRecord:(XHBVoiceRecordButton *)button;

-(void)voiceRecordWillCancelRecord:(XHBVoiceRecordButton *)button;

-(void)voiceRecordRecordTimeSmall:(XHBVoiceRecordButton *)button;

-(void)voiceRecordRecordTimeBig:(XHBVoiceRecordButton *)button;


@end

@interface XHBVoiceRecordButton : UIView
{
    UILabel * _label;
    UIImageView * _backView;
    UIImageView * _voice;
    
    BOOL _isRecord;
    
    BOOL _cancel;
    
    NSTimer * _time;
    
    int _second;
    
    MBProgressHUD * _hud;
}
@property(nonatomic,strong)IBOutlet id<XHBVoiceRecordButtonDelegate> delegate;
+(XHBVoiceRecordButton*)newButton;
@end
