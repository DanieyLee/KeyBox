//
//  NSObject+WSRequestData.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "NSObject+WSRequestData.h"
#import <AFNetworking/AFNetworking.h>

@implementation NSObject (WSRequestData)

+(void)postWithRelativePath:(NSString *)path
                   paramate:(NSDictionary *)dic
                    success:(void(^)(NSDictionary * dic))aSuccess
                       fail:(void(^)(NSError * error))errorInfo
                    warning:(void(^)(NSString *waring))warning
                   complete:(void(^)(void))completeHandle;
{
    NSString *url = [URLPREFIX stringByAppendingString:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    responseSerializer.removesKeysWithNullValues = YES;
    NSString *authention = [NSString stringWithFormat:@"Bearer %@", USER_TOKEN];
    NSLog(@"\nurl:%@\n%@ \n%@",url, dic, authention);
    [manager.requestSerializer setValue:authention forHTTPHeaderField:@"Authorization"];
    
    [manager POST:url
       parameters:dic
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (aSuccess) {
             aSuccess(responseObject);
         }
         if (completeHandle) {
             completeHandle();
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
         NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
         if (error && errorData && errorData.length != 0) {
             NSMutableDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
             NSString *title = [errorInfo objectForKey:@"title"];
             if (title.length != 0) {
                 if (warning) {
                     warning(title);
                 }
             }
         } else {
             if (errorInfo) {
                 errorInfo(error);
             }
         }
         if (completeHandle) {
             completeHandle();
         }
     }];
}

+ (void)getWithRelativePath:(NSString *)path
                   paramate:(NSDictionary *)dic
                    success:(void(^)(NSDictionary * dic))aSuccess
                       fail:(void(^)(NSError * error))errorInfo
                    warning:(void(^)(NSString *waring))warning
                   complete:(void(^)(void))completeHandle {
    NSString *url = [URLPREFIX stringByAppendingString:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    responseSerializer.removesKeysWithNullValues = YES;
    NSString *authention = [NSString stringWithFormat:@"Bearer %@", USER_TOKEN];
    NSLog(@"\nurl:%@\n%@ \n%@",url, dic, authention);
    [manager.requestSerializer setValue:authention forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url
      parameters:dic
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if (aSuccess) {
                 aSuccess(responseObject);
             }
             if (completeHandle) {
                 completeHandle();
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
             NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
             if (error && errorData && errorData.length != 0) {
                 NSMutableDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
                 NSString *title = [errorInfo objectForKey:@"title"];
                 if (title.length != 0) {
                     if (warning) {
                         warning(title);
                     }
                 }
             } else {
                 if (errorInfo) {
                     errorInfo(error);
                 }
             }
             if (completeHandle) {
                 completeHandle();
             }
         }];
}

+ (void)deleteWithRelativePath:(NSString *)path
                      paramate:(nullable NSDictionary *)dic
                       success:(void(^)(NSDictionary * dic))aSuccess
                          fail:(void(^)(NSError * error))errorInfo
                       warning:(void(^)(NSString *waring))warning
                      complete:(void(^)(void))completeHandle {
    NSString *url = [URLPREFIX stringByAppendingString:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    responseSerializer.removesKeysWithNullValues = YES;
    NSString *authention = [NSString stringWithFormat:@"Bearer %@", USER_TOKEN];
    NSLog(@"\nurl:%@\n%@ \n%@",url, dic, authention);
    [manager.requestSerializer setValue:authention forHTTPHeaderField:@"Authorization"];
    
    [manager DELETE:url
         parameters:dic
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if (aSuccess) {
                    aSuccess(responseObject);
                }
                if (completeHandle) {
                    completeHandle();
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                if (error && errorData && errorData.length != 0) {
                    NSMutableDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
                    NSString *title = [errorInfo objectForKey:@"title"];
                    if (title.length != 0) {
                        if (warning) {
                            warning(title);
                        }
                    }
                } else {
                    if (errorInfo) {
                        errorInfo(error);
                    }
                }
                if (completeHandle) {
                    completeHandle();
                }
            }];
}

+ (void)putWithRelativePath:(NSString *)path
                   paramate:(nullable NSDictionary *)dic
                    success:(void(^)(NSDictionary * dic))aSuccess
                       fail:(void(^)(NSError * error))errorInfo
                    warning:(void(^)(NSString *waring))warning
                   complete:(void(^)(void))completeHandle {
    NSString *url = [URLPREFIX stringByAppendingString:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    responseSerializer.removesKeysWithNullValues = YES;
    NSString *authention = [NSString stringWithFormat:@"Bearer %@", USER_TOKEN];
    NSLog(@"\nurl:%@\n%@ \n%@",url, dic, authention);
    [manager.requestSerializer setValue:authention forHTTPHeaderField:@"Authorization"];
    
    [manager PUT:url
         parameters:dic
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if (aSuccess) {
                    aSuccess(responseObject);
                }
                if (completeHandle) {
                    completeHandle();
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                if (error && errorData && errorData.length != 0) {
                    NSMutableDictionary *errorInfo = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:nil];
                    NSString *title = [errorInfo objectForKey:@"title"];
                    if (title.length != 0) {
                        if (warning) {
                            warning(title);
                        }
                    }
                } else {
                    if (errorInfo) {
                        errorInfo(error);
                    }
                }
                if (completeHandle) {
                    completeHandle();
                }
            }];
}

@end
