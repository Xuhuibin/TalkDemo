//
//  XHBTalkToolContainerView.m
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkToolContainerView.h"

@implementation XHBTalkToolContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(instancetype)newContainerView:(id)owner
{
    XHBTalkToolContainerView * view=[[[NSBundle mainBundle] loadNibNamed:@"XHBTalkToolContainerView" owner:owner options:nil] lastObject];
    return view;
}
#pragma -mark 事件响应 
-(IBAction)btnPicAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackPic:)]) {
        [self.delegate talkToolTackPic:self];
    }
}
-(IBAction)btnFileAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackFile:)]) {
        [self.delegate talkToolTackFile:self];
    }
}
-(IBAction)btnPlaceAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackPlace:)]) {
        [self.delegate talkToolTackPlace:self];
    }
}
-(IBAction)btnVedioAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolTackVedio:)]) {
        [self.delegate talkToolTackVedio:self];
    }
}


@end
