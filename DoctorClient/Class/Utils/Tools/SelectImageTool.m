//
//  SelectImageTool.m
//  ShareCar
//
//  Created by weqia on 14-4-29.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "SelectImageTool.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import "XHBImageUtil.h"
@implementation SelectImageTool
-(void)selectImage:(void(^)(UIImage * image))callback viewController:(UIViewController*)viewController edit:(BOOL)edit
{
    _callback=callback;
    _controller=viewController;
    _edit=edit;
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"选取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册中选取", nil];
    [action showInView:viewController.view];
}

-(void)selectImage:(void(^)(UIImage * image))callback viewController:(UIViewController*)viewController sourceType:(UIImagePickerControllerSourceType)sourceType
{
    _callback=callback;
    _controller=viewController;
    UIImagePickerController *picvView = [[UIImagePickerController alloc] init];
    [picvView setDelegate:self];
    picvView.sourceType = sourceType;
    picvView.allowsEditing=_edit;
    [self.controller presentViewController:picvView animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *picvView = [[UIImagePickerController alloc] init];
        [picvView setDelegate:self];
        picvView.sourceType = UIImagePickerControllerSourceTypeCamera;
        picvView.allowsEditing=_edit;
        [self.controller presentViewController:picvView animated:YES completion:nil];
    }else if(buttonIndex==1){
        UIImagePickerController *picvView = [[UIImagePickerController alloc] init];
        [picvView setDelegate:self];
        picvView.allowsEditing=_edit;
        picvView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.controller presentViewController:picvView animated:YES completion:nil];
    }else{
        if (_callback) {
            _callback(nil);
        }
    }
}
#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    UIImage * image=nil;
    if (_edit) {
        image=[info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    UIImage * image1=[info objectForKey:UIImagePickerControllerOriginalImage];
    float imageScale=image1.size.height/image1.size.width;
    CGRect bounds=[UIScreen mainScreen].bounds;
    float viewScale=bounds.size.height/bounds.size.width;
    if (imageScale>=viewScale) {
        image1=[XHBImageUtil imageWithImageSimple:image1 scaledToSize:CGSizeMake(640, 640*imageScale)];
    }else{
        image1=[XHBImageUtil imageWithImageSimple:image1 scaledToSize:CGSizeMake(bounds.size.height*2/imageScale, bounds.size.height*2)];
    }
    if (_callback) {
        _callback(image1);
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (_callback) {
        _callback(nil);
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}

@end
