//
//  WSTitleTextFieldTableViewCell.h
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSBaseTableViewCell.h"
#import "WSTextFieldView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSTitleTextFieldTableViewCell : WSBaseTableViewCell


@property (nonatomic, strong, readonly) WSTextFieldView       *textFieldView;

@property (nonatomic, strong) NSDictionary   *contentInfo;

@end

NS_ASSUME_NONNULL_END
