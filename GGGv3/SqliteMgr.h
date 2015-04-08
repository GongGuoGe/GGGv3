//
//  Singleton.h
//  GGGv3
//
//  Created by ray on 15/4/5.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteMgr : NSObject
{
    sqlite3* database;
    NSString* databaseName;
}

+(SqliteMgr *)sharedInstanceMethod;

-(BOOL)openDB;
-(void)closeDB;

-(NSArray*)getAllSeeds;

@end
