//
//  HBImageDownloader.h
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBImageDownloadOperation.h"
enum HBImageCacheType
{
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    HBImageCacheTypeNone = 0,
    /**
     * The image was save to the disk cache.
     */
    HBImageCacheTypeDisk,
    /**
     * The image was save to the memory cache and disk.
     */
    HBImageCacheTypeMemory,
    /**
     * The image was save to only the memory cache .
     */
    HBImageCacheTypeOnlyMemory
};
typedef enum HBImageCacheType HBImageCacheType;


@interface HBImageDownloader : NSObject
{
    NSMutableDictionary* _downLoads;
    NSLock* _lock;
}
+(HBImageDownloader*)shareDownLoader;

-(id<HBImageLoadOperation>)downloadImageWithURL:(NSURL*)url
                   progress:(HBImageDownloaderProgressBlock)progressBlock
                   complete:(HBImageDownloaderCompletedBlock)completeBlock
                  cacheType:(HBImageCacheType)cacheType;


@end
