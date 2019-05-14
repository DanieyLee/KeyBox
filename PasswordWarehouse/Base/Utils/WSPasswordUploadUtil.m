//
//  WSPasswordUploadUtil.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/20.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSPasswordUploadUtil.h"
#import "DBManager.h"
#import "WSBaseModel.h"

@interface WSPasswordUploadModel : WSBaseModel
@property (nonatomic, strong) NSDictionary *uploadInfo;
@property (nonatomic, assign) NSInteger     uploadState;//上传状态，0准备上传，1正在上传，2上传成功，3上传失败，
@end

@implementation WSPasswordUploadModel

@end

@interface WSPasswordUploadUtil ()
@property (nonatomic, strong) NSMutableArray<WSPasswordUploadModel *>    *uploadArray;
@end

@implementation WSPasswordUploadUtil

+ (instancetype)sharedPasswordUploadUtil {
    static WSPasswordUploadUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [WSPasswordUploadUtil new];
        util.uploadArray = [NSMutableArray array];
    });
    return util;
}

- (void)queryUnUploadPasswordWithCompleteHandle:(void(^)(void))handle {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='-1' OR %@='-2'", TB_PASSWORD, kUploadState, kUploadState];
    [[DBManager sharedInstance] queryForList:sql
                                  parameters:nil handler:^(NSArray *array) {
                                      if (array && array.count > 0) {
                                          WSPasswordUploadUtil *util = [WSPasswordUploadUtil sharedPasswordUploadUtil];
                                          if (util.uploadArray == nil) util.uploadArray = [NSMutableArray array];
                                          if (util.uploadArray.count == 0) {
                                              for (NSDictionary *tempDic in array) {
                                                  WSPasswordUploadModel *model = [WSPasswordUploadModel new];
                                                  model.uploadInfo = tempDic;
                                                  [util.uploadArray addObject:model];
                                              }
                                          } else {
                                              for (NSDictionary *info in array) {
                                                  NSString *idStr = [info ws_stringForKey:@"id"];
                                                  BOOL uploadArraryHadContain = NO;
                                                  for (WSPasswordUploadModel *uploadModel in util.uploadArray.copy) {
                                                      NSString *uploadId = [uploadModel.uploadInfo ws_stringForKey:@"id"];
                                                      if ([idStr isEqualToString:uploadId]) {
                                                          uploadArraryHadContain = YES;
                                                          break;
                                                      }
                                                  }
                                                  if (uploadArraryHadContain == NO) {
                                                      WSPasswordUploadModel *model = [WSPasswordUploadModel new];
                                                      model.uploadInfo = info;
                                                      [util.uploadArray addObject:model];
                                                  }
                                              }
                                          }
                                      }
                                      if (handle) {
                                          handle();
                                      }
                                  }];
}

- (void)startUpload {
    if (!USER_TOKEN) {
        return;
    }
    WSPasswordUploadUtil *util = [WSPasswordUploadUtil sharedPasswordUploadUtil];
    [util queryUnUploadPasswordWithCompleteHandle:^{
        for (WSPasswordUploadModel *model in util.uploadArray) {
            if (model.uploadState == 1 || model.uploadState == 2) {
                break;
            }
            model.uploadState = 1;
            NSDictionary *info = model.uploadInfo;
            NSString *uploadState = [info ws_stringForKey:kUploadState];
            if ([uploadState isEqualToString:@"-1"]) {
                //未上传
                NSString *itemId = [info ws_stringForKey:@"id"];
                if (itemId && itemId.length == 0) {
                    //新增的
                    [util save:model];
                } else {
                    //修改的
                    [util modify:model];
                }
            } else {
                //未删除
                [util delete:model];
            }
        }
    }];
}

- (void)save:(WSPasswordUploadModel *)saveModel {
    NSDictionary *saveInfo = saveModel.uploadInfo;
    [NSObject postWithRelativePath:URL_ADDITEM
                          paramate:[self filterParametrs:saveInfo]
                           success:^(NSDictionary * _Nonnull dic) {
                               [self deleteDBWithInfo:saveModel];
                           } fail:^(NSError * _Nonnull error) {
                               saveModel.uploadState = 3;
                           } warning:^(NSString * _Nonnull waring) {
                               saveModel.uploadState = 3;
                           } complete:^{
                           }];
}

- (void)modify:(WSPasswordUploadModel *)modifyModel{
    [NSObject putWithRelativePath:URL_ITEMEDITE
                         paramate:modifyModel.uploadInfo
                          success:^(NSDictionary * _Nonnull dic) {
                              [self deleteDBWithInfo:modifyModel];
                          } fail:^(NSError * _Nonnull error) {
                              modifyModel.uploadState = 3;
                          } warning:^(NSString * _Nonnull waring) {
                              modifyModel.uploadState = 3;
                          } complete:^{
                          }];
}


- (void)delete:(WSPasswordUploadModel *)deleteModel {
    NSString *urlPath = [URL_ITEMDELETE stringByAppendingPathComponent:[deleteModel.uploadInfo ws_stringForKey:@"id"]];
    [NSObject deleteWithRelativePath:urlPath paramate:nil
                             success:^(NSDictionary * _Nonnull dic) {
//                                 NSString * sql = [NSString stringWithFormat:@"delete from %@ where id=?", TB_PASSWORD];
//                                 [[DBManager sharedInstance] update:sql parameters:@[deleteInfo[@"id"]]];
                                 [self deleteDBWithInfo:deleteModel];
                             } fail:^(NSError * _Nonnull error) {
                                 deleteModel.uploadState = 3;
                             } warning:^(NSString * _Nonnull waring) {
                                 deleteModel.uploadState = 3;
                             } complete:^{
                             }];
}

- (void)deleteDBWithInfo:(WSPasswordUploadModel *)model {
    model.uploadState = 2;
    NSString *ID = [model.uploadInfo ws_stringForKey:keyForDatabaseId];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@=%@", TB_PASSWORD, keyForDatabaseId, ID];
    [[DBManager sharedInstance] update:sql parameters:nil];
    [[WSPasswordUploadUtil sharedPasswordUploadUtil].uploadArray removeObject:model];
    if ([WSPasswordUploadUtil sharedPasswordUploadUtil].uploadArray.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDataChanged object:nil];
    }
}

- (NSDictionary *)filterParametrs:(NSDictionary *)parameters {
    NSMutableDictionary *dic = parameters.mutableCopy;
    [dic removeObjectForKey:@"_id_"];
    [dic removeObjectForKey:@"update_time"];
    [dic removeObjectForKey:@"uploadState"];
    [dic removeObjectForKey:@"create_time"];
    return dic;
}

@end
