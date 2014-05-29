//
//  
//  ChatAttachmentsResponse.m
//  AutomaticCoder
//
//  Created by Jim on 2014-5-12.
//  Copyright (c) 2014年 com.Jim. All rights reserved.
//

#import "ChatAttachmentsResponse.h"

@implementation ChatAttachmentsResponse


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.Obj  = [[json objectForKey:@"Obj"] isKindOfClass:[NSNull class]] ? nil : [[ChatAttachmentsResponseObj alloc] initWithJson:[json objectForKey:@"Obj"]];
            self=[super initWithJson:json];
 
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Obj forKey:@"Obj"];
[super encodeWithCoder:aCoder];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.Obj = [aDecoder decodeObjectForKey:@"Obj"];
        self=[super initWithCoder:aDecoder];
 
    }
    return self;
}

@end
