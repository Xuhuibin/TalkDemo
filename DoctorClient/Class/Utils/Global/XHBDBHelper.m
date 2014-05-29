//
//  XHBDBHelper.m
//  DoctorClient
//
//  Created by weqia on 14-4-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBDBHelper.h"

@implementation XHBDBHelper
+(instancetype)shareDBHelper
{
    static XHBDBHelper * helper=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper=[[XHBDBHelper alloc]init];
    });
    return helper;
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _thlock=[[NSLock alloc]init];
        [self createTableWithModelClass:[NewIdData class]];
    }return self;
}

-(int)newIdforTable:(Class)cls
{
    [_thlock lock];
    int idNumber=1;
    static NSMutableDictionary * tableDic=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tableDic=[[NSMutableDictionary alloc]init];
    });
    NewIdData * count=[tableDic objectForKey:[NSString stringWithFormat:@"%@",cls]];
    if(count==nil){
        NewIdData * Id=[[XHBDBHelper shareDBHelper] searchSingle:[NewIdData class] where:[NSString stringWithFormat:@"tableName='%@'",cls] orderBy:nil];
        if (Id==nil) {
            Id=[[NewIdData alloc]init];
            Id.tableName=[NSString stringWithFormat:@"%@",cls];
            Id.tableId=1;
            [[XHBDBHelper shareDBHelper] insertToDB:Id];
            [tableDic setObject:Id forKey:[NSString stringWithFormat:@"%@",cls]];
        }else{
            Id.tableId+=1;
            idNumber=Id.tableId;
            [tableDic setObject:Id forKey:[NSString stringWithFormat:@"%@",cls]];
            [[XHBDBHelper shareDBHelper] updateToDB:Id where:[NSString stringWithFormat:@"tableName='%@'",cls]];
        }
    }else{
        count.tableId++;
        idNumber=count.tableId;
        [[XHBDBHelper shareDBHelper] updateToDB:count where:[NSString stringWithFormat:@"tableName='%@'",cls]];
    }
    [_thlock unlock];
    return idNumber;
}

@end
