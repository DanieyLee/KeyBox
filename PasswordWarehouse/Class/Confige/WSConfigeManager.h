//
//  WSConfigeManager.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WSConfigeFeatures) {
    WSConfigeFeaturesPasscodeAccess = 1,//启动密码功能
    WSConfigeFeaturesTouchIDAccess,//是否开启touchID
};

@interface WSConfigeManager : NSObject

@property (nonatomic, assign) BOOL passcodeAccess;

@property (nonatomic, assign) BOOL touchIDAccess;

+ (instancetype)sharedConfigeManager;

@end

NS_ASSUME_NONNULL_END
