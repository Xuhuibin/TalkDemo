//
//  PagePhotosDataSource.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PagePhotosDataSource<NSObject>

// 有多少页
//
- (int)numberOfPages;

// 每页的图片
//
- (UIView *)imageAtIndex:(int)index;

- (void)endScroll;

-(void)pageChange:(NSUInteger)currentPage;

@end
