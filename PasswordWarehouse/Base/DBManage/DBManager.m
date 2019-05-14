//
//  DBManager.m
//  QiangJing
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import "DBManager.h"
#import "DatabaseUtil.h"
#import "JSONUtil.h"

@interface DBManager ()
@property (nonatomic, assign) sqlite3 * database;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation DBManager

+ (id)sharedInstance {
    static DBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("db_manager", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        dispatch_async(_queue, ^{
            [DatabaseUtil openDB:&(self->_database) withDBName:DB_NAME];
        });
    }
    return self;
}

- (void)dealloc {
    __weak typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        [DatabaseUtil closeDB:weakSelf.database];
    });
}

- (void)dropTable:(NSString *)tableName {
    __weak typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        [DatabaseUtil dropTable:tableName dataBase:weakSelf.database];
    });
}

- (void)truncateTable:(NSString *)tableName {
    __weak typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        [DatabaseUtil truncateTable:tableName dataBase:weakSelf.database];
    });
}

- (void)insertMap:(NSDictionary *)map tableName:(NSString *)tableName handler:(void(^)(sqlite3_int64))handler {
    __weak typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        sqlite3_int64 ID = [DatabaseUtil insertMap:map tableName:tableName dataBase:weakSelf.database];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(ID);
        });
    });
}

- (void)insertMapList:(NSArray *)list tableName:(NSString *)tableName handler:(void(^)(int))handler {
    if (list.count>0) {
        __weak typeof(self)weakSelf = self;
        dispatch_async(_queue, ^{
            int count = [DatabaseUtil insertMapList:list tableName:tableName dataBase:weakSelf.database];
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(count);
            });
        });
    } else {
        handler(0);
    }
}

- (void)insertOrUpdateMap:(NSDictionary *)map forKeys:(NSArray *)keys tableName:(NSString *)tableName handler:(void (^)(sqlite3_int64))handler {
    dispatch_async(_queue, ^{
        __weak typeof(self)weakSelf = self;
        sqlite3_int64 ID = [DatabaseUtil insertOrUpdateMap:map forKeys:keys tableName:tableName dataBase:weakSelf.database];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(ID);
        });
    });
}

- (void)insertOrUpdateMapList:(NSArray *)list forKeys:(NSArray *)keys tableName:(NSString *)tableName handler:(void (^)(int))handler {
    if (list.count>0) {
        __weak typeof(self)weakSelf = self;
        dispatch_async(_queue, ^{
            int count = [DatabaseUtil insertOrUpdateMapList:list forKeys:keys tableName:tableName dataBase:weakSelf.database];
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(count);
            });
        });
    } else {
        handler(0);
    }
}

- (void)update:(NSString *)sql parameters:(NSArray *)parameters {
     __weak typeof(self)weakSelf = self;
    dispatch_async(_queue, ^{
        [DatabaseUtil update:sql parameters:parameters dataBase:weakSelf.database];
    });
}

- (void)queryForMap:(NSString *)sql parameters:(NSArray *)parameters handler:(void (^)(NSDictionary * dict))handler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        NSMutableDictionary * dict = [DatabaseUtil queryForMap:sql parameters:parameters dataBase:weakSelf.database];
		[weakSelf checkDictionary:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(dict);
        });
    });
}

- (void)queryForList:(NSString *)sql parameters:(NSArray *)parameters handler:(void (^)(NSArray * array))handler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        NSArray * array = [DatabaseUtil queryForList:sql parameters:parameters dataBase:weakSelf.database];
		[weakSelf checkArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(array);
        });
    });
}

- (void)checkDictionary:(NSMutableDictionary*)dic
{
	for (NSString *keyStr in dic.allKeys) {
		
		NSString *objectStr = [dic ws_stringForKey:keyStr];
		
		if ([objectStr hasPrefix:@"{\n"] && [objectStr hasSuffix:@"}"]) {
			
			NSDictionary *newDict;
			NSError *error;
			
			newDict = [JSONUtil JSONObjectWithData:[objectStr dataUsingEncoding:NSUTF8StringEncoding] error:&error];
			
			if (!error) {
				[dic setObject:newDict forKey:keyStr];
			}
			else
			{
				[dic setObject:[NSDictionary dictionary] forKey:keyStr];
			}
			continue;
		}
		
		if ([objectStr hasPrefix:@"[\n"] && [objectStr hasSuffix:@"]"]) {
			
			NSArray *newArr;
			NSError *error;
			
			newArr = [JSONUtil JSONObjectWithData:[objectStr dataUsingEncoding:NSUTF8StringEncoding] error:&error];
			
			if (!error) {
				[dic setObject:newArr forKey:keyStr];
			}
			else
			{
				[dic setObject:[NSArray array] forKey:keyStr];
			}
			
			continue;
		}
	}

}

- (void)checkArray:(NSArray*)array
{
	for (NSMutableDictionary *dic in array) {
		[self checkDictionary:dic];
	}
}


@end
