//
//  XHBBaseViewController.m
//  webox
//
//  Created by weqia on 14-2-21.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBBaseViewController.h"

@interface XHBBaseViewController ()
{
    viewControllerCommunicationCallback _backActionCallback;
    viewControllerCommunicationCallback _updateActionCallback;
}
@end

@implementation XHBBaseViewController
@synthesize updateActionCallback=_updateActionCallback,backActionCallback=_backActionCallback;


#pragma -mark UIViewControllerCommunicationDelegate
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
-(void)initDataForView:(NSDictionary*)dic
{
}

-(void)initDataForView:(id)object forKey:(NSString*)key
{}

-(void)update
{}

-(void)update:(id)param
{}

-(void)loadDataFromServer:(void(^)(id object))complete
{
}

@end

@implementation UIViewController (Base)

-(UIViewController<UIViewControllerCommunicationDelegate>*)viewControllerForName:(NSString*)name Class:(Class)Class
{
    UIViewController<UIViewControllerCommunicationDelegate> * controller=(UIViewController<UIViewControllerCommunicationDelegate> *)[[Class alloc]initWithNibName:name bundle:[NSBundle mainBundle]];
    return controller;
}
-(void)registerTextFieldEditFinishActionGesture
{
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldEditFinishAction)];
    [self.view addGestureRecognizer:tap];
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonAction
{
}
-(void)textFieldEditFinishAction
{}
@end