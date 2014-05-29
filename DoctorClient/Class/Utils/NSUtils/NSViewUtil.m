//
//  NSViewUtil.m
//  ShareCar
//
//  Created by weqia on 14-4-29.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NSViewUtil.h"

@implementation NSViewUtil
+(void)setTextFieldPadding:(UITextField*)textField
{
    if (textField) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, textField.frame.size.height)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}
+(void)setCycleLogo:(UIImageView*)imageView
{
    CALayer *lay  = imageView.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:imageView.frame.size.width/2];
    [lay setBorderWidth:2];
    [lay setBorderColor:[UIColor whiteColor].CGColor];
}


@end
