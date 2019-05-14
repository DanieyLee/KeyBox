//
//  WSPasswordUploadUtil.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/20.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSPasswordUploadUtil : NSObject

+ (instancetype)sharedPasswordUploadUtil;

- (void)startUpload;

@end

NS_ASSUME_NONNULL_END
