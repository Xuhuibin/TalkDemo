//
//  BrowseViewController.h
//  wq8
//
//  Created by weqia on 13-10-29.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBBaseViewController.h"
@interface BrowseViewController : XHBBaseViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView * _webView;
    IBOutlet UIToolbar * _toolBar;
    IBOutlet UIBarButtonItem * _back;
    IBOutlet UIBarButtonItem * _forword;
    IBOutlet UIBarButtonItem * _refresh;
}
@property(nonatomic,strong) NSString * url;
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, strong) NSString *labelTitle;
@end
