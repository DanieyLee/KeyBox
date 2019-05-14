//
//  DatabaseUtil.h
//  QiangJing
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseUtil : NSObject

+ (BOOL)openDB:(sqlite3 **)dataBase withDBName:(NSString *)dbName;

+ (BOOL)closeDB:(sqlite3 *)dataBase;

+ (BOOL)dropTable:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (BOOL)truncateTable:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (sqlite3_int64)insertMap:(NSDictionary *)map tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (int)insertMapList:(NSArray *)list tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (sqlite3_int64)insertOrUpdateMap:(NSDictionary *)map forKeys:(NSArray *)keys tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (int)insertOrUpdateMapList:(NSArray *)list forKeys:(NSArray *)keys tableName:(NSString *)tableName dataBase:(sqlite3 *)dataBase;

+ (BOOL)update:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase;

+ (NSMutableDictionary *)queryForMap:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase;

+ (NSArray *)queryForList:(NSString *)sql parameters:(NSArray *)parameters dataBase:(sqlite3 *)dataBase;

@end
