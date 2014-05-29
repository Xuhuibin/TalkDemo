//
//  NetworkUtil.m
//  wq
//
//  Created by berwin on 13-7-10.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "NetworkUtil.h"

@implementation NetworkUtil
@synthesize isExistenceNetwork,reachability;

+ (BOOL) getNetworkStatue {
    NetworkUtil * util=[self shareUtil];
    return util.isExistenceNetwork;
}

+(id)shareUtil
{
    static NetworkUtil * util=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util=[[NetworkUtil alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        util.reachability= [Reachability reachabilityWithHostName:@"www.baidu.com"];
            switch ([util.reachability currentReachabilityStatus]) {
                case NotReachable:
                    util.isExistenceNetwork=NO;
                    //   NSLog(@"没有网络");
                    break;
                case ReachableViaWWAN:
                    util.isExistenceNetwork=YES;
                    //   NSLog(@"正在使用3G网络");
                    break;
                case ReachableViaWiFi:
                    util.isExistenceNetwork=YES;
                    //  NSLog(@"正在使用wifi网络");
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [util.reachability startNotifier];
            });

        }); 
    });
    return util;
}

-(void)kReachabilityChange:(NSNotification*)notifition
{
    switch ([self.reachability currentReachabilityStatus]) {
        case NotReachable:
            self.isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            self.isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            self.isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkStatusChangeNotification object:nil];
}

-(void)startNotification
{
    if([NSThread isMainThread]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kReachabilityChange:) name:kReachabilityChangedNotification object:nil];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kReachabilityChange:) name:kReachabilityChangedNotification object:nil]; 
        });
    }
}


@end
