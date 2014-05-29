//
//  XHBTalkTextTableViewCell.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "XHBTalkTextTableViewCell.h"

@implementation XHBTalkTextTableViewCell

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
    self.content.userInteractionEnabled=YES;
    self.content.font=[UIFont systemFontOfSize:15];
    
}
-(void)setDelegate:(id<XHBTalkTableViewCellDelegate,HBCoreLabelDelegate>)delegate
{
    _content.delegate=delegate;
    [super setDelegate:delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadContent:(XHBTalkData*)data
{
    [super loadContent:data];
    [self addText];
}

-(void)addText
{
    [self.talk getMatch:^(MatchParser *parser, id data) {
        _content.match=parser;
        float width=parser.miniWidth;
        if (width<30) {
            width=30;
        }
        CGRect frame=self.backView.frame;
        frame.size.width=width+30;
        self.backView.frame=frame;
        [self setNeedsLayout];
    } data:self];
}


@end
