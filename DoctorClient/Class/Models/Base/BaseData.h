//
//  BaseData.h
//  wq
//
//  Created by berwin on 13-6-17.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "Jastor.h"
#import "NSStrUtil.h"
#import "JSONKit.h"
#import "DataOperationDelegate.h"
#import "XHBDBHelper.h"
@interface BaseData : Jastor<DataOperationDelegate>
@property(nonatomic) BOOL local;

@end
