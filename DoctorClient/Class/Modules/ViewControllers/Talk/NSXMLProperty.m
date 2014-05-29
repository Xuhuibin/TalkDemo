//
//  NSXMLProperty.m
//  DoctorClient
//
//  Created by weqia on 14-5-12.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NSXMLProperty.h"

@implementation NSXMLProperty
+(NSXMLElement*)propertyElement:(NSString*)value forName:(NSString*)string
{
    NSXMLElement * element=[NSXMLElement elementWithName:@"property"];
    NSXMLElement * name=[NSXMLElement elementWithName:@"name" stringValue:string];
    NSXMLElement * elementValue=[NSXMLElement elementWithName:@"value" stringValue:value];
    [elementValue addAttributeWithName:@"type" stringValue:@"string"];
    [element addChild:name];
    [element addChild:elementValue];
    return element;
}
+(void)parserElement:(NSXMLElement*)element callback:(void(^)(NSString* name,NSString* value))callback
{
    NSString * name,*value;
    for (NSXMLElement* ele in element.children) {
        if ([ele.name isEqualToString:@"name"]) {
            name=[ele stringValue];
        }else if([ele.name isEqualToString:@"value"]){
            value=[ele stringValue];
        }
    }
    if (callback) {
        callback(name,value);
    }
}

@end
