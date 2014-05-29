//
//  XHBImageUtil.m
//  DoctorClient
//
//  Created by weqia on 14-5-4.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBImageUtil.h"

@implementation XHBImageUtil
+(CGRect)frameForImageView:(CGSize)imageSize inRect:(CGRect)rect
{
    float imgScale=imageSize.height/imageSize.width;
    float viewScale=rect.size.height/rect.size.width;
    float width=imageSize.width,height=imageSize.height;
    if(imgScale<viewScale&&imageSize.width>rect.size.width){
        width=rect.size.width;
        height=width*imgScale;
        
    }else if(imgScale>=viewScale&&imageSize.height>rect.size.height){
        height=rect.size.height;
        width=height/imgScale;
    }
    float x=0,y=0;
    if (width<rect.size.width) {
        x=(rect.size.width-width)/2;
    }if(height<rect.size.height){
        y=(rect.size.height-height)/2;
    }
    CGRect frame=CGRectMake(x, y, width, height);
    return frame;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize size=image.size;
    if(size.height<newSize.height&&size.width<newSize.width)
        return image;
    float imgScale=0.0f;
    if(size.width>0)
        imgScale=size.height/size.width;
    float viewScale=0.0f;
    if(newSize.width>0)
        viewScale=newSize.height/newSize.width;
    float width=size.width,height=size.height;
    if(imgScale<viewScale&&size.width>newSize.width){
        width=newSize.width;
        height=newSize.width*imgScale;
    }else if(imgScale>=viewScale&&size.height>newSize.height){
        height=newSize.height;
        if(imgScale>0)
            width=height/imgScale;
    }
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
