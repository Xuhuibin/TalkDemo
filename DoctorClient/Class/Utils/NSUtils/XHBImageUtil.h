//
//  XHBImageUtil.h
//  DoctorClient
//
//  Created by weqia on 14-5-4.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBImageUtil : NSObject
+(CGRect)frameForImageView:(CGSize)imageSize inRect:(CGRect)rect;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
