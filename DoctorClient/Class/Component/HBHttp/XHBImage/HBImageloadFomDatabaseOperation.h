//
//  HBImageloadFomDatabaseOperation.h
//  mailcore2
//
//  Created by weqia on 14-3-2.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBImageLoadOperation.h"
#import "HBImageDownloadOperation.h"
@interface HBImageloadFomDatabaseOperation : NSOperation<HBImageLoadOperation>

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (strong, nonatomic,readonly) HBImageDownloaderCompletedBlock completeBlock;
@property (strong, nonatomic,readonly)  NSString * url;

+(HBImageloadFomDatabaseOperation*)operationWithURL:(NSString*)url complete:(HBImageDownloaderCompletedBlock)completeBlock;

@end
