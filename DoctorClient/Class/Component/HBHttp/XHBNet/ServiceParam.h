//
//  ServiceParam.h
//  wq
//
//  Created by berwin on 13-7-8.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParam.h"

@interface ServiceParam : RequestParam

@property (nonatomic,strong)NSString *  mode;
-(ServiceParam*)initWithMode:(NSString*)paramitype;

@end
