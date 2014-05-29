//
//  UIView+Global.m
//  DoctorClient
//
//  Created by weqia on 14-4-27.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "UIView+Global.h"
static char const * const ViewController = "ViewController";
@implementation UIView (Global)
@dynamic viewController;
-(UIViewController*)viewController
{
    return objc_getAssociatedObject(self, ViewController);
}
-(void)setViewController:(UIViewController *)viewController
{
    objc_setAssociatedObject(self, ViewController, viewController, OBJC_ASSOCIATION_ASSIGN);
}
-(void)addTapAction:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
@end
