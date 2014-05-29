//
//  UITableViewCellDelegate.h
//  wq8
//
//  Created by weqia on 13-12-30.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UITableViewCellDelegate <NSObject>
@optional
-(void)tableViewCell:(UITableViewCell*)tableViewCell buttonClickAction:(UIButton*)button;

-(void)tableViewCell:(UITableViewCell *)tableViewCell operationType:(const NSString*)type object:(id)object;

@end
