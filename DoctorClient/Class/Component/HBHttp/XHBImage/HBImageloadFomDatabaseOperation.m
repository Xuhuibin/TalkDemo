//
//  HBImageloadFomDatabaseOperation.m
//  mailcore2
//
//  Created by weqia on 14-3-2.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "HBImageloadFomDatabaseOperation.h"
#import "NSOperationQueue+global.h"
#import "HBFileCache.h"
#import "UIImage+GIF.h"
@implementation HBImageloadFomDatabaseOperation

+(HBImageloadFomDatabaseOperation*)operationWithURL:(NSString*)url complete:(HBImageDownloaderCompletedBlock)completeBlock
{
    HBImageloadFomDatabaseOperation * operation=[[self alloc]initWithURL:url complete:completeBlock];
    [[NSOperationQueue dboprationQueue] addOperation:operation];
    return operation;
}


-(HBImageloadFomDatabaseOperation*)initWithURL:(NSString*)url
                                      complete:(HBImageDownloaderCompletedBlock)completeBlock
{
    self=[super init];
    if (self) {
        _url=url;
        _completeBlock=[completeBlock copy];
    }
    return self;
}

-(void)start
{
    if (self.isCancelled)
    {
        self.finished = YES;
        [self reset];
        return;
    }
    self.executing = YES;
    NSData * data=[[HBFileCache shareCache] getDataFromDisk:_url];
    if (data) {
        UIImage * image1=[UIImage sd_imageWithData:data];
        if (_completeBlock) {
            if (image1) {
                _completeBlock(image1,data,nil,YES,HBImageGetFromDisk);
            }else{
                _completeBlock(image1,data,nil,NO,HBImageGetFromNone);
            }
        }
    }else{
        if (_completeBlock) {
             _completeBlock(nil,nil,nil,NO,HBImageGetFromNone);
        }
    }
    [self done];
}

- (void)cancel
{
    if (!self.executing) {
        return;
    }
    if (self.isFinished) return;
    [super cancel];
    self.executing = NO;
    self.finished = YES;
    if (_completeBlock) {
        _completeBlock(nil,nil,nil,NO,HBImageGetFromNone);
    }
    [self reset];
}

- (void)done
{
    if (!self.executing) {
        return;
    }
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset
{
    
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent
{
    return YES;
}
@end
