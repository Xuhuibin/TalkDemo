//
//  XHBVoiceRecordButton.m
//  webox
//
//  Created by weqia on 14-2-24.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBVoiceRecordButton.h"
@implementation XHBVoiceRecordButton

#pragma -mark 接口
+(XHBVoiceRecordButton*)newButton
{
    XHBVoiceRecordButton * button=[[[self alloc]init]initView];
    return button;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self=[self initView];
    }
    return self;
}

-(id)initView
{
    self.backgroundColor=[UIColor clearColor];
    _backView=[[UIImageView alloc]initWithFrame:self.bounds];
    _backView.image=[UIImage imageNamed:@"down_say_back"];
    [self addSubview:_backView];
    
    _voice=[[UIImageView alloc]initWithFrame:CGRectMake(40, 7, 19, 14)];
    _voice.image=[UIImage imageNamed:@"down_say"];
    [self addSubview:_voice];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width, self.frame.size.height)];
    _label.text=@"按住 说话";
    _label.backgroundColor=[UIColor clearColor];
    _label.textColor=[UIColor darkGrayColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.userInteractionEnabled=YES;
    [self addSubview:_label];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isRecord) {
        _second=0;
        _time=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        _isRecord=YES;
        _cancel=NO;
        _voice.image=[UIImage imageNamed:@"down_say_press"];
        _backView.image=[UIImage imageNamed:@"down_say_back_press"];
        _label.text=@"松开 结束";
        if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordBeginRecord:)]) {
            [self.delegate voiceRecordBeginRecord:self];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isRecord) {
        return;
    }
     _isRecord=NO;
    if (_cancel) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordCancelRecord:)]) {
            [self.delegate voiceRecordCancelRecord:self];
        }
        self.backgroundColor=[UIColor whiteColor];
        _label.text=@"按住 说话";
    }else{
        if (_second<=1) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordRecordTimeSmall:)]) {
                [self.delegate voiceRecordRecordTimeSmall:self];
            }
            double delayInSeconds = 2.0;
            self.userInteractionEnabled=NO;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.userInteractionEnabled=YES;
                _label.text=@"按住 说话";
                _voice.image=[UIImage imageNamed:@"down_say"];
                _backView.image=[UIImage imageNamed:@"down_say_back"];
            });
        }else if(_second>=60){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordRecordTimeBig:)]) {
                [self.delegate voiceRecordRecordTimeBig:self];
            }
            double delayInSeconds = 2.0;
            self.userInteractionEnabled=NO;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.userInteractionEnabled=YES;
                _voice.image=[UIImage imageNamed:@"down_say"];
                _backView.image=[UIImage imageNamed:@"down_say_back"];
                _label.text=@"按住 说话";
            });
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordEndRecord:timeDuration:)]) {
                [self.delegate voiceRecordEndRecord:self timeDuration:_second];
            }
            _voice.image=[UIImage imageNamed:@"down_say"];
            _backView.image=[UIImage imageNamed:@"down_say_back"];
            _label.text=@"按住 说话";
        }
    }
    [_time invalidate];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_isRecord) {
        return;
    }
    _isRecord=NO;
    if (_cancel) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordCancelRecord:)]) {
            [self.delegate voiceRecordCancelRecord:self];
        }
        _voice.image=[UIImage imageNamed:@"down_say"];
        _backView.image=[UIImage imageNamed:@"down_say_back"];
        _label.text=@"按住 说话";
    }else{
        if (_second<=1) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordRecordTimeSmall:)]) {
                [self.delegate voiceRecordRecordTimeSmall:self];
            }
            double delayInSeconds = 2.0;
            self.userInteractionEnabled=NO;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.userInteractionEnabled=YES;
                _voice.image=[UIImage imageNamed:@"down_say"];
                _backView.image=[UIImage imageNamed:@"down_say_back"];
                _label.text=@"按住 说话";
            });
        }else if(_second>=60){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordRecordTimeBig:)]) {
                [self.delegate voiceRecordRecordTimeBig:self];
            }
            double delayInSeconds = 2.0;
            self.userInteractionEnabled=NO;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.userInteractionEnabled=YES;
                _voice.image=[UIImage imageNamed:@"down_say"];
                _backView.image=[UIImage imageNamed:@"down_say_back"];
                _label.text=@"按住 说话";
            });
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordEndRecord:timeDuration:)]) {
                [self.delegate voiceRecordEndRecord:self timeDuration:_second];
            }
            _voice.image=[UIImage imageNamed:@"down_say"];
            _backView.image=[UIImage imageNamed:@"down_say_back"];
            _label.text=@"按住 说话";
        }
    }
    [_time invalidate];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    if (point.x<0||point.y<0||point.x>196||point.y>28) {
        if (_cancel==NO) {
            _cancel=YES;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordWillCancelRecord:)]) {
                [self.delegate voiceRecordWillCancelRecord:self];
            }
        }
    }else{
        if (_cancel) {
            _cancel=NO;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceRecordContinueRecord:)]) {
                [self.delegate voiceRecordContinueRecord:self];
            }
        }
    }
}

-(void)timeAction
{
    _second++;
    if (_second==60) {
        if (_hud) {
            [_hud removeFromSuperview];
        }
        [self touchesEnded:nil withEvent:nil];
    }
    if (_second>=52) {
        if (_hud==nil) {
            _hud=[[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
            _hud.mode=MBProgressHUDModeText;
            _hud.margin = 10.f;
            _hud.yOffset = 200.f;
            _hud.removeFromSuperViewOnHide = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:_hud];
            [_hud show:YES];
        }
        _hud.labelText=[NSString stringWithFormat:@"录音时间还剩下%d秒",60-_second];
    }
}


@end
