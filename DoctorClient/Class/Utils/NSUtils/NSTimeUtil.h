//
//  NSTimeUtil.h
//  ShareCar
//
//  Created by weqia on 14-4-29.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimeUtil : NSObject
+ (NSString*)getYMStr:(long long)time;
+ (NSString*)getMDStr:(long long)time;
+ (NSString*)getNowTime;

@end
