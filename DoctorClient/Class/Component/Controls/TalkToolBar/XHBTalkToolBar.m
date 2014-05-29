//
//  XHBTalkToolBar.m
//  TalkDemo
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkToolBar.h"

@implementation XHBTalkToolBar
+(instancetype)newTalkToolBar:(id)owner
{
    XHBTalkToolBar * toolbar=[[[NSBundle mainBundle]loadNibNamed:@"XHBTalkToolBar" owner:owner options:nil] objectAtIndex:0];
    return toolbar;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _emojiPageView=[[HBEmojiPageView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
        _emojiPageView.delegate=self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}
-(void)didMoveToSuperview
{
    [_textView.internalTextView setReturnKeyType:UIReturnKeySend];
    _textView.delegate = self;
    _textView.maximumNumberOfLines=5;
    _textView.internalTextView.layer.borderWidth=0.3;
    _textView.internalTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _emojiPageView.frame=CGRectMake(0, self.superview.frame.size.height, 320, 216);
    _picView=[[[NSBundle mainBundle]loadNibNamed:@"XHBTalkToolBar" owner:self options:nil] lastObject];
    _picView.frame=CGRectMake(-95, self.frame.origin.y-44, 95, 44);
    [self.superview addSubview:_picView];
    
    UIButton * btnTake=(UIButton*)[_picView viewWithTag:102];
    [btnTake addTarget:self action:@selector(tackImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btnTake=(UIButton*)[_picView viewWithTag:101];
    [btnTake addTarget:self action:@selector(selectImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.superview addSubview:_emojiPageView];
}

#pragma -mark 事件响应
-(IBAction)btnFaceAction:(id)sender
{
    [self showEmojiPageView];
    self.btnVoice.hidden=YES;
    self.btnSend.hidden=NO;
    self.btnKeyboard.hidden=YES;
}
-(IBAction)btnAddAction:(id)sender
{
    [self showContainerView];
}
-(IBAction)btnVoiceAction:(id)sender
{
    self.btnKeyboard.hidden=NO;
    self.btnSend.hidden=YES;
    self.btnVoice.hidden=YES;
    [self beginRecord];
}
-(IBAction)btnKeyboardAction:(id)sender
{
    [self beginEdit];
}
-(IBAction)btnSendAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:)]) {
        [self.delegate talkToolBar:self sendText:self.textView.text];
        self.textView.text=nil;
    }
}
-(void)tackImageAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBarTakeImage:)]) {
        [self.delegate talkToolBarTakeImage:self];
    }
}
-(void)selectImageAction:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBarSelectImage:)]) {
        [self.delegate talkToolBarSelectImage:self];
    }
}
#pragma -mark 回调
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (_textView.frame.size.height - height);
    CGRect frame = self.frame;
    frame.origin.y += diff;
    frame.size.height -= diff;
    self.frame = frame;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:self.superview.frame.size.height-self.frame.origin.y];
    }
}
//return方法
-(BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:)]) {
        [self.delegate talkToolBar:self sendText:self.textView.text];
        self.textView.text=nil;
    }
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    if ([expandingTextView.text length]>0) {
        [_emojiPageView canSend];
    }else{
        [_emojiPageView cannotSend];
    }
}
-(void)showContainerView{
    if (self.btnAdd.selected) {
        [UIView animateWithDuration:0.25 animations:^{
           _picView.frame=CGRectMake(-95, self.frame.origin.y-44, 95, 44);
        }];
        self.btnAdd.selected=NO;
    }else{
        self.btnAdd.selected=YES;
        [UIView animateWithDuration:0.25 animations:^{
            _picView.frame=CGRectMake(0, self.frame.origin.y-44, 95, 44);
        }];
    }
}

-(void)showEmojiPageView{
    self.recordVoice.hidden=YES;
    self.textView.hidden=NO;
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        [_emojiPageView setFrame:CGRectMake(0, self.superview.frame.size.height-216, self.superview.frame.size.width, 216)];
        self.frame = CGRectMake(0, self.superview.frame.size.height-216-self.frame.size.height,  self.superview.bounds.size.width,self.frame.size.height);
        _picView.frame=CGRectMake(-95, self.superview.frame.size.height-self.frame.size.height-44, 95, 44);
        self.btnAdd.selected=NO;
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:216+self.frame.size.height];
    }
}

-(void)beginRecord
{
    [self.textView resignFirstResponder];
    self.textView.hidden=YES;
    self.recordVoice.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        [_emojiPageView setFrame:CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, 216)];
        self.frame = CGRectMake(0, self.superview.frame.size.height-self.frame.size.height,  self.superview.bounds.size.width,self.frame.size.height);
        _picView.frame=CGRectMake(-95, self.superview.frame.size.height-self.frame.size.height-44, 95, 44);
        self.btnAdd.selected=NO;
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:self.frame.size.height];
    }
}
-(void)beginEdit
{
    self.recordVoice.hidden=YES;
    self.textView.hidden=NO;
    [self.textView becomeFirstResponder];
}


#pragma mark -
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [self.textView resignFirstResponder];
    self.btnSend.hidden=YES;
    if (self.recordVoice.hidden) {
        self.btnVoice.hidden=NO;
        self.btnKeyboard.hidden=YES
        ;
    }else{
        self.btnVoice.hidden=YES;
        self.btnKeyboard.hidden=NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame=CGRectMake(0, self.superview.frame.size.height-self.frame.size.height, 320, self.frame.size.height);
        _picView.frame=CGRectMake(-95, self.superview.frame.size.height-self.frame.size.height-44, 95, 44);
        self.btnAdd.selected=NO;
        [_emojiPageView setFrame:CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, 216)];
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:self.frame.size.height];
    }
}

#pragma mark -
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    self.btnKeyboard.hidden=YES;
    self.btnVoice.hidden=YES;
    self.btnSend.hidden=NO;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:animationTime animations:^{
        self.frame=CGRectMake(0, self.superview.frame.size.height-self.frame.size.height-keyBoardFrame.size.height, 320, self.frame.size.height);
        [_emojiPageView setFrame:CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, 216)];
        _picView.frame=CGRectMake(-95, self.superview.frame.size.height-self.frame.size.height-44, 95, 44);
        self.btnAdd.selected=NO;
    }];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:changeHeight:)]) {
        [self.delegate talkToolBar:self changeHeight:keyBoardFrame.size.height+self.frame.size.height];
    }
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    self.btnSend.hidden=YES;
    self.btnVoice.hidden=NO;
    self.btnKeyboard.hidden=YES;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
}

-(void)emojiPageView:(HBEmojiPageView*)emojiPageView  iconClick:(NSString*)iconString
{
    NSMutableString *faceString = [[NSMutableString alloc]initWithString:_textView.text];
    [faceString appendString:iconString];
    _textView.text = faceString;
}
-(void)emojiPageViewDeleteClick:(HBEmojiPageView*)emojiPageView actionBlock:(NSString*(^)(NSString* string))block
{
    _textView.text=block(_textView.text);
}

-(void)emojiPageViewSendClick:(HBEmojiPageView *)emojiPageView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkToolBar:sendText:)]) {
        [self.delegate talkToolBar:self sendText:self.textView.text];
        self.textView.text=nil;
    }
}

@end
