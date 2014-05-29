//
//  XHBBaseTableViewController.m
//  webox
//
//  Created by weqia on 14-2-22.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBBaseTableViewController.h"

@interface XHBBaseTableViewController ()
{
    viewControllerCommunicationCallback _backActionCallback;
    viewControllerCommunicationCallback _updateActionCallback;
}

@end

@implementation XHBBaseTableViewController
@synthesize backActionCallback=_backActionCallback,updateActionCallback=_updateActionCallback;
- (void)viewDidLoad
{
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    
    UIViewController * controller=[self.navigationController.viewControllers objectAtIndex:0];
    if (controller!=self) {
        UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem=item;
    }
	// Do any additional setup after loading the view.
}
#pragma -mark 接口

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonAction
{}
-(void)loadDataFromServer:(void(^)(id object))complete
{}
#pragma -mark UIViewControllerCommunicationDelegate
-(void)initDataForView:(NSDictionary*)dic
{
}

-(void)initDataForView:(id)object forKey:(NSString*)key
{}

-(void)update
{}

-(void)update:(id)param
{}


@end
