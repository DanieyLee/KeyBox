//
//  WSTouchIDUtil.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSTouchIDUtil : NSObject

+ (BOOL)touchIDSupport;

+ (BOOL)faceIDSupport;

+ (BOOL)biomericsSupport;

+ (void)biometricsAuthentionWithCompleteHandle:(void(^)(BOOL success, NSInteger errorCode))handle;

@end

NS_ASSUME_NONNULL_END
