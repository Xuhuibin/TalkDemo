//
//  XHBAppDelegate.m
//  DoctorClient
//
//  Created by weqia on 14-4-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBAppDelegate.h"
#import "XiaoMaClient.h"
#import "XHBTalkData.h"
#import "NetworkUtil.h"
#import "XHBTestViewController.h"
#import "XHBTalkTransfersCenter.h"
@implementation XHBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [XiaoMaClient
     registeriOSClient:@"AndriodCientAppKey"
     appSecret:@"AndriodCientSecret"
     apiUrl:@"http://ejt.s2.c2d.me/api.ashx"];
    [[NetworkUtil shareUtil]startNotification];
    [[XHBDBHelper shareDBHelper] updateToDB:[XHBTalkData class] set:[NSString stringWithFormat:@"status=3"] where:[NSString stringWithFormat:@"status=1"]];
    [[XHBTalkTransfersCenter shareCenter]  connectToServer:@"13000000000@115.29.165.247" password:@"123" host:@"115.29.165.247"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[XHBDBHelper shareDBHelper] createTableWithModelClass:[XHBTalkData class]];
    XHBTestViewController * controller=[[XHBTestViewController alloc]initWithNibName:@"XHBTestViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self.window setRootViewController:nav];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
