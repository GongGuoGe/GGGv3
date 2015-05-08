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
+(SqliteMgr *)instance
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
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name, static) values ('%@', 1)", NSLocalizedString(@"Wealth", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name, static) values ('%@', 1)", NSLocalizedString(@"Health", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name, static) values ('%@', 1)", NSLocalizedString(@"Wisdom", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    sql = [NSString stringWithFormat:@"insert into t_Seeds (name, static) values ('%@', 1)", NSLocalizedString(@"Harmonious", nil)];
    res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        return FALSE;
    }
    return TRUE;

}


-(BOOL)checkContentTable
{
    sqlite3_stmt *stmp;
    char* errmsg;
    NSString* sql = @"select count(*) as 'count' from sqlite_master where type ='table' and name = 't_Contents'";
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
    sql = @"create table t_Contents (id INTEGER PRIMARY KEY, \
        seedName TEXT NOT NULL, \
        positive TEXT NOT NULL, \
        negative TEXT NOT NULL, \
        iWant TEXT NOT NULL, \
        isPublic INTEGER default 0, \
        createTime TEXT NOT NULL)";
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
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSString* sql = @"select name from t_Seeds order by id";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char* cName = (char*)sqlite3_column_text(statement, 0);
            [arr addObject:[[NSString alloc] initWithUTF8String:cName]];
        }
        sqlite3_finalize(statement);
    }
    
    return arr;
}


-(BOOL)saveContent:(NSString*)seedName positive:(NSString*)pos negative:(NSString*)neg iWant:(NSString*)iwant isPublic:(BOOL)isPub
{
    if (![self checkContentTable]) {
        return FALSE;
    }
    
    char* errmsg;
    NSString* sql = [NSString stringWithFormat:@"insert into t_Contents (seedName, positive, negative, iWant, isPublic, createTime) \
                     values('%@', '%@', '%@', '%@', %d, datetime('now', 'localtime'))", seedName, pos, neg, iwant, isPub ? 1 : 0, nil];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    if (res != SQLITE_OK)
    {
        NSLog(@"%s", errmsg);
        return FALSE;
    }
    return TRUE;
}

-(NSArray*)getAllContent {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    if (![self checkContentTable]) {
        return arr;
    }
    
    NSString* sql = @"select seedName, positive, negative, iWant, isPublic, createTime from t_Contents";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
//            seedName, positive, negative, iWant, isPublic, createTime
            char* seedName = (char*)sqlite3_column_text(statement, 0);
            char* positive = (char*)sqlite3_column_text(statement, 1);
            char* negative = (char*)sqlite3_column_text(statement, 2);
            char* iWant = (char*)sqlite3_column_text(statement, 3);
            NSInteger isPublic = (NSInteger)sqlite3_column_int64(statement, 4);
            char* createTime = (char*)sqlite3_column_text(statement, 5);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"y-M-d HH:mm:ss"];
            NSDate *date=[dateFormatter dateFromString:[NSString stringWithUTF8String:createTime]];
            
            NSDictionary* content = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithUTF8String:seedName], @"seedName",
                                     [NSString stringWithUTF8String:positive], @"positive",
                                     [NSString stringWithUTF8String:negative], @"negative",
                                     [NSString stringWithUTF8String:iWant], @"iWant",
                                     [NSNumber numberWithInteger:isPublic], @"isPublic",
                                     date, @"createTime", nil];

            [arr addObject:content];
        }
        sqlite3_finalize(statement);
    }
    return arr;
}
@end






