//
//  HBImageDownloadOperation.h
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "HBImageLoadOperation.h"
#import "UIImage+GIF.h"


enum HBImageGetFrom
{
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    HBImageGetFromWeb = 0,
    /**
     * The image was save to the disk cache.
     */
    HBImageGetFromDisk,
    /**
     * The image was save to the memory cache and disk.
     */
    HBImageGetFroMemory,
    /**
     * The image was save to only the memory cache .
     */
    HBImageGetFromNone
};
typedef enum HBImageGetFrom HBImageGetFrom;

typedef void(^HBImageDownloaderProgressBlock)(unsigned long long receivedSize, unsigned long long expectedSize);
typedef void(^HBImageDownloaderCompletedBlock)(UIImage*image, NSData *data, NSError *error, BOOL finished,HBImageGetFrom imageFrom);
typedef void (^HBImageDownloaderCancelBlock)();

@interface HBImageDownloadOperation : NSOperation<HBImageLoadOperation>
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (strong, nonatomic,readonly) HBImageDownloaderCompletedBlock completeBlock;
@property (strong, nonatomic,readonly) HBImageDownloaderProgressBlock progressBlock;
@property (copy, nonatomic) HBImageDownloaderCancelBlock cancelBlock;

@property (assign, nonatomic) long long expectedSize;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic, readonly) NSURLRequest *request;
- (id)initWithRequest:(NSURLRequest *)request
             progress:(HBImageDownloaderProgressBlock)progressBlock
            completed:(HBImageDownloaderCompletedBlock)completedBlock
            cancelled:(void (^)())cancelBlock;;


@end
