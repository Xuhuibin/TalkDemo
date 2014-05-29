//
//  XHBBaseViewController.h
//  webox
//
//  Created by weqia on 14-2-21.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerCommunicationDelegate.h"
#import "UIImageView+Cache.h"
#import "UIViewControllerOperationDelegate.h"
#import "UIView+Global.h"
#import "NSViewUtil.h"
#import "DialogUtil.h"
#import "NSTimeUtil.h"
@interface XHBBaseViewController : UIViewController<UIViewControllerCommunicationDelegate>
-(void)loadDataFromServer:(void(^)(id object))complete;

@end

@interface UIViewController (Base)

-(UIViewController<UIViewControllerCommunicationDelegate>*)viewControllerForName:(NSString*)name Class:(Class)Class;
-(void)registerTextFieldEditFinishActionGesture;


// 子类继承
-(void)backAction;
-(void)rightButtonAction;
-(void)textFieldEditFinishAction;
@end

