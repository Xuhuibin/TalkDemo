//
//  UIImageView+Cache.m
//  mailcore2
//
//  Created by weqia on 14-3-2.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "objc/runtime.h"


static char operationKey;

@implementation UIImageView (Cache)
- (void)setImageWithURL:(NSURL *)url;
{
    [self setImageWithURL:url placeholderImage:nil cacheType:HBImageCacheTypeMemory  completed:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
{
    [self setImageWithURL:url placeholderImage:placeholder cacheType:HBImageCacheTypeMemory completed:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cacheType:(HBImageCacheType)cacheType;
{
    [self setImageWithURL:url placeholderImage:placeholder cacheType:cacheType completed:nil];
}
- (void)setImageWithURL:(NSURL *)url completed:(HBImageDownloaderCompletedBlock)completedBlock;
{
    [self setImageWithURL:url placeholderImage:nil cacheType:HBImageCacheTypeMemory completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(HBImageDownloaderCompletedBlock)completedBlock;
{
    [self setImageWithURL:url placeholderImage:placeholder cacheType:HBImageCacheTypeMemory completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cacheType:(HBImageCacheType)cacheType completed:(HBImageDownloaderCompletedBlock)completedBlock;
{
    [self cancelCurrentImageLoad];
    self.image=placeholder;
    __weak UIImageView * wself=self;
    id <HBImageLoadOperation> operation=[[HBImageDownloader shareDownLoader] downloadImageWithURL:url progress:nil complete:^(UIImage *image, NSData *data, NSError *error, BOOL finished,HBImageGetFrom imageFrom) {
        if (!wself) return;
        void (^block)(void) = ^
        {
            __strong UIImageView *sself = wself;
            if (!sself) return;
            if (image)
            {
                sself.image = image;
                [sself setNeedsLayout];
            }
        };
        if ([NSThread isMainThread])
        {
            block();
            if (completedBlock) {
                completedBlock(image,data,error,finished,imageFrom);
            }
        }else
        {
            dispatch_sync(dispatch_get_main_queue(), block);
            if (completedBlock) {
                completedBlock(image,data,error,finished,imageFrom);
            }
        }
    } cacheType:cacheType];
    objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<HBImageLoadOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
@end
