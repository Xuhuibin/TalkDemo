//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"
#define CurrentPageIndicatorTintColor 0x86c9ff
@interface PagePhotosView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}
@property(nonatomic,readonly)UIPageControl *pageControl;
@property id<PagePhotosDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *imageViews;

- (IBAction)changePage:(id)sender;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)dataSource;

-(void)turnToPage:(NSUInteger)page;

@end
