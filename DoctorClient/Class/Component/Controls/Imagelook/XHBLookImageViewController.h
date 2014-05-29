//
//  XHBLookImageViewController.h
//  DoctorClient
//
//  Created by weqia on 14-5-4.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBBaseViewController.h"
#import "PagePhotosView.h"
@interface XHBLookImageViewController : XHBBaseViewController<PagePhotosDataSource>
@property(nonatomic,strong)NSArray * smallImages;
@property(nonatomic,strong)NSArray * bigUrls;
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic,strong,readonly)PagePhotosView * pageView;


@property(nonatomic,strong)id<UIViewControllerOperationDelegate>dismissImage;
@end
