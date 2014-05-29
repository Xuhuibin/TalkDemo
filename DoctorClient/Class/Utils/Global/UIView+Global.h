//
//  UIView+Global.h
//  DoctorClient
//
//  Created by weqia on 14-4-27.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Global)
@property(nonatomic,weak)UIViewController * viewController;

-(void)addTapAction:(id)target action:(SEL)action;

@end
