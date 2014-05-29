
//
//  HBFileCache.m
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "HBFileCache.h"
#import "UIImage+GIF.h"
@implementation HBFileCache
-(id)init
{
    self=[super init];
    if(self){
        NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSMutableString * path=[NSMutableString stringWithString:[paths objectAtIndex:0]];
        [path appendFormat:@"/HBFileCache"];
        _cacheFilePath=path;
        NSFileManager * manager=[NSFileManager defaultManager];
        if(![manager fileExistsAtPath:_cacheFilePath])
            [manager createDirectoryAtPath:_cacheFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
        _memoryCache=[[NSCache alloc]init];
        [_memoryCache setTotalCostLimit:5*1024*1024];
    }
    return self;
}
#pragma -mark 接口
+(HBFileCache*)shareCache
{
    static HBFileCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[HBFileCache alloc]init];
        [[XHBDBHelper shareDBHelper] createTableWithModelClass:[HBFileCacheData class]];
    });
    return cache;
}

-(NSString*)storeFile:(NSData*)fileData
{
    HBFileCacheData * cache=[[HBFileCacheData alloc]init];
    cache.cacheId=[[XHBDBHelper shareDBHelper] newIdforTable:[HBFileCacheData class]];
    cache.filekey=[[NSString stringWithFormat:@"fileCache-%d",cache.cacheId] md5];
    NSMutableString * fileName=[NSMutableString stringWithString:_cacheFilePath];
    [fileName appendFormat:@"/%@",cache.filekey];
    cache.cacheFileName=fileName;
    if([[XHBDBHelper shareDBHelper] insertToDB:cache]){
        if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
            [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            return  nil;
        }else{
            [self storeFileToMemory:fileData forKey:cache.filekey];
            return [NSString stringWithFormat:@"fileCache-%d",cache.cacheId];
        }
    }
    return nil;
}

-(BOOL)storeFile:(NSData *)fileData forUrl:(NSString*)url
{
    if([NSStrUtil isEmptyOrNull:url])
        return NO;
    int rowCount=[[XHBDBHelper shareDBHelper] rowCount:[HBFileCacheData class] where:@{@"filekey":[url  md5]}];
    if(rowCount==0){
        HBFileCacheData * cache=[[HBFileCacheData alloc]init];
        cache.cacheId=[[XHBDBHelper shareDBHelper] newIdforTable:[HBFileCacheData class]];
        cache.filekey=[url md5];
        NSMutableString * fileName=[NSMutableString stringWithString:_cacheFilePath];
        [fileName appendFormat:@"/%@",[url md5]];
        cache.cacheFileName=fileName;
        if([[XHBDBHelper shareDBHelper] insertToDB:cache]){
            if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
                [[XHBDBHelper shareDBHelper] deleteToDB:cache];
                return  NO;
            }else{
                [self storeFileToMemory:fileData forKey:url];
                return YES;
            }
        }
    }else{
        HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[url  md5]} orderBy:nil];
        if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
            [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            return  NO;
        }else{
            [self storeFileToMemory:fileData forKey:url];
            return YES;
        }
    }
    return NO;
}

-(NSString*)storeFileToDisk:(NSData*)fileData
{
    HBFileCacheData * cache=[[HBFileCacheData alloc]init];
    cache.cacheId=[[XHBDBHelper shareDBHelper] newIdforTable:[HBFileCacheData class]];
    cache.filekey=[[NSString stringWithFormat:@"fileCache-%d",cache.cacheId] md5];
    NSMutableString * fileName=[NSMutableString stringWithString:_cacheFilePath];
    [fileName appendFormat:@"/%@",cache.filekey];
    cache.cacheFileName=fileName;
    if([[XHBDBHelper shareDBHelper] insertToDB:cache]){
        if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
            [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            return  nil;
        }else{
            return [NSString stringWithFormat:@"fileCache-%d",cache.cacheId];
        }
    }
    return nil;
}

-(BOOL)storeFileToDisk:(NSData *)fileData forUrl:(NSString*)url
{
    if([NSStrUtil isEmptyOrNull:url])
        return NO;
    int rowCount=[[XHBDBHelper shareDBHelper] rowCount:[HBFileCacheData class] where:@{@"filekey":[url  md5]}];
    if(rowCount==0){
        HBFileCacheData * cache=[[HBFileCacheData alloc]init];
        cache.cacheId=[[XHBDBHelper shareDBHelper] newIdforTable:[HBFileCacheData class]];
        cache.filekey=[url md5];
        NSMutableString * fileName=[NSMutableString stringWithString:_cacheFilePath];
        [fileName appendFormat:@"/%@",[url md5]];
        cache.cacheFileName=fileName;
        if([[XHBDBHelper shareDBHelper] insertToDB:cache]){
            if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
                [[XHBDBHelper shareDBHelper] deleteToDB:cache];
                return  NO;
            }else{
                return YES;
            }
        }
    }else{
        HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[url  md5]} orderBy:nil];
        if (![fileData writeToFile:cache.cacheFileName atomically:NO]) {
            [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            return  NO;
        }else{
             return YES;
        }
    }
    return NO;
}

-(BOOL)storeFileToMemory:(NSData *)fileData forKey:(NSString*)key
{
    id object=[_memoryCache objectForKey:[key md5]];
    if(object==nil&&fileData!=nil){
        [_memoryCache setObject:fileData forKey:[key md5]];
        return YES;
    }else
        return NO;
}

-(BOOL)storeImageToMemory:(UIImage*)image forKey:(NSString*)key
{
    id object=[_memoryCache objectForKey:[key md5]];
    if(object==nil&&image!=nil){
        [_memoryCache setObject:image forKey:[key md5]];
        return YES;
    }else
        return NO;
}

-(NSData*)getDataFromMemory:(NSString*)key
{
    return [_memoryCache objectForKey:[key md5]];
}
-(UIImage*)getImageFromMemory:(NSString*)key
{
    return [_memoryCache objectForKey:[key md5]];
}

-(UIImage*)getImageFromDisk:(NSString*)key
{
    NSData * data=[self getDataFromDisk:key];
    if (data) {
        UIImage * image1=[UIImage sd_imageWithData:data];
        return image1;
    }else{
        return nil;
    }
}

-(NSData*)getDataFromDisk:(NSString *)key
{
    if([NSStrUtil notEmptyOrNull:key]){
        HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"fileKey":[key md5]} orderBy:nil];
        if(cache){
            NSData* data=[NSData dataWithContentsOfFile:cache.cacheFileName];
            if(data==nil){
                [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            }
            return data;
        }
        return nil;
    }else{
        return nil;
    }
}

-(NSData*)getDataFromCache:(NSString *)key
{
    NSData * data=[self getDataFromMemory:key];
    if (!data) {
        data=[self getDataFromDisk:key];
    }
    return data;
}
-(UIImage*)getImageFromCache:(NSString*)key
{
    NSData * data=[self getDataFromCache:key];
    if (data) {
        if ([data isKindOfClass:[UIImage class]]) {
            return (UIImage*)data;
        }else{
            UIImage * image1=[UIImage sd_imageWithData:data];
            return image1;
        }
    }else{
        return nil;
    }
}


-(BOOL)fileCached:(NSString*)key;
{
    HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[key  md5]} orderBy:nil];
    if (cache) {
        NSFileManager * manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:cache.cacheFileName isDirectory:nil]) {
            return YES;
        }else{
            [[XHBDBHelper shareDBHelper] deleteToDB:cache];
            return NO;
        }
    }else{
        return NO;
    }
}
-(void)unStoreDataForKey:(NSString*)key
{
    HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[key  md5]} orderBy:nil];
    if (cache) {
        NSFileManager * manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:cache.cacheFileName isDirectory:nil]) {
            [manager removeItemAtPath:cache.cacheFileName error:nil];
        }
        [[XHBDBHelper shareDBHelper] deleteToDB:cache];
    }
}
-(void)forwardDataFromKey:(NSString*)fromKey forKey:(NSString*)toKey
{
    HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[fromKey  md5]} orderBy:nil];
    if (cache) {
        NSFileManager * manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:cache.cacheFileName isDirectory:nil]) {
            HBFileCacheData * data=[[HBFileCacheData alloc]init];
            data.cacheId=[[XHBDBHelper shareDBHelper] newIdforTable:[HBFileCacheData class]];
            data.filekey=[toKey md5];
            data.cacheFileName=cache.cacheFileName;
            [[XHBDBHelper shareDBHelper]insertToDB:data];
        }
        [[XHBDBHelper shareDBHelper] deleteToDB:cache];
    }
}

-(NSString*)filePathForKey:(NSString*)key
{
    HBFileCacheData * cache=[[XHBDBHelper shareDBHelper] searchSingle:[HBFileCacheData class] where:@{@"filekey":[key  md5]} orderBy:nil];
    if (cache) {
        return  cache.cacheFileName;
    }else{
        return nil;
    }
}

@end
