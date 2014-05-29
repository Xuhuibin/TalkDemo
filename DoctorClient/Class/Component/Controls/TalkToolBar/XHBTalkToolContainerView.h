//
//  XHBTalkToolContainerView.h
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHBTalkToolContainerView;

@protocol XHBTalkToolContainerViewDelegate <NSObject>

-(void)talkToolTackPic:(XHBTalkToolContainerView*)containerView;
-(void)talkToolTackFile:(XHBTalkToolContainerView*)containerView;
-(void)talkToolTackPlace:(XHBTalkToolContainerView*)containerView;
-(void)talkToolTackVedio:(XHBTalkToolContainerView*)containerView;
@end


@interface XHBTalkToolContainerView : UIView
@property(nonatomic,weak)IBOutlet UIButton * btnPic;
@property(nonatomic,weak)IBOutlet UIButton * btnFile;
@property(nonatomic,weak)IBOutlet UIButton * btnPlace;
@property(nonatomic,weak)IBOutlet UIButton * btnVedio;
@property(nonatomic,weak)id<XHBTalkToolContainerViewDelegate>delegate;
+(instancetype)newContainerView:(id)owner;

@end
