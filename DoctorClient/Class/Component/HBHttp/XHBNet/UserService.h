//
//  UserService.h
//  wq
//
//  Created by berwin on 13-6-18.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultEx.h"
#import "ServiceParam.h"
#import "ASIFormDataRequest.h"
#import "NSOperationQueue+global.h"


@class UserService;

@interface UserService :NSObject
{
    void(^_complete)(id  result);
    void(^_failed)(id  result);
}
+ (UserService *)sharedInstance;

- (NSString*)getFileUploadUrl;

+ (NSString*)encodeBase64:(NSData*)data;
+ (NSString *)decodeBase64:(NSData *)data;

-(ASIHTTPRequest*)uploadFileToServer:(ServiceParam *)param completeBlock:(void(^)(id  result))completeBlock failedBlock:(void(^)(id result))failedBlock view:(UIView*)view;

-(void)cancel;
@end
