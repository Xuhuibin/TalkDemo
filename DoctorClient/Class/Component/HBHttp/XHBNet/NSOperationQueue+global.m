//
//  NSOperationQueue+global.m
//  wq8
//
//  Created by weqia on 13-11-26.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "NSOperationQueue+global.h"

@implementation NSOperationQueue (global)
+(id)uploadQueue
{
    static NSOperationQueue * uploadQueue=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadQueue=[[NSOperationQueue alloc]init];
        uploadQueue.maxConcurrentOperationCount=5;
    });
    return uploadQueue;
}

+(id)downLoadQueue
{
    static NSOperationQueue * downLoadQueue=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoadQueue=[[NSOperationQueue alloc]init];
        downLoadQueue.maxConcurrentOperationCount=5;
    });
    return downLoadQueue;
}

+(id)operationQueue
{
    static NSOperationQueue * operationQueue=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue=[[NSOperationQueue alloc]init];
        operationQueue.maxConcurrentOperationCount=5;
    });
    return operationQueue;
}
+(id)dboprationQueue;
{
    static NSOperationQueue * operationQueue=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue=[[NSOperationQueue alloc]init];
        operationQueue.maxConcurrentOperationCount=3;
    });
    return operationQueue;

}
+(id)otherQueue
{
    static NSOperationQueue * operationQueue=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue=[[NSOperationQueue alloc]init];
        operationQueue.maxConcurrentOperationCount=3;
    });
    return operationQueue;
}

@end
