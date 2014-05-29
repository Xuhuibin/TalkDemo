//
//  NSMutableThreadSafeString.h
//  DoctorClient
//
//  Created by weqia on 14-4-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableThreadSafeString : NSObject
{
    NSMutableString * _string;
}
+ (NSMutableString*)string;
+ (NSMutableString*)stringWithString:(NSString *)string;
+ (NSMutableString*)stringWithCharacters:(const unichar *)characters length:(NSUInteger)length;
+ (NSMutableString*)stringWithUTF8String:(const char *)nullTerminatedCString;
+ (NSMutableString*)stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end


@interface NSMutableString (Global)
-(unichar)safeCharacterAtIndex:(NSUInteger)index;

@end