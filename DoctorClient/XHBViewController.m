//
//  XHBViewController.m
//  DoctorClient
//
//  Created by weqia on 14-4-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBViewController.h"

@interface XHBViewController ()

@end

@implementation XHBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray * array=[NSMutableArray array];
    for (int i=0; i<10000; i++) {
        [array addObject:[NSString stringWithFormat:@"%d  ",i]];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
