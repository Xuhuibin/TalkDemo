//
//  NSMutableThreadSafeArray.h
//  DoctorClient
//
//  Created by weqia on 14-4-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableThreadSafeArray : NSObject
@property(nonatomic,strong,readonly)NSMutableArray * array;
+ (NSMutableArray *)array;
+ (NSMutableArray *)arrayWithObject:(id)anObject;
+ (NSMutableArray *)arrayWithArray:(NSArray *)array;
-(void)addObjectsFromArray:(NSArray*)array;
@end

@interface NSMutableArray (Global)
-(void)safeRemoveObjectAtIndex:(NSUInteger)index;
-(id)safeObjectAtIndex:(NSUInteger)index;
@end