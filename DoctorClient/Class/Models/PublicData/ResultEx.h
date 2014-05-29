//
//  ResultEx.h
//  wq
//
//  Created by berwin on 13-7-9.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "Result.h"

@interface ResultEx : Result

- (BaseData *)getDataObject:(Class) cls;

- (NSArray *)getDataArray:(Class) cls;

- (BOOL) isSuccess;

+ (NSArray *)getDataArray:(Class) cls withStr:(NSString *) str;
+ (BaseData *)getDataObject:(Class) cls withStr:(NSString*) str;

@end
