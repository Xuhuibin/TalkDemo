//
//  HBFileCacheData.h
//  webox
//
//  Created by weqia on 14-2-25.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "BaseData.h"
@interface HBFileCacheData : BaseData
@property (nonatomic,strong) NSString * cacheFileName;
@property (nonatomic,strong) NSString * filekey;
@property (nonatomic)int cacheId;
@end
