//
//  MatchParserData.h
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "BaseData.h"
#import "MatchParser.h"
#import "UIColor+setting.h"


@interface MatchParserData : BaseData<MatchParserDelegate>
{
    __weak MatchParser * _match;
}
@property(nonatomic)float width;
@property(nonatomic)float height;
@property(nonatomic,strong)NSString * content;
+(NSCache*)shareCache;
@end
