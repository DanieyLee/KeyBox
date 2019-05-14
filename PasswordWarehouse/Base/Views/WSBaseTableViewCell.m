//
//  ZABaseTableViewCell.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/26.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "WSBaseTableViewCell.h"

@interface WSBaseTableViewCell()
@property (nonatomic, strong) UIView     *bottomSeparateLine;
@property (nonatomic, strong) UIView     *contentInsetView;
@end

@implementation WSBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentInsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.bottomSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setContentEdgeInset:(UIEdgeInsets)contentEdgeInset {
    _contentEdgeInset = contentEdgeInset;
    [self.contentInsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentEdgeInset);
    }];
}

- (void)bottomLineshow:(BOOL)show
            withInsets:(UIEdgeInsets)inserts {
    self.bottomSeparateLine.hidden = !show;
    [self.bottomSeparateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inserts.left);
        make.right.mas_equalTo(-inserts.right);
    }];
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [UIView ws_createViewWithColor:COLOR_DDD];
        [self.contentView addSubview:_bottomSeparateLine];
        _bottomSeparateLine.hidden = YES;
    }
    return _bottomSeparateLine;
}

- (UIView *)contentInsetView {
    if (!_contentInsetView) {
        _contentInsetView = [UIView new];
        [self.contentView addSubview:_contentInsetView];
    }
    return _contentInsetView;
}

@end
