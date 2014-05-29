//
//  XHBBaseTableViewController.h
//  webox
//
//  Created by weqia on 14-2-22.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBBaseViewController.h"
@interface XHBBaseTableViewController : UITableViewController<UIViewControllerCommunicationDelegate>

-(void)backAction;

-(void)rightButtonAction;
-(void)loadDataFromServer:(void(^)(id object))complete;
@end
