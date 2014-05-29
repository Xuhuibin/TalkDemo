//
//  XHBVoiceRecordProgressView.h
//  webox
//
//  Created by weqia on 14-2-24.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBVoiceRecordProgressView : UIImageView
{
    UILabel * _label;
    
    UIImageView * _voiceimage;
    
    UIImageView * _progressImage;
    
    UIImageView * _cancelImage;
    
    UIImageView * _labelBackView;
    
    UIImageView * _alertImage;
}
+(XHBVoiceRecordProgressView*)shareButton;
-(void)setStrength:(int)level;
-(void)show;
-(void)hide;
-(void)willHide;
-(void)reShow;
-(void)recordTimeSmall;
-(void)recordTimeBig;

@end
