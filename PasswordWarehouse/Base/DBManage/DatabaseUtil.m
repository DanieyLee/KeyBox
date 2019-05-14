//
//  DatabaseUtil.m
//  QiangJing
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import "DatabaseUtil.h"
#import "DBManager.h"
#import "JSONUtil.h"

@implementation DatabaseUtil

+ (BOOL)openDB:(sqlite3 **)dataBase withDBName:(NSString *)dbName {
    NSString * docsDir;
    NSArray * dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString * databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", dbName]]];
    
    const char * dbPath = [databasePath UTF8String];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:databasePath]) {
        if (sqlite3_open(dbPath, dataBase)==SQLITE_OK) {
            NSLog(@"open database succeed");
            return YES;
        } else {
            sqlite3_close(*dataBase);
            NSLog(@"open fail");
            return NO;
        }
    }
    
    if (sqlite3_open(dbPath, dataBase)==SQLITE_OK) {
        NSLog(@"create database succeed");
        return YES;
    } else {
        sqlite3_close(*dataBase);
        NSLog(@"create fail");
        return NO;
    }
}

+ (BOOL)closeDB:(sqlite3 *)dataBase {
    sqlite3_close(dataBase);
    return YES;
}

+ (BOOL)createOrUpdateTable:(NSString *)tableName forDictionay:(NSDictionary *)dictionary dataBase:(sqlite3 *)dataBase forKeys:(NSArray *)keys{
    NSMutableString * sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT", tableName, keyForDatabaseId];
    for (NSString * key in [dictionary allKeys]) {
        if ([key isEqualToString:keyForDatabaseId]) {
            
        } else {
            [sql appendString:[NSString stringWithFormat:@", %@ text", key]];
        }
    }
    [sql appendString:@") "];
    
    const char * createsql = [sql UTF8String];
    
    char * errmsg;
    if (sqlite3_exec(dataBase, createsql, NULL, NULL, &errmsg)!=SQLITE_OK) {
        NSLog(@"create table %@ failed: ", tableName);
        return NO;
    }
    
    if ([[dictionary allKeys] containsObject:@"userId"]) {

    } else {
        NSString * sql = [NSString stringWithFormat:@"alter table '%@' add column userId text ", tableName];
        sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &errmsg);
    }
    
    [self updateColumns:tableName forDictionary:dictionary database:dataBase forKeys:keys];
    return YES;
}

+ (void)updateColumns:(NSString *)tableName forDictionary:(NSDictionary *)dictionary database:(sqlite3 *)database forKeys:(NSArray *)keys {
    char * errmsg;
    for (NSString * key in [dictionary allKeys]) {
        NSString * sql = [NSString stringWithFormat:@"alter table '%@' add column '%@' text ", tableName, key];
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg)!=SQLITE_OK) {
//            NSLog(@"errmsg:%s", errmsg);
        }
    }
}

+ (BOOL)dropTable:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
    NSString * sql = [NSString stringWithFormat:@"drop table %@", tableName];
    char * err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err)==SQLITE_OK) {
        return YES;
    } else {
        NSLog(@"drop table %@, errmsg:%s", tableName, err);
    }
    return NO;
}

+ (BOOL)truncateTable:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
    NSString * sql = [NSString stringWithFormat:@"delete from %@;", tableName];
    char * err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err)==SQLITE_OK) {
        sql = [NSString stringWithFormat:@"update sqlite_sequence set seq=0 where name=%@;", tableName];
        if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err)) {
            return YES;
        }
    } else {
        NSLog(@"truncate table %@, errmsg:%s", tableName, err);
    }
    return NO;
}

+ (sqlite3_int64)insertMap:(NSDictionary *)map tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:map];
    [dict setObject:CURRENT_TIME forKey:keyForUpdateTime];
    [dict setObject:CURRENT_TIME forKey:keyForCreateTime];
    [self createOrUpdateTable:tableName forDictionay:dict dataBase:dataBase forKeys:nil];
    
    NSMutableString * sql = [[NSMutableString alloc] initWithString:@"INSERT INTO "];
    [sql appendString:tableName];
    
    NSMutableString * fields = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString * values = [[NSMutableString alloc] initWithString:@"("];
    for (NSString * key in [dict allKeys]) {
        if ([dict objectForKey:key]) {
            if ([fields isEqualToString:@"("]) {
                [fields appendString:[NSString stringWithFormat:@"%@", key]];
                [values appendString:@"?"];
            } else {
                [fields appendString:[NSString stringWithFormat:@", %@", key]];
                [values appendString:[NSString stringWithFormat:@", ?"]];
            }
        }
    }
    [fields appendString:@")"];
    [values appendString:@")"];
    
    [sql appendString:fields];
    [sql appendString:@" VALUES "];
    [sql appendString:values];
    
    sqlite3_stmt * insert_statement;
    int succeed = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &insert_statement, NULL);
    if (succeed!=SQLITE_OK) {
        NSLog(@"insert sqlite3_prepare_v2 errmsg: %s", sqlite3_errmsg(dataBase));
        return NO;
    }
    
    int index = 1;
    for (NSString * key in [dict allKeys]) {
        NSString * text;
        if ([[map objectForKey:key] isKindOfClass:[NSArray class]] || [[map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            text = [JSONUtil stringWithJSONObject:[dict objectForKey:key] error:nil];
        } else {
            text = [NSString stringWithFormat:@"%@", [dict objectForKey:key]];
        }
        sqlite3_bind_text(insert_statement, index, [text UTF8String], -1, SQLITE_TRANSIENT);
        index++;
    }
    
    succeed = sqlite3_step(insert_statement);
    
    sqlite3_finalize(insert_statement);
    
    if (succeed==SQLITE_ERROR) {
        NSLog(@"insert into %@ fail", tableName);
        return 0;
    } else {
        NSLog(@"insert into %@ succeed", tableName);
        return sqlite3_last_insert_rowid(dataBase);
    }
}

+ (int)insertMapList:(NSArray *)list tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
//    int count = 0;
//    for (NSDictionary * dict in list) {
//        if ([self insertMap:dict tableName:tableName dataBase:dataBase]) {
//            count++;
//        }
//    }
//    return count;
    
    NSMutableDictionary * map = [NSMutableDictionary dictionary];
    for (NSDictionary * tmpDict in list) {
        [map addEntriesFromDictionary:tmpDict];
    }
    [map setObject:CURRENT_TIME forKey:keyForUpdateTime];
    [map setObject:CURRENT_TIME forKey:@"createTime"];
    [self createOrUpdateTable:tableName forDictionay:map dataBase:dataBase forKeys:nil];
    
    NSMutableString * sql = [[NSMutableString alloc] initWithString:@"INSERT INTO "];
    [sql appendString:tableName];
    
    NSMutableString * fields = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString * values = [[NSMutableString alloc] initWithString:@"("];
    for (NSString * key in [map allKeys]) {
        if ([map objectForKey:key]) {
            if ([fields isEqualToString:@"("]) {
                [fields appendString:[NSString stringWithFormat:@"%@", key]];
                [values appendString:@"?"];
            } else {
                [fields appendString:[NSString stringWithFormat:@", %@", key]];
                [values appendString:[NSString stringWithFormat:@", ?"]];
            }
        }
    }
    [fields appendString:@")"];
    [values appendString:@")"];
    
    [sql appendString:fields];
    [sql appendString:@" VALUES "];
    NSMutableString * allValues = [[NSMutableString alloc] initWithString:@""];
    for (int i=0; i<list.count; i++) {
        if ([allValues isEqualToString:@""]) {
            [allValues appendString:values];
        } else {
            [allValues appendString:@","];
            [allValues appendString:values];
        }
    }
    [sql appendString:allValues];
    
    sqlite3_stmt * insert_statement;
    int succeed = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &insert_statement, NULL);
    if (succeed!=SQLITE_OK) {
        NSLog(@"%s insert sqlite3_prepare_v2 errmsg: %s", __func__, sqlite3_errmsg(dataBase));
        return NO;
    }
    
    int index = 1;
    for (NSDictionary * dict in list) {
        for (NSString * key in map.allKeys) {
            NSString * text;
            if ([[map objectForKey:key] isKindOfClass:[NSArray class]] || [[map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                text = [JSONUtil stringWithJSONObject:[dict objectForKey:key] error:nil];
            } else {
                text = [NSString stringWithFormat:@"%@", [dict objectForKey:key]];
            }
            sqlite3_bind_text(insert_statement, index, [text UTF8String], -1, SQLITE_TRANSIENT);
            index++;
        }
    }
    
    succeed = sqlite3_step(insert_statement);
    
    sqlite3_finalize(insert_statement);
    
    if (succeed==SQLITE_ERROR) {
        NSLog(@"insert into %@ fail", tableName);
        return 0;
    }
    
    return (int)list.count;
}

+ (sqlite3_int64)insertOrUpdateMap:(NSDictionary *)map forKeys:(NSArray *)keys tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
    if (map==nil) {
        return 0;
    }
    NSMutableDictionary * dict = [map mutableCopy];
    [dict setObject:CURRENT_TIME forKey:keyForUpdateTime];
    map = dict;
    [self createOrUpdateTable:tableName forDictionay:map dataBase:dataBase forKeys:keys];
    
    NSMutableString * sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"update %@ set %@=? ", tableName, keyForUpdateTime]];
    
    NSMutableArray * parameters = [NSMutableArray array];
    [parameters addObject:CURRENT_TIME];
    if ([map objectForKey:keyForDatabaseId]) {
        for (NSString * key in [map allKeys]) {
            if ([key isEqualToString:keyForDatabaseId]) {
                
            } else {
                [sql appendString:[NSString stringWithFormat:@", %@=?", key]];
                if ([[map objectForKey:key] isKindOfClass:[NSArray class]] || [[map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                    [parameters addObject:[JSONUtil stringWithJSONObject:[map objectForKey:key] error:nil]];
                } else {
                    [parameters addObject:[NSString stringWithFormat:@"%@", [map objectForKey:key]]];
                }
            }
        }
        [sql appendString:[NSString stringWithFormat:@" where %@=? ", keyForDatabaseId]];
        [parameters addObject:[map objectForKey:keyForDatabaseId]];
    } else {
        NSMutableString * updateString = [NSMutableString stringWithFormat:@""];
        NSMutableArray * updateValue = [NSMutableArray array];
        NSMutableString * conditionString = [NSMutableString stringWithFormat:@""];
        NSMutableArray * conditionValue = [NSMutableArray array];
        for (NSString * key in [map allKeys]) {
            if ([key isEqualToString:keyForDatabaseId]) {
                
            } else {
                if ([keys containsObject:key]) {
                    if ([conditionString isEqualToString:@""]) {
                        [conditionString appendString:[NSString stringWithFormat:@" where %@=? ", key]];
                    } else {
                        [conditionString appendString:[NSString stringWithFormat:@" and %@=? ", key]];
                    }
                    if ([[map objectForKey:key] isKindOfClass:[NSArray class]] || [[map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        [conditionValue addObject:[JSONUtil stringWithJSONObject:[map objectForKey:key] error:nil]];
                    } else {
                        [conditionValue addObject:[NSString stringWithFormat:@"%@", [map objectForKey:key]]];
                    }
                } else {
                    [updateString appendString:[NSString stringWithFormat:@", %@=? ", key]];
                    
                    if ([[map objectForKey:key] isKindOfClass:[NSArray class]] || [[map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        [updateValue addObject:[JSONUtil stringWithJSONObject:[map objectForKey:key] error:nil]];
                    } else {
                        [updateValue addObject:[NSString stringWithFormat:@"%@", [map objectForKey:key]]];
                    }
                }
            }
        }
        [sql appendString:updateString];
        [sql appendString:conditionString];
        [parameters addObjectsFromArray:updateValue];
        [parameters addObjectsFromArray:conditionValue];
    }
    
    sqlite3_stmt * statement;
    int succeed = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &statement, NULL);
    if (succeed!=SQLITE_OK) {
        NSLog(@"update sqlite3_prepare_v2 errmsg: %s", sqlite3_errmsg(dataBase));
        return NO;
    }
    
    for (int index=1; index<=[parameters count]; index++) {
        id obj = [parameters objectAtIndex:index-1];
        if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
            sqlite3_bind_int64(statement, index, [obj integerValue]);
        } else {
            sqlite3_bind_text(statement, index, [obj UTF8String], -1, SQLITE_TRANSIENT);
        }
    }
    
    succeed = sqlite3_step(statement);
    
    int count = sqlite3_changes(dataBase);
    
    sqlite3_finalize(statement);
    
    if (succeed==SQLITE_ERROR || count<=0) {
        NSLog(@"update %@ fail", tableName);
        sqlite3_int64 result = [self insertMap:map tableName:tableName dataBase:dataBase];
        if (result) {
            return result;
        }
        return 0;
    } else {
        NSLog(@"update %@ succeed", tableName);
        return count;
    }
}

+ (int)insertOrUpdateMapList:(NSArray *)list forKeys:(NSArray *)keys tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase {
    int count = 0;
    for (NSDictionary * dict in list) {
        sqlite3_int64 id_ = [self insertOrUpdateMap:dict forKeys:keys tableName:tableName dataBase:dataBase];
        if (id_>0) {
            count++;
        }
    }
    return count;
}

+ (BOOL)update:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase {
    sqlite3_stmt * statement = nil;
    if (sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"sql:%@ \n sqlite3_prepare_v2 fail with error: %s", sql, sqlite3_errmsg(dataBase));
        return NO;
    } else {
        for (int index=1; index<=[parameters count]; index++) {
            if ([[[parameters objectAtIndex:index-1] class] isSubclassOfClass:[NSNumber class]]) {
                sqlite3_bind_int64(statement, index, [[parameters objectAtIndex:index-1] integerValue]);
            } else {
                sqlite3_bind_text(statement, index, [[parameters objectAtIndex:index-1] UTF8String], -1, SQLITE_TRANSIENT);
            }
        }
        BOOL succeed = sqlite3_step(statement);
        sqlite3_finalize(statement);
        return succeed;
    }
}

+ (NSMutableDictionary *)queryForMap:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase {
    NSArray * array = [self queryForList:sql parameters:parameters dataBase:dataBase];
    if ([array count]>0) {
        return [array objectAtIndex:0];
    }
    return nil;
}

+ (NSArray *)queryForList:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase {
    sqlite3_stmt * statement = nil;
    if (sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"sql: %@ \n Error: failed to prepare statement with error: %s", sql, sqlite3_errmsg(dataBase));
        sqlite3_finalize(statement);
        return nil;
    } else {
        for (int index=1; index<=[parameters count]; index++) {
            id obj = [parameters objectAtIndex:index-1];
            if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
                sqlite3_bind_int64(statement, index, [obj integerValue]);
            } else {
                sqlite3_bind_text(statement, index, [[parameters objectAtIndex:index-1] UTF8String], -1, SQLITE_TRANSIENT);
            }
        }
        NSMutableArray * array = [NSMutableArray array];
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            int count = sqlite3_column_count(statement);
            for (int i=0; i<count; i++) {
                char * nameText = (char *)sqlite3_column_name(statement, i);
                char * strText = (char *)sqlite3_column_text(statement, i);
                if (strText==NULL) {
                    
                } else {
                    [dict setObject:[NSString stringWithUTF8String:strText] forKey:[NSString stringWithUTF8String:nameText]];
                }
            }
            [array addObject:dict];
        }
        sqlite3_finalize(statement);
        return array;
    }
    return nil;
}

@end
