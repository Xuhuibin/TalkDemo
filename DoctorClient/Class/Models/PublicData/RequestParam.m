//
//  RequestParam.m
//  wq
//
//  Created by berwin on 13-7-8.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "RequestParam.h"
#import "ASIFormDataRequest.h"
#import "NSStrUtil.h"
@implementation RequestParam
@synthesize strParam;
@synthesize fileParam;


//添加一个str的参数
- (void) put:(NSString *) key withValue: (NSString *) value {
    if (strParam == nil) {
        strParam = [[NSMutableDictionary alloc] init];
    }
    if([NSStrUtil notEmptyOrNull:value]){
        [strParam setValue:value forKey:key];
    }
}
-(void)putEmptyStringForKey:(NSString*)key
{
    if (strParam == nil) {
        strParam = [[NSMutableDictionary alloc] init];
    }
    NSString * string=@"  ";
    [strParam setValue:string forKey:key];
}
//添加一个文件参数，传入文件路径
/**
 添加一个文件参数，传入文件路径
 value 可以是一个文件路径，也可以是一个NSData
 **/
- (void) putFile:(NSString *) key withValue: (id) value name:(NSString*)name mimeType:(NSString*)mimeType fileType:(NSString*)fileType{
    if (value==nil) {
        return;
    }
    if (fileParam == nil) {
        fileParam = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:value forKey:@"value"];
    if ([value isKindOfClass:[NSData class]]) {
        if ([NSStrUtil isEmptyOrNull:name]) {
            name=@"file.jpg";
        }
        if ([NSStrUtil isEmptyOrNull:mimeType]) {
            mimeType=@"image/jpeg";
        }
        [dic setObject:name forKey:@"name"];
        [dic setObject:mimeType forKey:@"mimeType"];
        [fileParam setValue:dic forKey:key];
    }else if ([value isKindOfClass:[NSString class]]){
        if ([NSStrUtil notEmptyOrNull:name]) {
            [dic setObject:name forKey:@"name"];
        }
        if ([NSStrUtil notEmptyOrNull:mimeType]) {
            [dic setObject:mimeType forKey:@"mimeType"];
        }
        [fileParam setValue:dic forKey:key];
    }
}



@end
