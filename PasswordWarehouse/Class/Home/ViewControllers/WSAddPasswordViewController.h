//
//  WSAddPasswordViewController.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSBaseViewController.h"

typedef NS_ENUM(NSUInteger, PassWordViewType) {
    PassWordViewTypeAdd,
    PassWordViewTypeShow,
    PassWordViewTypeEdit,
};

NS_ASSUME_NONNULL_BEGIN

@interface WSAddPasswordViewController : WSBaseViewController

@property (nonatomic, assign) PassWordViewType   viewType;

@property (nonatomic, copy  ) NSDictionary      *passwordInfo;

@end

NS_ASSUME_NONNULL_END
