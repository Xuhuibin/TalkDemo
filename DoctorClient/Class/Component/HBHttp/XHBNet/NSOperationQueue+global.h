//
//  NSOperationQueue+global.h
//  wq8
//
//  Created by weqia on 13-11-26.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (global)
+(id)uploadQueue;
+(id)downLoadQueue;
+(id)operationQueue;
+(id)dboprationQueue;
+(id)otherQueue;
@end
