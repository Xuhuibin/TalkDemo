//
//  SelectImageTool.h
//  ShareCar
//
//  Created by weqia on 14-4-29.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewControllerOperationDelegate.h"
@interface SelectImageTool : NSObject<UIViewControllerOperationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic,strong,readonly) void(^callback)(UIImage * image);
@property(nonatomic,weak,readonly)UIViewController* controller;
@property(nonatomic,readonly)BOOL edit;
@end
