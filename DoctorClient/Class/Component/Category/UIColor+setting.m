//
//  UIColor+setting.m
//  wq
//
//  Created by weqia on 13-7-29.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "UIColor+setting.h"

@implementation UIColor (setting)


+ (UIColor *)colorWithIntegerValue:(NSUInteger)value alpha:(CGFloat)alpha {
    NSUInteger mask = 255;
    NSUInteger blueValue = value & mask;
    value >>= 8;
    NSUInteger greenValue = value & mask;
    value >>= 8;
    NSUInteger redValue = value & mask;
    return [UIColor colorWithRed:(CGFloat)(redValue / 255.0) green:(CGFloat)(greenValue / 255.0) blue:(CGFloat)(blueValue / 255.0) alpha:alpha];
}
@end

