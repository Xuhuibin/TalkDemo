//
//  UIViewControllerOperationDelegate.h
//  DoctorClient
//
//  Created by weqia on 14-4-27.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewControllerOperationDelegate <NSObject>
@optional

// 图片选取器中选取图片或拍照
-(void)selectImage:(void(^)(UIImage * image))callback viewController:(UIViewController*)viewController edit:(BOOL)edit;

// 图片选取器中选取图片或拍照
-(void)selectImage:(void(^)(UIImage * image))callback viewController:(UIViewController*)viewController sourceType:(UIImagePickerControllerSourceType)sourceType;

// 选取其中选取视频、录制视频
-(void)selectVedio:(void(^)(NSString*filePath))callback viewController:(UIViewController*)viewController;

// 文件界面选取文件
-(void)selectFile:(void(^)(id file))callback viewController:(UIViewController*)viewController;

//地图中选取位置
-(void)selectPlace:(void(^)(id place))callback viewController:(UIViewController*)viewController;

// 查看图片
-(void)lookBigImage:(UIImageView*)imageView smallImageViews:(NSArray*)smallImageViews bigImageUrls:(NSArray*)bigImageUrls viewController:(UIViewController*)viewController;

-(void)dismissBigImage:(UIImageView*)imageView viewController:(UIViewController*)viewController index:(NSUInteger)index;


//搜索
-(void)search:(void(^)(id object))callback viewController:(UIViewController*)viewController searchBar:(UISearchBar*)searchBar extra:(id)extra;




@end