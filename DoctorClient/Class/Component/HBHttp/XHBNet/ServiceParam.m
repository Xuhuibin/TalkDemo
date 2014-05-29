//
//  ServiceParam.m
//  wq
//
//  Created by berwin on 13-7-8.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "ServiceParam.h"
@implementation ServiceParam

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(ServiceParam*)initWithMode:(NSString*)parammode
{
    if(self=[super init]) {
        self.mode=parammode;
    }
    return self;
}
@end
