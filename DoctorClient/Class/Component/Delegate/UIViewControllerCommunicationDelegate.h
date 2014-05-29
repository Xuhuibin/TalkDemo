//
//  UIViewControllerCommunicationDelegate.h
//  wq8
//
//  Created by weqia on 14-2-18.
//  Copyright (c) 2014年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^viewControllerCommunicationCallback)(id data);

@protocol UIViewControllerCommunicationDelegate <NSObject>
@optional
@property(nonatomic,strong) viewControllerCommunicationCallback backActionCallback;
@property(nonatomic,strong) viewControllerCommunicationCallback updateActionCallback;


-(void)initDataForView:(NSDictionary*)dic;

-(void)initDataForView:(id)object forKey:(NSString*)key;

-(void)update;

-(void)update:(id)param;

@end
