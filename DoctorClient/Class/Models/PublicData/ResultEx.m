//
//  ResultEx.m
//  wq
//
//  Created by berwin on 13-7-9.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "ResultEx.h"

@implementation ResultEx

//获取单个对象
- (BaseData *)getDataObject:(Class) cls {
    return [ResultEx getDataObject:cls withStr:self.object];
}

+ (BaseData *)getDataObject:(Class) cls withStr:(NSString*) str {
    if (![str isKindOfClass:[NSString class]]) {
        str = [str JSONString];
    }
    NSString * obj = str;
    if ([NSStrUtil isEmptyOrNull:obj]) {
        return nil;
    }
    
    if (cls == nil) {
        return nil;
    }
    
    NSDictionary* result = [obj objectFromJSONString];
    if (result != nil) {
        return [[cls alloc] initWithDictionary:result];
    } else {
        return nil;
    }

}

+ (NSArray *)getDataArray:(Class) cls withStr:(NSString *) str {
    
    if (![str isKindOfClass:[NSString class]]) {
        str = [str JSONString];
    }
    
    if ([NSStrUtil isEmptyOrNull:str]) {
        return nil;
    }
    
    if (cls == nil) {
        return nil;
    }
    
    NSArray *arr = [str objectFromJSONString];
    if (arr != nil) {
        NSMutableArray *entitys = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arr) {
            BaseData *data = [[cls alloc] initWithDictionary:dic];
            if (data != nil) {
                [entitys addObject:data];
            }
        }
        return entitys;
    } else {
        return nil;
    }

}

//获取一组对象
- (NSArray *)getDataArray:(Class) cls {
    NSString * list = [self.list JSONString];
    return [ResultEx getDataArray:cls withStr:list];
}

- (BOOL) isSuccess {
    NSString *ret = self.ret;
    if ([NSStrUtil notEmptyOrNull:ret]) {
        if ([ret intValue] >= 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
