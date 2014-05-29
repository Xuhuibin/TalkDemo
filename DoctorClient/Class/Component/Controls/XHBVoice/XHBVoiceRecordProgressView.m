
//
//  XHBVoiceRecordProgressView.m
//  webox
//
//  Created by weqia on 14-2-24.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBVoiceRecordProgressView.h"

@implementation XHBVoiceRecordProgressView
#pragma -mark 接口
+(XHBVoiceRecordProgressView*)shareButton
{
    static XHBVoiceRecordProgressView * view=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view=[[self alloc]initView];
    });
    return view;
}
-(void)show
{
    _labelBackView.hidden=YES;
    _cancelImage.hidden=YES;
    _voiceimage.hidden=NO;
    _progressImage.hidden=NO;
    _label.text=@"手指上划,取消发送";
    _alertImage.hidden=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)hide
{
    [self removeFromSuperview];
}

-(void)willHide
{
    _label.text=@"放开手指,取消发送";
    _labelBackView.hidden=NO;
    _cancelImage.hidden=NO;
    _voiceimage.hidden=YES;
    _alertImage.hidden=YES;
    _progressImage.hidden=YES;
}

-(void)reShow
{
    _labelBackView.hidden=YES;
    _cancelImage.hidden=YES;
    _voiceimage.hidden=NO;
    _progressImage.hidden=NO;
    _alertImage.hidden=YES;
    _label.text=@"手指上划,取消发送";
}

-(void)recordTimeSmall
{
    _label.text=@"录音时间太短";
    _labelBackView.hidden=YES;
    _cancelImage.hidden=YES;
    _voiceimage.hidden=YES;
    _progressImage.hidden=YES;
    _alertImage.hidden=NO;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hide];
    });
}

-(void)recordTimeBig
{
    _label.text=@"录音时间太长";
    _labelBackView.hidden=YES;
    _cancelImage.hidden=YES;
    _voiceimage.hidden=YES;
    _progressImage.hidden=YES;
    _alertImage.hidden=NO;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hide];
    });
}

-(void)setStrength:(int)level
{
    if (level>8) {
        level=8;
    }
    if (level<1) {
        level=1;
    }
    NSString * fileName=[NSString stringWithFormat:@"RecordingSignal00%d",level];
    _progressImage.image=[UIImage imageNamed:fileName];
}

#pragma  -mark 私有
-(id)initView
{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(80,([UIScreen mainScreen].bounds.size.height-160)/2, 160, 160);
        self.image=[UIImage imageNamed:@"semitrans_bg"];
        
        _voiceimage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 60, 90)];
        _voiceimage.image=[UIImage imageNamed:@"FavoritesActionSheetVoiceIcon"];
        [self addSubview:_voiceimage];
        
        _progressImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 20, 60, 90)];
        _progressImage.image=[UIImage imageNamed:@"RecordingSignal001"];
        [self addSubview:_progressImage];
        
        _cancelImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 120, 90)];
        _cancelImage.image=[UIImage imageNamed:@"rcd_cancel_icon.png"];
        [self addSubview:_cancelImage];
        _cancelImage.hidden=YES;
        
        _labelBackView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 132, 140, 25)];
        _labelBackView.image=[UIImage imageNamed:@"rcd_cancel_bg.9.png"];
        [self addSubview:_labelBackView];
        _labelBackView.hidden=YES;
        
        _alertImage=[[UIImageView alloc]initWithFrame:CGRectMake(10,20, 140, 140)];
        _alertImage.image=[UIImage imageNamed:@"MessageTooShort@2x.png"];
        [self addSubview:_alertImage];
        _alertImage.hidden=YES;
        
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 135, 160, 20)];
        _label.text=@"手指上划,取消发送";
        _label.textColor=[UIColor whiteColor];
        _label.font=[UIFont systemFontOfSize:15];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.backgroundColor=[UIColor clearColor];
        [self addSubview:_label];
        
    }
    return self;
}

@end
