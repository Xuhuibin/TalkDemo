//
//  NSMutableThreadSafeArray.m
//  DoctorClient
//
//  Created by weqia on 14-4-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NSMutableThreadSafeArray.h"

@implementation NSMutableThreadSafeArray

#pragma -mark 接口
+ (NSMutableArray*)array
{
    NSMutableThreadSafeArray * array=[[NSMutableThreadSafeArray alloc]init];
    return (NSMutableArray*)array;
}
+ (NSMutableArray*)arrayWithArray:(NSArray *)anArray
{
    NSMutableThreadSafeArray * array=[[NSMutableThreadSafeArray alloc]initWithArray:anArray];
    return (NSMutableArray*)array;
}
+ (NSMutableArray *)arrayWithObject:(id)anObject
{
    NSMutableThreadSafeArray * array=[[NSMutableThreadSafeArray alloc]initWithObject:anObject];
    return (NSMutableArray*)array;
}
+(dispatch_queue_t)queue
{
    static dispatch_queue_t queue;
    if (!queue) {
        queue=dispatch_queue_create("com.XHBMutiArray.operation", DISPATCH_QUEUE_CONCURRENT);
    }
    return queue;
}

- (instancetype)init
{
    self=[super init];
    _array=[NSMutableArray array];
    return self;
}
- (instancetype)initWithArray:(NSArray*)anArray
{
    self=[super init];
    _array=[NSMutableArray arrayWithArray:anArray];
    return self;
}
-(instancetype)initWithObject:(id)anObject
{
    self=[super init];
    _array=[NSMutableArray arrayWithObject:anObject];
    return self; 
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    return [[_array class]instanceMethodSignatureForSelector:aSelector];
}
-(void)addObjectsFromArray:(NSArray*)array
{
    if ([array isKindOfClass:[NSArray class]]) {
        dispatch_barrier_async([NSMutableThreadSafeArray queue], ^{
            [_array addObjectsFromArray:array];
        });
    }else if([array isKindOfClass:[self class]]){
        dispatch_barrier_async([NSMutableThreadSafeArray queue], ^{
            [_array addObjectsFromArray:((NSMutableThreadSafeArray*)array).array];
        });
    }
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    if([NSArray instancesRespondToSelector:anInvocation.selector]){
        dispatch_sync([NSMutableThreadSafeArray queue], ^{
            [anInvocation invokeWithTarget:_array];
        });
    }else if([NSMutableArray instancesRespondToSelector:anInvocation.selector]){
        dispatch_barrier_async([NSMutableThreadSafeArray queue], ^{
            [anInvocation invokeWithTarget:_array];
        });
    }
}

@end


@implementation NSMutableArray (Global)

-(void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    @try {
        [self removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        if (exception) {
            NSLog(@"%@",[exception name]);
        }
    }
}
-(id)safeObjectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}

@end
