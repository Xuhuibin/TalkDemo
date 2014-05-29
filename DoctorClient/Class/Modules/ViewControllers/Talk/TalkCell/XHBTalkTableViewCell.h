//
//  XHBTalkTableViewCell.h
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBTalkData.h"
#import "UIImageView+Cache.h"
#import "HBCoreLabel.h"
#import "XHBTalkTransfersCenter.h"
@class XHBTalkTableViewCell;
@class XHBTalkData;
@protocol XHBTalkTableViewCellDelegate <NSObject>

@optional
-(void)talkTableViewCell:(XHBTalkTableViewCell*)cell lookImage:(UIImageView*)imageView;
-(void)talkTableCell:(XHBTalkTableViewCell *)cell palySoundAction:(XHBTalkData *)data readyCallback:(void(^)(BOOL ready))callback;

-(void)talkTableCell:(XHBTalkTableViewCell *)cell stopPalySoundAction:(XHBTalkData *)data;

-(void)talkTableCell:(XHBTalkTableViewCell*)cell  deleteAction:(XHBTalkData*)data;

@end


@interface XHBTalkTableViewCell : UITableViewCell<UIActionSheetDelegate>
@property(nonatomic,weak)IBOutlet UIImageView * mlogo;
@property(nonatomic,weak)IBOutlet UILabel * time;
@property(nonatomic,weak)IBOutlet UIView * backView;

@property(nonatomic,weak)IBOutlet UIActivityIndicatorView * indicator;
@property(nonatomic,weak)IBOutlet UIButton * btnFailed;

@property(nonatomic,weak)IBOutlet UILabel * receipts;
@property(nonatomic,weak)IBOutlet UIView * receiptsView;

@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,weak)id<XHBTalkTableViewCellDelegate,HBCoreLabelDelegate>delegate;

@property(nonatomic,strong)XHBTalkData * talk;
+(instancetype)tableViewCellFor:(XHBTalkData*)data tableView:(UITableView*)tableView controller:(UIViewController*)controller;
+(float)heightForData:(XHBTalkData*)data;
-(void)loadContent:(XHBTalkData*)data;

-(void)upLoad;


@end
