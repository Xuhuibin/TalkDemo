//
//  LookBigImageTool.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "LookBigImageTool.h"
#import "HBFileCache.h"
#import "XHBImageUtil.h"
#import "XHBLookImageViewController.h"
@implementation LookBigImageTool

-(void)lookBigImage:(UIImageView*)imageView smallImageViews:(NSArray*)smallImageViews bigImageUrls:(NSArray*)bigImageUrls viewController:(UIViewController*)viewController
{
    if (smallImageViews.count==0||bigImageUrls.count==0||imageView==nil||smallImageViews.count!=bigImageUrls.count||viewController==nil) {
        return;
    }
    NSInteger index=-1;
    index=[smallImageViews indexOfObject:imageView];
    if (index<0||index>=bigImageUrls.count) {
        return;
    }
    NSString * url=[bigImageUrls objectAtIndex:index];
    _currentImageView=imageView;
    _smallImages=smallImageViews;
    _bigUrls=bigImageUrls;
    _viewController=viewController;
    
    _backView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor=[UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    
    CGRect frame=[imageView.superview convertRect:imageView.frame toView:_backView];
    UIImageView * tempImageView=[[UIImageView alloc]initWithFrame:frame];
    tempImageView.image=imageView.image;
    tempImageView.contentMode=UIViewContentModeScaleAspectFill;
    tempImageView.clipsToBounds=YES;
    [_backView addSubview:tempImageView];
    _tempImageView=tempImageView;
    
    CGRect toFrame;
    UIImage * image=[[HBFileCache shareCache]getImageFromCache:url];
    if (image) {
        toFrame=[XHBImageUtil frameForImageView:image.size inRect:_backView.bounds];
    }else{
        toFrame=[XHBImageUtil frameForImageView:imageView.image.size inRect:_backView.bounds];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backView.backgroundColor=[UIColor blackColor];
        tempImageView.frame=toFrame;
    } completion:^(BOOL finished) {
        _backView.hidden=YES;
        XHBLookImageViewController * controller=(XHBLookImageViewController *)[viewController viewControllerForName:@"XHBLookImageViewController" Class:[XHBLookImageViewController class]];
        controller.smallImages=smallImageViews;
        controller.bigUrls=bigImageUrls;
        controller.currentIndex=index;
        controller.dismissImage=self;
        [viewController presentViewController:controller animated:NO completion:nil];
    }];
}
-(void)dismissBigImage:(UIImageView*)imageView viewController:(UIViewController*)viewController index:(NSUInteger)index
{
    _backView.hidden=NO;
    _tempImageView.frame=imageView.frame;
    _tempImageView.image=imageView.image;
    
    UIImageView * toImageView=[_smallImages objectAtIndex:index];
    CGRect toframe=[toImageView.superview convertRect:toImageView.frame toView:_backView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backView.backgroundColor=[UIColor clearColor];
        _tempImageView.frame=toframe;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
@end
