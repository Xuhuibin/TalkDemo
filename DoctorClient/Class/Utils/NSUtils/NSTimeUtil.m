//
//  NSTimeUtil.m
//  ShareCar
//
//  Created by weqia on 14-4-29.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NSTimeUtil.h"

@implementation NSTimeUtil
+ (NSString*)getMDStr:(long long)time
{
    if (time/1000000000>1000) {
        time=time/1000;
    }
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%d月%d日",[component month],[component day]];
    return string;
}
+ (NSString*)getYMStr:(long long)time
{
    if (time/1000000000>1000) {
        time=time/1000;
    }
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%d年%d月",[component year],[component month]];
    return string;
}
+ (NSString*)getNowTime
{
    NSDate * date=[NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",time];
}


@end
