//
//  WSMyPasswordListTableViewCell.m
//  PasswordWarehouse
//
//  Created by NN on 2018/12/27.
//  Copyright © 2018 WeiSen. All rights reserved.
//

#import "WSMyPasswordListTableViewCell.h"

@interface WSMyPasswordListTableViewCell ()
@property (nonatomic, strong) UILabel   *accountLab;
@property (nonatomic, strong) UILabel   *password;
@property (nonatomic, strong) UILabel   *nameLab;
@end

@implementation WSMyPasswordListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.lessThanOrEqualTo(self.nameLab.mas_left).offset(-8);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountLab);
        make.bottom.mas_equalTo(-10);
        make.top.equalTo(self.accountLab.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.nameLab.mas_left).offset(-8);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_greaterThanOrEqualTo(100).priorityHigh();
    }];
}

#pragma mark - lazyload

- (UILabel *)accountLab {
    if (!_accountLab) {
        _accountLab = [UILabel new];
        [self.contentView addSubview:_accountLab];
        _accountLab.font = [UIFont systemFontOfSize:15];
        _accountLab.textColor = [UIColor grayColor];
    }
    return _accountLab;
}

- (UILabel *)password {
    if (!_password) {
        _password = [UILabel new];
        [self.contentView addSubview:_password];
        _password.font = [UIFont systemFontOfSize:15];
        _password.textColor = [UIColor grayColor];
    }
    return _password;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        [self.contentView addSubview:_nameLab];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.textAlignment = NSTextAlignmentRight;
    }
    return _nameLab;
}

@end
