//
//  XHBTalkTableViewCell.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkTableViewCell.h"
#import "NSTimeUtil.h"
@implementation XHBTalkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.talk.fromSelf) {
        CGRect frame=self.backView.frame;
        frame.origin.x=270-frame.size.width;
        self.backView.frame=frame;
        self.indicator.frame=CGRectMake(self.backView.frame.origin.x-30, self.backView.frame.origin.y+(self.backView.frame.size.height-20)/2, 20, 20);
        self.btnFailed.frame=CGRectMake(self.backView.frame.origin.x-30, self.backView.frame.origin.y+(self.backView.frame.size.height-20)/2, 20, 20);
        self.receiptsView.frame=CGRectMake(self.backView.frame.origin.x-40, self.backView.frame.origin.y+(self.backView.frame.size.height-18)/2, 30, 18);
    }
}

#pragma -mark 接口
+(instancetype)tableViewCellFor:(XHBTalkData*)data tableView:(UITableView*)tableView controller:(UIViewController*)controller
{
    XHBTalkTableViewCell * cell=nil;
    if (data.type==XHBTalkContentTypeText) {
        if (!data.fromSelf) {
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkTextLeftTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkTextLeftTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
            
        }else{
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkTextRightTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkTextRightTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
        }
    }else if(data.type==XHBTalkContentTypeImage){
        if (!data.fromSelf) {
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkImageLeftTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkImageLeftTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
        }else{
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkImageRightTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkImageRightTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
        }
    }else if(data.type==XHBTalkContentTypeSound){
        if (!data.fromSelf) {
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkSoundLeftTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkSoundLeftTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
        }else{
            cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"XHBTalkSoundRightTableViewCell+%d",data.showTime]];
            if (cell==nil) {
                NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"XHBTalkSoundRightTableViewCell" owner:controller options:nil];
                if (data.showTime) {
                    cell=[array objectAtIndex:0];
                }else{
                    cell=[array lastObject];
                }
            }
        }
    }
    return cell;
}

+(float)heightForData:(XHBTalkData*)data
{
    float height=0;
    if (data.type==XHBTalkContentTypeText) {
        if (data.showTime) {
            height+=25;
        }
        if (data.height<20) {
            height+=20;
        }else{
            height+=data.height;
        }
        height+=30;
    }else if(data.type==XHBTalkContentTypeImage){
        if (data.showTime) {
            height+=25;
        }
        height=height+IMAGE_MAX_HEIGHT+30;
    }else if(data.type==XHBTalkContentTypeSound){
        if (data.showTime) {
            height+=25;
        }
        height+=50;
    }
    return height;
}

-(void)loadContent:(XHBTalkData*)data
{
    self.talk=data;
    if (self.talk.fromSelf) {
        if (self.talk.status==XHBTalkStatusIsUploading) {
            [self.indicator startAnimating];
            self.btnFailed.hidden=YES;
            self.receiptsView.hidden=YES;
        }else if(self.talk.status==XHBTalkStatusUploadFailed){
            [self.indicator stopAnimating];
            self.btnFailed.hidden=NO;
            self.receiptsView.hidden=YES;
        }else{
            self.btnFailed.hidden=YES;
            if (self.talk.receipts==XHBTalkReachStatuReach) {
                self.receiptsView.hidden=NO;
            }else{
                self.receiptsView.hidden=YES;
            }
        }
    }
    if (self.talk.showTime) {
        self.time.text=[NSTimeUtil  getMDStr:self.talk.time.longLongValue];
    }
    [self.mlogo setImageWithURL:[NSURL URLWithString:self.talk.friendHeadUrl] placeholderImage:nil];
}

#pragma -mark 事件响应
-(IBAction)uploadFailedAction:(id)sender
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重发",@"删除", nil];
    action.tag=190;
    [action showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self upLoad];
    }else if(buttonIndex==1){
        [self deleteMessage];
    }
}
-(void)upLoad
{
    self.talk.status=XHBTalkStatusIsUploading;
    [self.talk formatInsertToDB];
    [self.tableView reloadData];
    [[XHBTalkTransfersCenter shareCenter] sendMessage:self.talk complete:^(BOOL success) {
        [self.tableView reloadData];
    }];
}
-(void)deleteMessage
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(talkTableCell:deleteAction:)]){
        [self.delegate talkTableCell:self deleteAction:self.talk];
    }
}


@end
