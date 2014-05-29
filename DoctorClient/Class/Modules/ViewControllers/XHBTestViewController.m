//
//  XHBTestViewController.m
//  DoctorClient
//
//  Created by weqia on 14-5-10.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTestViewController.h"
#import "XHBTalkViewController.h"
@interface XHBTestViewController ()

@end

@implementation XHBTestViewController

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
    //注册新消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newmessageAction) name:XHBTalkNewMenssageNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBTalkViewController * controller=(XHBTalkViewController*)[self viewControllerForName:@"XHBTalkViewController" Class:[XHBTalkViewController class]];
    //这里设置聊天页面的参数
    if (indexPath.row==0) {
        controller.loginJid=@"13000000000";
        controller.friendJid=@"13011111111";
        controller.host=@"115.29.165.247";
        controller.loginHeadUrl=@"http://ejt.s2.c2d.me/images/common/noavatar_large.png";
        controller.loginCname=@"wo";
        controller.friendName=@"3333";
    }
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=@"13011111111";
    return cell;
}

-(void)newmessageAction
{
    [self loadGroupData];
}

-(void)loadGroupData
{
    //获取消息分组信息，  offset , limit 用于分页
    [XHBTalkViewController getGrouptTalkData:@"13000000000" offset:0 limit:MAXFLOAT callback:^(NSArray *groups) {
        /**
         *  /// 返回已分组的消息 元素为XHBTalkGroupData
         */
        // [self.tableView reloadData];
    }];
}


@end
