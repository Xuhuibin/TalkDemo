//
//  XHBLookImageViewController.m
//  DoctorClient
//
//  Created by weqia on 14-5-4.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBLookImageViewController.h"
#import "HBImageScroller.h"
@interface XHBLookImageViewController ()

@end

@implementation XHBLookImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.smallImages.count!=self.bigUrls.count||self.smallImages.count==0||self.bigUrls.count==0) {
        return;
    }
    if (self.currentIndex>=self.bigUrls.count) {
        return;
    }
    _pageView=[[PagePhotosView alloc]initWithFrame:self.view.bounds withDataSource:self];
    [self.view addSubview:_pageView];
    self.view.backgroundColor=[UIColor blackColor];
    [_pageView turnToPage:self.currentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (int)numberOfPages
{
    return (int)self.bigUrls.count;
}
// 每页的图片
//
- (UIView *)imageAtIndex:(int)index
{
    HBImageScroller * scroll=[[HBImageScroller alloc]initWithFrame:CGRectMake(0,0 , self.view.bounds.size.width,self.view.bounds.size.height)];
    UIImage *image=nil;
    if(index<[self.smallImages count])
        image=[self.smallImages objectAtIndex:index];
    [scroll setImageWithURL:[self.bigUrls objectAtIndex:index] andSmallImage:image];
    scroll.target=self;
    scroll.tapOnceAction=@selector(dismissBigImage);
    return scroll;
}
- (void)endScroll
{}

-(void)pageChange:(NSUInteger)currentPage
{
    HBImageScroller * scollView=[_pageView.imageViews objectAtIndex:currentPage];
    [scollView reset];
}

#pragma -mark  事件响应
-(void)dismissBigImage
{
    [self dismissViewControllerAnimated:NO completion:^{
        NSUInteger index=_pageView.pageControl.currentPage;
        HBImageScroller * scollView=[_pageView.imageViews objectAtIndex:index];
        if (self.dismissImage&&[self.dismissImage respondsToSelector:@selector(dismissBigImage:viewController:index:)]) {
            [self.dismissImage dismissBigImage:scollView.imageView viewController:self index:index];
        }
    }];
}


@end
