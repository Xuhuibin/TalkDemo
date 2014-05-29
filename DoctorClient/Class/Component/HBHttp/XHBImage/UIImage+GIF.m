//
//  UIImage+GIF.m
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import "UIImage+GIF.h"

@implementation UIImage (GIF)
+(UIImage*)sd_imageWithData:(NSData*)data
{
    if ([data sd_isGIF]) {
        return [self sd_animatedGIFWithData:data];
    }else{
        return [UIImage imageWithData:data];
    }
}

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data
{
    if (!data)
    {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1)
    {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else
    {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++)
        {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
            duration += [[[frameProperties objectForKey:(__bridge NSString*)kCGImagePropertyGIFDictionary] objectForKey:(__bridge NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration)
        {
            duration = (1.0f/10.0f)*count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0f)
    {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data)
        {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data)
        {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data)
        {
            return [UIImage sd_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size
{
    if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero))
    {
        return self;
    }
    
    CGSize scaledSize = size;
	CGPoint thumbnailPoint = CGPointZero;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor :heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;
    
    if (widthFactor > heightFactor)
    {
        thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
    }
    
    NSMutableArray *scaledImages = [NSMutableArray array];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    for (UIImage *image in self.images)
    {
        [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [scaledImages addObject:newImage];
    }
    
    UIGraphicsEndImageContext();
	
	return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

+ (UIImage *)decodedImageWithImage:(UIImage *)image
{
    if (image.images)
    {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
	
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
	
    CGContextRelease(context);
	
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

+(UIImage*)SDScaledImageForKey:(NSString*)key image:(UIImage*)image
{
    if ([image.images count] > 0)
    {
        NSMutableArray *scaledImages = [NSMutableArray array];
        
        for (UIImage *tempImage in image.images)
        {
            [scaledImages addObject:[self SDScaledImageForKey:key image:tempImage]];
        }
        
        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];
    }
    else
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            CGFloat scale = 1.0;
            if (key.length >= 8)
            {
                // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
                NSRange range = [key rangeOfString:@"@2x." options:0 range:NSMakeRange(key.length - 8, 5)];
                if (range.location != NSNotFound)
                {
                    scale = 2.0;
                }
            }
            
            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            image = scaledImage;
        }
        return image;
    }
}

@end
