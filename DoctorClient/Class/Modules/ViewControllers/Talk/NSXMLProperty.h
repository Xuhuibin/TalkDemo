//
//  NSXMLProperty.h
//  DoctorClient
//
//  Created by weqia on 14-5-12.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
@interface NSXMLProperty : NSObject
+(NSXMLElement*)propertyElement:(NSString*)value forName:(NSString*)string;
+(void)parserElement:(NSXMLElement*)element callback:(void(^)(NSString* name,NSString* value))callback;
@end
