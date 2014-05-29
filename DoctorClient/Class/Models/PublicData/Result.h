//
//  Result.h
//  wq
//
//  Created by berwin on 13-7-9.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "BaseData.h"

@interface Result : BaseData

@property (nonatomic, strong) NSString *ret;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSString *list;
@property (nonatomic, strong) NSString *msg;

@end
