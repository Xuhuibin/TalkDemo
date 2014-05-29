//
//  UITableView+Scroll.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "UITableView+Scroll.h"

@implementation UITableView (Scroll)
-(void)scrollToBottom{
    [self scrollToBottom:YES];
}
-(void)scrollToBottom:(BOOL)animation
{
    NSInteger section=1;
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        section=[self.dataSource numberOfSectionsInTableView:self];
    }
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSInteger row=[self.dataSource tableView:self numberOfRowsInSection:section-1];
        if (row>0||section>1) {
            NSIndexPath * index=[NSIndexPath indexPathForRow:row-1 inSection:section-1];
            [self scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animation];
        }
    }
}

@end
