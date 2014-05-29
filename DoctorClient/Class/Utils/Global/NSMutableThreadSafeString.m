//
//  NSMutableThreadSafeString.m
//  DoctorClient
//
//  Created by weqia on 14-4-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NSMutableThreadSafeString.h"

@implementation NSMutableThreadSafeString

+(dispatch_queue_t)queue
{
    static dispatch_queue_t queue;
    if (!queue) {
        queue=dispatch_queue_create("com.XHBMutiArray.operation", DISPATCH_QUEUE_CONCURRENT);
    }
    return queue;
}

+ (NSMutableString*)string
{
    NSMutableThreadSafeString * string=[[NSMutableThreadSafeString alloc]init];;
    return (NSMutableString*)string;
}
+ (NSMutableString*)stringWithString:(NSString *)string
{
    NSMutableThreadSafeString * string1=[[NSMutableThreadSafeString alloc]initWithString:string];
    return (NSMutableString*)string1;
}
+ (NSMutableString*)stringWithCharacters:(const unichar *)characters length:(NSUInteger)length
{
    NSMutableThreadSafeString * string1=[[NSMutableThreadSafeString alloc]initWithCharacters:characters length:length];
    return (NSMutableString*)string1;
}
+ (NSMutableString*)stringWithUTF8String:(const char *)nullTerminatedCString
{
    NSMutableThreadSafeString * string1=[[NSMutableThreadSafeString alloc]initWithUTF8String:nullTerminatedCString];
    return (NSMutableString*)string1;
}
+ (NSMutableString*)stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    NSMutableThreadSafeString * string1=[[NSMutableThreadSafeString alloc]initWithWithFormat:format,nil];
    return (NSMutableString*)string1;
}
-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    return [_string methodSignatureForSelector:aSelector];
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _string=[NSMutableString string];

    }
    return self;
}

-(instancetype)initWithString:(NSString *)string
{
    self=[super init];
    if (self) {
        _string=[NSMutableString stringWithString:string];
    }
    return self;
}
-(instancetype)initWithCharacters:(const unichar*)characters length:(NSUInteger)length
{
    self=[super init];
    if (self) {
        _string=[NSMutableString stringWithCharacters:characters length:length];
    }
    return self;
}
-(instancetype)initWithUTF8String:(const char * )nullTerminatedCString
{
    self=[super init];
    if (self) {
        _string=[NSMutableString stringWithUTF8String:nullTerminatedCString];
    }
    
    return  self;
}
-(instancetype)initWithWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    self=[super init];
    if (self) {
        _string=[NSMutableString stringWithFormat:format,nil];
    }
    return self;
    
}


-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    if([NSString instancesRespondToSelector:anInvocation.selector]){
        dispatch_sync([NSMutableThreadSafeString queue], ^{
            [anInvocation invokeWithTarget:_string];
        });
    }else if([NSMutableString instancesRespondToSelector:anInvocation.selector]){
        dispatch_barrier_async([NSMutableThreadSafeString queue], ^{
            [anInvocation invokeWithTarget:_string];
        });
    }
}

@end


@implementation NSMutableString (Global)

-(unichar)safeCharacterAtIndex:(NSUInteger)index
{
    if (index<self.length) {
        return [self characterAtIndex:index];
    }else{
        return 0;
    }
}

@end