//
//  
//  ChatAttachmentsResponseObj.h
//  AutomaticCoder
//
//  Created by Jim on 2014-5-12.
//  Copyright (c) 2014年 com.Jim. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ChatAttachmentsResponseObj : NSObject<NSCoding>

@property (nonatomic,strong) NSString *C_AttachmentName;
@property (nonatomic,strong) NSString *C_Filetype;
@property (nonatomic,strong) NSString *C_Filename;
@property (nonatomic,strong) NSNumber *C_TypeID;
@property (nonatomic,strong) NSNumber *C_FileSize;
@property (nonatomic,strong) NSString *C_ToUserName;
@property (nonatomic,strong) NSString *C_AudioRecordTime;
@property (nonatomic,strong) NSString *C_SendUserName;
@property (nonatomic,strong) NSString *CreateOn;
@property (nonatomic,strong) NSNumber *ChatAttachmentsID;
 

-(id)initWithJson:(NSDictionary *)json;

@end
