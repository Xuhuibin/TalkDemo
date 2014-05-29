//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PagePhotosView.h"
#import "UIColor+setting.h"
@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
@synthesize dataSource;
@synthesize imageViews;
@synthesize pageControl;

int lastPageIndex = 0;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource {
    if ((self = [super initWithFrame:frame])) {
		self.dataSource = _dataSource;
        // Initialization UIScrollView
		int pageControlHeight = 40;
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
		[self addSubview:scrollView];
		[self addSubview:pageControl];
		
		int kNumberOfPages = [dataSource numberOfPages];
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.imageViews = views;
		
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
        if (kNumberOfPages == 1) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages + 1, scrollView.frame.size.height);
        } else {
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
        }
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
        
        scrollView.bounces = NO;
		
		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage = 0;
		pageControl.backgroundColor = [UIColor clearColor];
		if(IOS_VERSION>=6)
        {
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithIntegerValue:CurrentPageIndicatorTintColor alpha:1]];
            [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        }
        if (kNumberOfPages<2) {
            pageControl.hidden=YES;
        }else{
            pageControl.hidden=NO;
        }
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
		
    }
    return self;
}


- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = [dataSource numberOfPages];
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // replace the placeholder if necessary
    UIView *view = [imageViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
        view = [dataSource imageAtIndex:page];
        if (view != nil) {
            [imageViews replaceObjectAtIndex:page withObject:view];
        }
    }
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (pageControl.currentPage!=page) {
        if (self.dataSource&&[self.dataSource  respondsToSelector:@selector(pageChange:)]) {
            [self.dataSource pageChange:pageControl.currentPage];
        }
    }
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
    
    int index = fabs(self->scrollView.contentOffset.x)/self.frame.size.width;
    if(lastPageIndex == index) {
        lastPageIndex++;
    } else{
        lastPageIndex = index;
    }
    if (lastPageIndex>index && index != 0){
        [dataSource endScroll];
    }
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

-(void)turnToPage:(NSUInteger)page
{
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
