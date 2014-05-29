//
//  HBImageDownloader.m
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "HBImageDownloader.h"
#import "HBImageloadFomDatabaseOperation.h"
#import "HBFileCache.h"
#import "UIImage+GIF.h"
#import "NSData+GIF.h"
#import "NSOperationQueue+global.h"
@implementation HBImageDownloader

-(id)init
{
    self=[super init];
    if (self) {
        _downLoads=[[NSMutableDictionary alloc]init];
        _lock=[[NSLock alloc]init];
    }
    return self;
}
#pragma -mark 接口
+(HBImageDownloader*)shareDownLoader
{
    static HBImageDownloader * downloader=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader=[[HBImageDownloader alloc]init];
    });
    return downloader;
}
-(id<HBImageLoadOperation>)downloadImageWithURL:(NSURL*)url
                   progress:(HBImageDownloaderProgressBlock)progressBlock
                   complete:(HBImageDownloaderCompletedBlock)completeBlock
                  cacheType:(HBImageCacheType)cacheType
{
    if (url==nil) {
        return nil;
    }
    NSString * urlKey=nil;
    NSURL * URL=nil;
    if ([url isKindOfClass:[NSURL class]]) {
        urlKey=url.absoluteString;
        URL=url;
    }else if([url isKindOfClass:[NSString class]]){
        URL=[NSURL URLWithString:(NSString*)url];
        urlKey=(NSString*)url;
    }else{
        return nil;
    }
    UIImage * image=[[HBFileCache shareCache] getImageFromMemory:urlKey];
    if (image) {
        if (completeBlock) {
            completeBlock(image,nil,nil,YES,HBImageGetFroMemory);
            return nil;
        }
    }else if([[HBFileCache shareCache] fileCached:urlKey]){
       id<HBImageLoadOperation>operation=[HBImageloadFomDatabaseOperation operationWithURL:urlKey complete:^(UIImage *image1, NSData *data, NSError *error, BOOL finished,HBImageGetFrom imageFrom) {
            if (cacheType==HBImageCacheTypeMemory||cacheType==HBImageCacheTypeOnlyMemory) {
                [[HBFileCache shareCache] storeImageToMemory:image1 forKey:urlKey];
            }
            if (completeBlock) {
                completeBlock(image1,data,nil,YES,imageFrom);
            }
        }];
        return operation;
    }
    if (URL==nil) {
        return nil;
    }
    id<HBImageLoadOperation>operation;
    operation=[[HBImageDownloadOperation alloc]initWithRequest:[NSURLRequest requestWithURL:URL] progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished,HBImageGetFrom imageFrom) {
        if (finished) {
            UIImage * image1=[UIImage sd_imageWithData:data];
            if (image1) {
                if (cacheType==HBImageCacheTypeDisk) {
                    [[HBFileCache shareCache] storeFileToDisk:data forUrl:urlKey];
                }else if (cacheType==HBImageCacheTypeMemory) {
                    [[HBFileCache shareCache] storeFileToDisk:data forUrl:urlKey];
                    [[HBFileCache shareCache] storeImageToMemory:image1 forKey:urlKey];
                }else if(cacheType==HBImageCacheTypeOnlyMemory){
                    [[HBFileCache shareCache] storeImageToMemory:image1 forKey:urlKey];
                }
            }
            if (completeBlock) {
                completeBlock(image1,data,error,YES,imageFrom);
            }
        }
        else{
            if (completeBlock) {
                completeBlock(nil,data,error,NO,imageFrom);
            }
        }

    } cancelled:^{
        if (completeBlock) {
            completeBlock(nil,nil,nil,NO,HBImageGetFromNone);
        }
    }];
    if (operation) {
        [[NSOperationQueue downLoadQueue] addOperation:operation];
    }
    return operation;
}



@end
