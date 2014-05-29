//
//  XHBTalkToolBar.h
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBVoiceRecordButton.h"
#import "UIExpandingTextView.h"
#import "HBEmojiPageView.h"
#import "XHBTalkToolContainerView.h"

@class XHBTalkToolBar;

@protocol XHBTalkToolBarDelegate <NSObject>

-(void)talkToolBar:(XHBTalkToolBar*)toolBar sendText:(NSString*)text;

-(void)talkToolBar:(XHBTalkToolBar*)toolBar changeHeight:(float)height;

-(void)talkToolBarSelectImage:(XHBTalkToolBar*)toolBar;

-(void)talkToolBarTakeImage:(XHBTalkToolBar*)toolBar;

@end

@interface XHBTalkToolBar : UIView<HBEmojiPageViewDelegate,UIExpandingTextViewDelegate>
@property(nonatomic,weak)IBOutlet UIButton * btnFace;
@property(nonatomic,weak)IBOutlet UIButton * btnAdd;

@property(nonatomic,weak)IBOutlet UIButton * btnKeyboard;
@property(nonatomic,weak)IBOutlet UIButton * btnSend;
@property(nonatomic,weak)IBOutlet UIButton * btnVoice;


@property(nonatomic,weak)IBOutlet XHBVoiceRecordButton * recordVoice;
@property(nonatomic,weak)IBOutlet UIExpandingTextView * textView;
@property(nonatomic,strong,readonly)HBEmojiPageView * emojiPageView;
@property(nonatomic,strong,readonly)UIView * picView;
@property(nonatomic,weak)id<XHBTalkToolBarDelegate>delegate;

+(instancetype)newTalkToolBar:(id)owner;

-(void)dismissKeyBoard;

@end
