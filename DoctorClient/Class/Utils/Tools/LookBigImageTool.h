//
//  LookBigImageTool.h
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewControllerOperationDelegate.h"
@interface LookBigImageTool : NSObject<UIViewControllerOperationDelegate>
@property(nonatomic,strong,readonly)UIViewController * viewController;
@property(nonatomic,strong,readonly)NSArray * smallImages;
@property(nonatomic,strong,readonly)NSArray * bigUrls;
@property(nonatomic,strong,readonly)UIImageView * currentImageView;
@property(nonatomic,strong,readonly)UIImageView * tempImageView;
@property(nonatomic,strong,readonly)UIView * backView;
@end
