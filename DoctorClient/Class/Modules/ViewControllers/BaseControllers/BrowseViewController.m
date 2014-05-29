//
//  BrowseViewController.m
//  wq8
//
//  Created by weqia on 13-10-29.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "BrowseViewController.h"
@interface BrowseViewController ()
//@property (nonatomic, strong) UILabel * label;

@end

@implementation BrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView * view=[self.navigationController.navigationBar viewWithTag:199];
    if(view)
        [view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_toolBar  setBackgroundImage:[UIImage imageNamed:@"ToolViewBkg_Black@2x"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view.
    _webView.delegate=self;
    _webView.scalesPageToFit=YES;
    _webView.multipleTouchEnabled = YES;
    if([NSStrUtil notEmptyOrNull:self.url]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        });
    } else if (_fileUrl != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:_fileUrl];
            [_webView loadRequest:request];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 事件响应方法


#pragma -mark 回调方法

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    if(webView.canGoBack){
        [_back setEnabled:YES];
    }else{
        [_back setEnabled:NO];
    }
    if(webView.canGoForward){
        [_forword setEnabled:YES];
    }else{
        [_forword setEnabled:NO];
    }
    [_refresh setEnabled:YES];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIView * view=[self.navigationController.navigationBar viewWithTag:199];
    if(view){
        [view removeFromSuperview];
    }
    NSString * string= [webView  stringByEvaluatingJavaScriptFromString:@"document.title"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 180, 44)];
    if ([NSStrUtil notEmptyOrNull:string]) {
        label.text=string;
    } else if ([NSStrUtil notEmptyOrNull:_labelTitle]) {
        label.text = _labelTitle;
    }
    
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.tag=199;
    label.font=[UIFont systemFontOfSize:20];
    [self.navigationController.navigationBar addSubview:label];
    
    if(webView.canGoBack){
        [_back setEnabled:YES];
    }else{
        [_back setEnabled:NO];
    }
    if(webView.canGoForward){
        [_forword setEnabled:YES];
    }else{
        [_forword setEnabled:NO];
    }
    [_refresh setEnabled:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_refresh setEnabled:NO];
}

@end
