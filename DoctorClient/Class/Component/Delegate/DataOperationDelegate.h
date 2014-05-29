//
//  DataOperationDelegate.h
//  wq8
//
//  Created by weqia on 14-1-16.
//  Copyright (c) 2014年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataOperationDelegate <NSObject>
@optional
+(id<DataOperationDelegate>)dataFromDbForKey:(NSString*)key;
+(id<DataOperationDelegate>)dataFromDb:(NSString*)where;
-(void)formatInsertToDB;
-(void)formatInsertToDB:(void(^)(BOOL success))callback;
-(void)formatUpdateToDb;
-(void)formatUpdateToDb:(void(^)(BOOL success))callback;
-(void)updateData:(NSString*)name;
-(void)copyData:(id)data;
-(void)initData;
@end
