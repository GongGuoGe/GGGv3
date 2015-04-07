//
//  Singleton.m
//  GGGv3
//
//  Created by ray on 15/4/5.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "SqliteMgr.h"


static SqliteMgr * sharedInstance = nil;

@implementation SqliteMgr

//获取单例
+(SqliteMgr *)sharedInstanceMethod
{
    @synchronized(self) {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

//唯一一次alloc单例，之后均返回nil
+ (id)allocWithZone:(NSZone *)zone
{
    id instance;
    @synchronized(self) {
        if (sharedInstance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end