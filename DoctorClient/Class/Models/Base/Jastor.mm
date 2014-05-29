//
//  Jastor.m
//  wq
//
//  Created by berwin on 13-7-11.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "Jastor.h"
#import "JastorRuntimeHelper.h"
#import "JSONKit.h"
@implementation Jastor

@synthesize objectId;

static NSString *idPropertyName = @"idProperty";
static NSString *idPropertyNameOnObject = @"objectId";

Class nsDictionaryClass;
Class nsArrayClass;

+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    id item = [[self alloc] initWithDictionary:dictionary];
    return item;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (!nsDictionaryClass) nsDictionaryClass = [NSDictionary class];
	if (!nsArrayClass) nsArrayClass = [NSArray class];
	
	if ((self = [super init])) {
		for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
            
			id value = [dictionary valueForKey:key];
			
			if (value == [NSNull null] || value == nil) {
                continue;
            }
            
            if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			
			// handle dictionary
			if ([value isKindOfClass:nsDictionaryClass]) {
//				Class klass = [JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
//				value = [[klass alloc] initWithDictionary:value];
			}
			// handle array
			else if ([value isKindOfClass:nsArrayClass]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//                Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_class", key])];
//#pragma clang diagnostic pop
//				
//				
//				NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)value count]];
//				
//				for (id child in value) {
//					if ([[child class] isSubclassOfClass:nsDictionaryClass]) {
//						Jastor *childDTO = [[arrayItemType alloc] initWithDictionary:child];
//						[childObjects addObject:childDTO];
//					} else {
//						[childObjects addObject:child];
//					}
//				}
//				
//				value = childObjects;
			}
			// handle all others
			[self setValue:value forKey:key];
		}
		
		id objectIdValue;
		if ((objectIdValue = [dictionary objectForKey:idPropertyName]) && objectIdValue != [NSNull null]) {
			if (![objectIdValue isKindOfClass:[NSString class]]) {
				objectIdValue = [NSString stringWithFormat:@"%@", objectIdValue];
			}
			[self setValue:objectIdValue forKey:idPropertyNameOnObject];
		}
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:self.objectId forKey:idPropertyNameOnObject];
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
		[encoder encodeObject:[self valueForKey:key] forKey:key];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		[self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
		
		for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
            if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

- (NSMutableDictionary *)toDictionary {
    return [self toDictionaryWithProperty:nil];
}

-(NSMutableDictionary*)toDictionaryWithProperty:(BOOL(^)(NSString * propertyName))property
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.objectId) {
        [dic setObject:self.objectId forKey:idPropertyName];
    }
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        if(property){
            if(!property(key))
                continue;
        }
		id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[Jastor class]]) {
            [dic setObject:[value toDictionary] forKey:key];
        } else if (value && [value isKindOfClass:[NSArray class]] && ((NSArray*)value).count > 0) {
            id internalValue = [value objectAtIndex:0];
            if (internalValue && [internalValue isKindOfClass:[Jastor class]]) {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value) {
                    [internalItems addObject:[item toDictionary]];
                }
                [dic setObject:internalItems forKey:key];
            } else {
                [dic setObject:value forKey:key];
            }
        }else if([value isKindOfClass:[NSDictionary class]]&&value!=nil){
            BOOL can=YES;
            NSArray * keys=[value allKeys];
            for(NSString *key in keys){
                id Value=[((NSDictionary*)value) objectForKey:key];
                if([Value isKindOfClass:[NSData class]])
                {
                    can=NO;
                    break;
                }
            }
            if(can){
                NSString * string=[(NSDictionary*)value JSONString];
                [dic setObject:string forKey:key];
            }else{
                [dic setObject:value forKey:key];
            }
        }
        else if (value != nil) {
            [dic setObject:value forKey:key];
        }
	}
    return dic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
	
	return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.objectId, [dic description]];
}

- (BOOL)isEqual:(id)object {
	if (object == nil || ![object isKindOfClass:[Jastor class]]) return NO;
	
	Jastor *model = (Jastor *)object;
	
	return [self.objectId isEqualToString:model.objectId];
}


@end
