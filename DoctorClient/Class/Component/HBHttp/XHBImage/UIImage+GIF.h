//
//  UIImage+GIF.h
//  mailcore2
//
//  Created by weqia on 14-3-1.
//  Copyright (c) 2014年 MailCore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+GIF.h"
#import <ImageIO/ImageIO.h>
@interface UIImage (GIF)
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

+(UIImage*)sd_imageWithData:(NSData*)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

+ (UIImage *)decodedImageWithImage:(UIImage *)image;

+(UIImage*)SDScaledImageForKey:(NSString*)key image:(UIImage*)image;
@end
