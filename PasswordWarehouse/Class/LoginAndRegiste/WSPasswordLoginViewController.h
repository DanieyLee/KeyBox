//
//  WSPasswordLoginViewController.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSPasswordLoginViewController : WSBaseViewController

+ (instancetype)showFromViewController:(nullable UIViewController *)viewController;

@property (nonatomic, copy  ) void(^inputPasswordWithResult)(BOOL passwordCorrect);

@property (nonatomic, copy  ) void(^loginSuccess)(void);

@property (nonatomic, assign) BOOL      needLeftCancelItem;

@end

NS_ASSUME_NONNULL_END
