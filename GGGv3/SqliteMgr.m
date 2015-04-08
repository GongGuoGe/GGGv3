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

-(BOOL)openDB
{
    NSArray *arrs= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //创建数据库，如果数据库存在就直接打开，不存在就创建打开
    NSString *path=[arrs lastObject] ;
    NSString *documentpath=  [path stringByAppendingPathComponent:@"gggv3.db"];
    NSLog(@"Open DB at path: %@", documentpath);
    int reslut= sqlite3_open([documentpath UTF8String], &database);
    if(reslut==SQLITE_OK){
        NSLog(@"DB Open successfully~");
        
        if ([self checkSeedsTable] == FALSE)
        {
            NSLog(@"Can't create table: t_Seeds");
            return FALSE;
        }
        return TRUE;
    }
    NSLog(@"DB Open failed!");
    return FALSE;
}

-(BOOL)checkSeedsTable
{
    sqlite3_stmt *stmp;
    char* errmsg;
    NSString* sql = @"select count(*) as 'count' from sqlite_master where type ='table' and name = 't_Seeds'";
    int res= sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmp, NULL);
    if (res == SQLITE_OK)
    {
        while (sqlite3_step(stmp)==SQLITE_ROW)
        {
            int tableCount = sqlite3_column_int(stmp, 0);
            if (tableCount == 1)
            {
                return TRUE;
            }
        }
    }

    sql = @"create table t_Seeds (id INTEGER PRIMARY KEY, \
                                    name TEXT NOT NULL, \
                                    static INTEGER default 0)";
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name) values ('%@')", NSLocalizedString(@"9fu-Ns-EVh.text", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name) values ('%@')", NSLocalizedString(@"Health", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name) values ('%@')", NSLocalizedString(@"Wisdom", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name) values ('%@')", NSLocalizedString(@"Harmonious", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    return TRUE;

}

-(void)closeDB
{
    sqlite3_close(database);
}


-(NSArray*)getAllSeeds
{
    return nil;
}

@end






