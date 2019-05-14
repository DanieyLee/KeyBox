//
//  NSObject+WSRequestData.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WSRequestData)

+(void)postWithRelativePath:(NSString *)path
              paramate:(nullable NSDictionary *)dic
               success:(void(^)(NSDictionary * dic))aSuccess
                  fail:(void(^)(NSError * error))errorInfo
               warning:(void(^)(NSString *waring))warning
              complete:(void(^)(void))completeHandle;

+ (void)getWithRelativePath:(NSString *)path
                    paramate:(nullable NSDictionary *)dic
                     success:(void(^)(NSDictionary * dic))aSuccess
                        fail:(void(^)(NSError * error))errorInfo
                     warning:(void(^)(NSString *waring))warning
                    complete:(void(^)(void))completeHandle;

+ (void)deleteWithRelativePath:(NSString *)path
                   paramate:(nullable NSDictionary *)dic
                    success:(void(^)(NSDictionary * dic))aSuccess
                       fail:(void(^)(NSError * error))errorInfo
                    warning:(void(^)(NSString *waring))warning
                   complete:(void(^)(void))completeHandle;

+ (void)putWithRelativePath:(NSString *)path
                      paramate:(nullable NSDictionary *)dic
                       success:(void(^)(NSDictionary * dic))aSuccess
                          fail:(void(^)(NSError * error))errorInfo
                       warning:(void(^)(NSString *waring))warning
                      complete:(void(^)(void))completeHandle;

@end

NS_ASSUME_NONNULL_END
