//
//  XHBTalkSoundTableViewCell.m
//  DoctorClient
//
//  Created by weqia on 14-5-9.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkSoundTableViewCell.h"

@implementation XHBTalkSoundTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    if (self.mlogo.frame.origin.x<100) {
        UIImage * image1=[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"];
        UIImage * image2=[UIImage imageNamed:@"ReceiverVoiceNodePlaying002"];
        UIImage * image3=[UIImage imageNamed:@"ReceiverVoiceNodePlaying003"];
        self.voiceAnimation.animationImages=[NSArray arrayWithObjects:image1,image2,image3, nil];
        self.voiceAnimation.animationDuration=1;
    }else{
        UIImage * image1=[UIImage imageNamed:@"SenderVoiceNodePlaying001"];
        UIImage * image2=[UIImage imageNamed:@"SenderVoiceNodePlaying002"];
        UIImage * image3=[UIImage imageNamed:@"SenderVoiceNodePlaying003"];
        self.voiceAnimation.animationImages=[NSArray arrayWithObjects:image1,image2,image3, nil];
        self.voiceAnimation.animationDuration=1;
    }
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.backView addGestureRecognizer:tap];
}

-(void)loadContent:(XHBTalkData*)data
{
    [super loadContent:data];
    if (data.soundStatu==XHBTalkSoundStatusIsplaying) {
        self.voiceAnimation.hidden=NO;
        [self.voiceAnimation startAnimating];
        self.voice.hidden=YES;
    }else{
        [self.voiceAnimation stopAnimating];
        self.voiceAnimation.hidden=YES;
        self.voice.hidden=NO;
    }
    self.playTime.text=[NSString stringWithFormat:@"%ldS",(long)self.talk.soundTime];
}

-(void)tapAction:(UIGestureRecognizer*)gesture
{
    if (self.talk.soundStatu==XHBTalkSoundStatusIsplaying) {
        [self.talk setSoundStatu:XHBTalkSoundStatusNormal];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(talkTableCell:stopPalySoundAction:)]) {
            [self.delegate talkTableCell:self stopPalySoundAction:self.talk];
            [self.voiceAnimation stopAnimating];
            [self.tableView reloadData];
        }
        [self.tableView reloadData];
    }else if (self.talk.soundStatu==XHBTalkSoundStatusNormal){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(talkTableCell:palySoundAction:readyCallback:)]) {
            [self.delegate talkTableCell:self palySoundAction:self.talk readyCallback:^(BOOL ready) {
                if (ready) {
                    self.talk.soundStatu=XHBTalkSoundStatusIsplaying;
                    [self.tableView reloadData];
                }
            }];
        }
    }
}


@end
