//
//  HBFileCache.h
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBDBHelper.h"
#import "NSStrUtil.h"
#import "HBFileCacheData.h"
@interface HBFileCache : NSObject
{
    NSString *_cacheFilePath;
    NSCache * _memoryCache;
}
+(HBFileCache*)shareCache;



-(NSString*)storeFile:(NSData*)fileData;

-(BOOL)storeFile:(NSData *)fileData forUrl:(NSString*)url;

-(NSData*)getDataFromCache:(NSString *)key;

-(UIImage*)getImageFromCache:(NSString*)key;


-(NSString*)storeFileToDisk:(NSData*)fileData;

-(BOOL)storeFileToDisk:(NSData *)fileData forUrl:(NSString*)url;

-(NSData*)getDataFromDisk:(NSString *)key;

-(BOOL)fileCached:(NSString*)key;

-(UIImage*)getImageFromDisk:(NSString*)key;

-(NSString*)filePathForKey:(NSString*)key;


-(BOOL)storeFileToMemory:(NSData *)fileData forKey:(NSString*)key;

-(NSData*)getDataFromMemory:(NSString*)key;



-(BOOL)storeImageToMemory:(UIImage*)image forKey:(NSString*)key;

-(UIImage*)getImageFromMemory:(NSString*)key;

-(void)unStoreDataForKey:(NSString*)key;

-(void)forwardDataFromKey:(NSString*)fromKey forKey:(NSString*)toKey;

@end
