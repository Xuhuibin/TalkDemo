//
//  
//  ChatAttachmentsResponseObj.m
//  AutomaticCoder
//
//  Created by Jim on 2014-5-12.
//  Copyright (c) 2014年 com.Jim. All rights reserved.
//

#import "ChatAttachmentsResponseObj.h"

@implementation ChatAttachmentsResponseObj


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.C_AttachmentName  = [[json objectForKey:@"C_AttachmentName"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_AttachmentName"];
 self.C_Filetype  = [[json objectForKey:@"C_Filetype"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_Filetype"];
 self.C_Filename  = [[json objectForKey:@"C_Filename"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_Filename"];
 self.C_TypeID  = [[json objectForKey:@"C_TypeID"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_TypeID"];
 self.C_FileSize  = [[json objectForKey:@"C_FileSize"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_FileSize"];
 self.C_ToUserName  = [[json objectForKey:@"C_ToUserName"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_ToUserName"];
 self.C_AudioRecordTime  = [[json objectForKey:@"C_AudioRecordTime"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_AudioRecordTime"];
 self.C_SendUserName  = [[json objectForKey:@"C_SendUserName"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"C_SendUserName"];
 self.CreateOn  = [[json objectForKey:@"CreateOn"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"CreateOn"];
 self.ChatAttachmentsID  = [[json objectForKey:@"ChatAttachmentsID"] isKindOfClass:[NSNull class]] ? nil : [json objectForKey:@"ChatAttachmentsID"];
 
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.C_AttachmentName forKey:@"C_AttachmentName"];
[aCoder encodeObject:self.C_Filetype forKey:@"C_Filetype"];
[aCoder encodeObject:self.C_Filename forKey:@"C_Filename"];
[aCoder encodeObject:self.C_TypeID forKey:@"C_TypeID"];
[aCoder encodeObject:self.C_FileSize forKey:@"C_FileSize"];
[aCoder encodeObject:self.C_ToUserName forKey:@"C_ToUserName"];
[aCoder encodeObject:self.C_AudioRecordTime forKey:@"C_AudioRecordTime"];
[aCoder encodeObject:self.C_SendUserName forKey:@"C_SendUserName"];
[aCoder encodeObject:self.CreateOn forKey:@"CreateOn"];
[aCoder encodeObject:self.ChatAttachmentsID forKey:@"ChatAttachmentsID"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.C_AttachmentName = [aDecoder decodeObjectForKey:@"C_AttachmentName"];
 self.C_Filetype = [aDecoder decodeObjectForKey:@"C_Filetype"];
 self.C_Filename = [aDecoder decodeObjectForKey:@"C_Filename"];
 self.C_TypeID = [aDecoder decodeObjectForKey:@"C_TypeID"];
 self.C_FileSize = [aDecoder decodeObjectForKey:@"C_FileSize"];
 self.C_ToUserName = [aDecoder decodeObjectForKey:@"C_ToUserName"];
 self.C_AudioRecordTime = [aDecoder decodeObjectForKey:@"C_AudioRecordTime"];
 self.C_SendUserName = [aDecoder decodeObjectForKey:@"C_SendUserName"];
 self.CreateOn = [aDecoder decodeObjectForKey:@"CreateOn"];
 self.ChatAttachmentsID = [aDecoder decodeObjectForKey:@"ChatAttachmentsID"];
 
    }
    return self;
}

@end
