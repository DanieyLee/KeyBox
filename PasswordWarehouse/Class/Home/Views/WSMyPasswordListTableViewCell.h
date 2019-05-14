//
//  WSMyPasswordListTableViewCell.h
//  PasswordWarehouse
//
//  Created by NN on 2018/12/27.
//  Copyright © 2018 WeiSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSMyPasswordListTableViewCell : MGSwipeTableCell

@property (nonatomic, strong, readonly) UILabel   *accountLab;
@property (nonatomic, strong, readonly) UILabel   *password;
@property (nonatomic, strong, readonly) UILabel   *nameLab;

@end

NS_ASSUME_NONNULL_END
