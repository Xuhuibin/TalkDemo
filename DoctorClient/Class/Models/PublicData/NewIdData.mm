//
//  NewIdData.m
//  wq8
//
//  Created by weqia on 13-11-20.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "NewIdData.h"

@implementation NewIdData
@synthesize tableId,tableName;
+(NSString *)getPrimaryKey
{
    return @"tableName";
}
+(NSString *)getTableName
{
    return @"NewIdData";
}

@end
