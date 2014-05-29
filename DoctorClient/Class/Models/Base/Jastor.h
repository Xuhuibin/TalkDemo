//
//  Jastor.h
//  wq
//
//  Created by berwin on 13-7-11.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Jastor : NSObject<NSCoding>

@property (nonatomic, copy) NSString * objectId;

+ (id)objectFromDictionary:(NSDictionary*)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;

-(NSMutableDictionary*)toDictionaryWithProperty:(BOOL(^)(NSString * propertyName))property;


@end
