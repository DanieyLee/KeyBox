//
//  WSTouchIDUtil.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSTouchIDUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation WSTouchIDUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupConfige];
    }
    return self;
}

- (void)setupConfige {
    LAContext *context = [LAContext new];
    NSError *error;
    BOOL canBiometrics = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                              error:&error];
    if (canBiometrics) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"解锁设备"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success) {
                                  NSLog(@"认证成功");
                              } else {
                                  if (error) {
                                      NSInteger errorCode = error.code;
                                      switch (errorCode) {
                                          case LAErrorAuthenticationFailed:
                                              NSLog(@"认证失败");
                                              break;
                                          case kLAErrorUserCancel:
                                              NSLog(@"用户取消");
                                              break;
                                          default:
                                              break;
                                      }
                                  }
                              }
                          }];
    } else {
        NSLog(@"不支持生物认证");
    }
}

+ (void)biometricsAuthentionWithCompleteHandle:(void(^)(BOOL success, NSInteger errorCode))handle {
    LAContext * context = [self supportBiometricsAuthentication];
    if (context) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"解锁设备"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              NSInteger errorCode = error.code;
                              if (success) {
                                  NSLog(@"认证成功");
                              } else {
                                  if (error) {
                                      switch (errorCode) {
                                          case LAErrorAuthenticationFailed:
                                              NSLog(@"认证失败");
                                              break;
                                          case kLAErrorUserCancel:
                                              NSLog(@"用户取消");
                                              break;
                                          case LAErrorUserFallback:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"用户不使用TouchID,选择手动输入密码");
                                              });
                                          }
                                              break;
                                          case LAErrorSystemCancel:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                                              });
                                          }
                                              break;
                                          case LAErrorPasscodeNotSet:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                                              });
                                          }
                                              break;
                                          case LAErrorTouchIDNotEnrolled:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                                              });
                                          }
                                              break;
                                          case LAErrorTouchIDNotAvailable:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"TouchID 无效");
                                              });
                                          }
                                              break;
                                          case LAErrorTouchIDLockout:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                                              });
                                          }
                                              break;
                                          case LAErrorAppCancel:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                                              });
                                          }
                                              break;
                                          case LAErrorInvalidContext:{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                                              });
                                          }
                                              break;
                                          default:
                                              break;
                                      }
                                  }
                              }
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (handle) {
                                      handle(success, errorCode);
                                  }
                              });
                          }];
    } else {
        NSLog(@"不支持生物认证");
    }
}

+ (BOOL)touchIDSupport {
    LAContext * context = [self supportBiometricsAuthentication];
    if (context) {
        if (@available(iOS 11.0, *)) {
            return context.biometryType == LABiometryTypeTouchID;
        } else {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)faceIDSupport {
    LAContext *context = [self supportBiometricsAuthentication];
    if (context) {
        if (@available(iOS 11.0, *)) {
            return context.biometryType == LABiometryTypeFaceID;
        }
    }
    return NO;
}

+ (BOOL)biomericsSupport {
    LAContext *context = [self supportBiometricsAuthentication];
    return context != nil;
}

+ (LAContext *)supportBiometricsAuthentication {
    LAContext *context = [LAContext new];
    NSError *error;
    BOOL canBiometrics = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                              error:&error];
    if (error == nil && canBiometrics) {
        return context;
    }
    return nil;
}

@end
