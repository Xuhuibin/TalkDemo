//
//  PageHeadView.m
//  wq
//
//  Created by weqia on 13-8-1.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "PageHeadView.h"

@implementation PageHeadView

#pragma -mark 覆盖父类的方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isLoading=NO;
        
        indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(120, 23, 15, 15)];
        indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        indicator.hidesWhenStopped=YES;
        [self addSubview:indicator];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(140, 20, 60, 20)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor grayColor];
        label.text=@"正在刷新...";
        label.font=[UIFont systemFontOfSize:12];
        loadText=label;
        [self addSubview:label];
        label.hidden=YES;
        
        isLoading=NO;
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([newSuperview isKindOfClass:[UITableView class]]) {
        self.tableView=(UITableView*)newSuperview;
    }
}

#pragma -mark 接口方法
-(void) animmation
{
    [indicator startAnimating];
}

-(BOOL) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<-60&&!isLoading)
    {
        isLoading=YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        if(_target&&_beginAction&&[_target respondsToSelector:_beginAction]){
            [UIView animateWithDuration:0.2 animations:^{
                [indicator startAnimating];
                loadText.hidden=NO;
                self.tableView.contentInset=UIEdgeInsetsMake(60, 0, 0, 0);
            }];
            [_target performSelector:_beginAction withObject:self];
        }
        
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}
-(void) addBeginLoadAction:(SEL)action
{
    _beginAction=action;
}

-(void) addEndLoadAction:(SEL) action
{
    _endAction=action;
}
-(void)setTarget:(id)target
{
    _target=target;
}

-(void) loadFinish
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        isLoading=NO;
        [indicator stopAnimating];
        loadText.hidden=YES;
    }];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if(_target&&_endAction&&[_target respondsToSelector:_endAction])
        [_target performSelector:_endAction withObject:self];
#pragma clang diagnostic pop

}

@end
