//
//  HBFileCacheData.m
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "HBFileCacheData.h"

@implementation HBFileCacheData
@synthesize filekey,cacheFileName,cacheId;
-(id)init{
    self= [super init];
    if(self){
        self.cacheFileName=nil;
        self.filekey=nil;
    }
    return self;
}

+(NSString *)getPrimaryKey
{
    return @"filekey";
}

+(NSString *)getTableName
{
    return @"HBFileCacheData";
}


@end
