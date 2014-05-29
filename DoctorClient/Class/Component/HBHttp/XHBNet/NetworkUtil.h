//
//  NetworkUtil.h
//  wq
//
//  Created by berwin on 13-7-10.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define NetWorkStatusChangeNotification @"NetWorkStatusChangeNotification"
@interface NetworkUtil : NSObject

+ (BOOL) getNetworkStatue;
@property(nonatomic)BOOL isExistenceNetwork;
@property(nonatomic,strong)Reachability * reachability;

+(id)shareUtil;
-(void)startNotification;

@end
