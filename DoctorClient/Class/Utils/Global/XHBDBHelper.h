//
//  XHBDBHelper.h
//  DoctorClient
//
//  Created by weqia on 14-4-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "LKDBHelper.h"
#import "NewIdData.h"
@interface XHBDBHelper : LKDBHelper
{
    NSLock * _thlock;
}
+(instancetype)shareDBHelper;
-(int)newIdforTable:(Class)cls;

@end
