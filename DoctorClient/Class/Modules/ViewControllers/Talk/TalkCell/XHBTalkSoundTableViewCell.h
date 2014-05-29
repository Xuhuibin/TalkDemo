//
//  XHBTalkSoundTableViewCell.h
//  DoctorClient
//
//  Created by weqia on 14-5-9.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkTableViewCell.h"

@interface XHBTalkSoundTableViewCell : XHBTalkTableViewCell
@property(nonatomic,weak)IBOutlet UIImageView * voice;
@property(nonatomic,weak)IBOutlet UIImageView * voiceAnimation;
@property(nonatomic,weak)IBOutlet UILabel * playTime;
@end
