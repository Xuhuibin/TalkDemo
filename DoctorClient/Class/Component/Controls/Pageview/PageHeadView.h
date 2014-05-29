//
//  PageHeadView.h
//  wq
//
//  Created by weqia on 13-8-1.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PageHeadView : UIView
{
    UIActivityIndicatorView * indicator;
    UILabel * loadText;
    
    BOOL isLoading;
    
    id _target;
    SEL _beginAction;
    SEL _endAction;
}
@property(nonatomic,strong)UITableView * tableView;
-(void)animmation;

-(BOOL) scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

-(void) loadFinish;

-(void) addBeginLoadAction:(SEL)action;

-(void) addEndLoadAction:(SEL) action;

-(void)setTarget:(id)target;

@end



