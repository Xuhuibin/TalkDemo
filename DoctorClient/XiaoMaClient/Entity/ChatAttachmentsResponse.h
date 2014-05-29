//
//  
//  ChatAttachmentsResponse.h
//  AutomaticCoder
//
//  Created by Jim on 2014-5-12.
//  Copyright (c) 2014年 com.Jim. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseObjResponse.h"
#import "XiaoMaEntityProtocol.h"
#import "ChatAttachmentsResponseObj.h"


@interface ChatAttachmentsResponse : BaseObjResponse<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) ChatAttachmentsResponseObj *Obj;
 



@end
