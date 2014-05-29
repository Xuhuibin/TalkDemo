//
//  HBImageDownloadOperation.m
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "HBImageDownloadOperation.h"
#import "NSOperationQueue+global.h"
#import "NetworkUtil.h"
#import <ImageIO/ImageIO.h>
@implementation HBImageDownloadOperation
{
    size_t width, height;
    BOOL responseFromCached;
}

- (id)initWithRequest:(NSURLRequest *)request  progress:(HBImageDownloaderProgressBlock)progressBlock completed:(HBImageDownloaderCompletedBlock)completedBlock cancelled:(void (^)())cancelBlock
{
    if ((self = [super init]))
    {
        _request = request;
        _progressBlock = [progressBlock copy];
        _completeBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
        responseFromCached = YES; // Initially wrong until `connection:willCacheResponse:` is called or not called
    }
    return self;
}

- (void)start
{
    if (self.isCancelled)
    {
        self.finished = YES;
        [self reset];
        return;
    }
    
    self.executing = YES;
    self.connection = [NSURLConnection.alloc initWithRequest:self.request delegate:self startImmediately:NO];
    
    [self.connection start];
    
    if (self.connection)
    {
        if (self.progressBlock)
        {
            self.progressBlock(0, -1);
        }
        // Make sure to run the runloop in our background thread so it can process downloaded data
        CFRunLoopRun();
    }
    else
    {
        if (_completeBlock)
        {
            _completeBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Connection can't be initialized"}], YES,HBImageGetFromWeb);
        }
    }
}

- (void)cancel
{
    if (self.isFinished) return;
    if (self.cancelBlock) self.cancelBlock();
    [super cancel];
    if (self.connection)
    {
        [self.connection cancel];
        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset
{
    self.cancelBlock = nil;
    _completeBlock = nil;
    _progressBlock= nil;
    self.connection = nil;
    self.imageData = nil;
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

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
        NSUInteger expected = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        if (self.progressBlock)
        {
            self.progressBlock(0, expected);
        }
        
        self.imageData = [NSMutableData.alloc initWithCapacity:expected];
    }
    else
    {
        [self.connection cancel];
        if (_completeBlock)
        {
            _completeBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil], YES,HBImageGetFromWeb);
        }
        
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    
    const NSUInteger totalSize = self.imageData.length;
    
    // Update the data source, we must pass ALL the data, not just the new bytes
    CGImageSourceRef imageSource = CGImageSourceCreateIncremental(NULL);
    CGImageSourceUpdateData(imageSource, (__bridge  CFDataRef)self.imageData, totalSize == self.expectedSize);
    
    if (width + height == 0)
    {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties)
        {
            CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
            if (val) CFNumberGetValue((CFNumberRef)val, kCFNumberLongType, &height);
            val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
            if (val) CFNumberGetValue((CFNumberRef)val, kCFNumberLongType, &width);
            CFRelease(properties);
        }
    }
    
    if (width + height > 0 && totalSize < self.expectedSize)
    {
        // Create the image
        CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        
#ifdef TARGET_OS_IPHONE
        // Workaround for iOS anamorphic image
        if (partialImageRef)
        {
            const size_t partialHeight = CGImageGetHeight(partialImageRef);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
            CGColorSpaceRelease(colorSpace);
            if (bmContext)
            {
                CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                CGImageRelease(partialImageRef);
                partialImageRef = CGBitmapContextCreateImage(bmContext);
                CGContextRelease(bmContext);
            }
            else
            {
                CGImageRelease(partialImageRef);
                partialImageRef = nil;
            }
        }
#endif
        
        if (partialImageRef)
        {
            UIImage *image = [UIImage imageWithCGImage:partialImageRef];
            UIImage *scaledImage = [self scaledImageForKey:self.request.URL.absoluteString image:image];
            image = [UIImage decodedImageWithImage:scaledImage];
            CGImageRelease(partialImageRef);
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (_completeBlock)
                               {
                                   _completeBlock(image, nil, nil, NO,HBImageGetFromWeb);
                               }
                           });
        }
    }
    CFRelease(imageSource);
    if (self.progressBlock)
    {
        self.progressBlock(self.imageData.length, self.expectedSize);
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.connection = nil;
    HBImageDownloaderCompletedBlock completionBlock = _completeBlock;
    
    if (completionBlock)
    {
        UIImage *image = [UIImage sd_imageWithData:_imageData];
        
        image = [self scaledImageForKey:self.request.URL.absoluteString image:image];
        
        if (!image.images) // Do not force decod animated GIFs
        {
            image = [UIImage decodedImageWithImage:image];
        }
        
        if (CGSizeEqualToSize(image.size, CGSizeZero))
        {
            completionBlock(nil, nil, [NSError errorWithDomain:@"HBImageErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Downloaded image has 0 pixels"}], YES,HBImageGetFromNone);
        }
        else
        {
            completionBlock(image, self.imageData, nil, YES,HBImageGetFromWeb);
        }
        self.completionBlock = nil;
        [self done];
    }
    else
    {
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    if (_completeBlock)
    {
        _completeBlock(nil, nil, error, YES,HBImageGetFromNone);
    }
    [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    responseFromCached = NO; // If this method is called, it means the response wasn't read from cache
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData)
    {
        // Prevents caching of responses
        return nil;
    }
    else
    {
        return cachedResponse;
    }
}
- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image
{
    return [UIImage SDScaledImageForKey:key image:image];
}

@end
