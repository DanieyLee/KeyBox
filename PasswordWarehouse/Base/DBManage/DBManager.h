//
//  DBManager.h
//  QiangJing
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#pragma mark 数据库名
#define DB_NAME @"db_password_box"

#pragma mark 数据表名
#define TB_PASSWORD @"tb_password"  //用户

#pragma mark 本地数据更新时间记录字段名
#define keyForDatabaseId @"_id_"
#define keyForUpdateTime @"update_time"
#define keyForCreateTime @"create_time"
#define kUploadState      @"uploadState"//上传状态

@interface DBManager : NSObject

+ (id)sharedInstance;

/**
 *  删除tableName数据表
 *
 *  @param tableName 表名
 */
- (void)dropTable:(NSString *)tableName;

/**
 *  截断数据表tableName，自增主键回到从0开始
 *
 *  @param tableName 表名
 */
- (void)truncateTable:(NSString *)tableName;

/**
 *  向tableName表中插入(字典)map，完成后回调handler，返回ID为新增纪录的自增主键
 *
 *  @param map 字典
 *  @param tableName 表名
 *  @param handler  回调
 */
- (void)insertMap:(NSDictionary *)map tableName:(NSString *)tableName handler:(void(^)(sqlite3_int64 ID))handler;

/**
 *  向tableName表中插入(字典数组)list，完成后回调handler，返回count为新增纪录的数量
 *
 *  @param list 数组
 *  @param tableName 表名
 *  @param handler 回调
 */
- (void)insertMapList:(NSArray *)list tableName:(NSString *)tableName handler:(void(^)(int count))handler;

/**
 *  向tableName表中插入或更新(字典)map，完成后回调handler，返回count为影响纪录条数
 *  如果数据表中有记录与字典map在参数keys所有对应字段的值相等，那么更新map的到该记录；否则向数据表插入该字典map
 *
 *  @param map 字典
 *  @param keys 关键字数组
 *  @param tableName 表名
 *  @param handler 回调
 */
- (void)insertOrUpdateMap:(NSDictionary *)map forKeys:(NSArray *)keys tableName:(NSString *)tableName handler:(void(^)(sqlite3_int64 count))handler;

/**
 *  向tableName表中插入或更新(字典数组)list，完成后回调handler，返回count为影响纪录条数
 *  如果数据表中有记录与字典数组list中的字典在参数keys所有对应字段的值相等，那么更新字典数据的到该记录；否则向数据表插入该字典数据
 *
 *  @param list 数组
 *  @param keys 关键字数组
 *  @param tableName 表名
 *  @param handler 回调
 */
- (void)insertOrUpdateMapList:(NSArray *)list forKeys:(NSArray *)keys tableName:(NSString *)tableName handler:(void(^)(int count))handler;

/**
 *  在数据库中执行sql，parameters对应占位符顺序；例如：sql:@"update tb_user set companyName=? where companyId=?"；parameters:@[@"睿驰", @1]；相当于执行@"update tb_user set companyName='睿驰' where companyId=1"
 *
 *  @param sql sql语句
 *  @param parameters 参数
 */
- (void)update:(NSString *)sql parameters:(NSArray *)parameters;

/**
 *  从数据库中查询相关记录，完成后回调handler，dict为结果集的第一条数据
 *  执行sql，parameters对应占位符顺序；例如：sql:@"select * from tb_user where companyId=? and gender=?"；parameters:@[@1, @"男"]；相当于执行@"select * from tb_user where companyId=1 and gender='男'"
 *
 *  @param sql sql语句
 *  @param parameters 参数
 *  @param handler 回调
 */
- (void)queryForMap:(NSString *)sql parameters:(NSArray *)parameters handler:(void(^)(NSDictionary * dict))handler;

/**
 *  从数据库中查询所有相关记录，完成后回调handler，array为查询的结果集
 *  执行sql，parameters对应占位符顺序；例如：sql:@"select * from tb_user where companyId=? and gender=?"；parameters:@[@1, @"男"]；相当于执行@"select * from tb_user where companyId=1 and gender='男'"
 *
 *  @param sql sql语句
 *  @param parameters 参数
 *  @param handler 回调
 */
- (void)queryForList:(NSString *)sql parameters:(NSArray *)parameters handler:(void(^)(NSArray * array))handler;


@end
