//
//  WSTitleTextFieldTableViewCell.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSTitleTextFieldTableViewCell.h"

@interface WSTitleTextFieldTableViewCell ()
@property (nonatomic, strong) WSTextFieldView       *textFieldView;
@end

@implementation WSTitleTextFieldTableViewCell

- (void)setupSubViews {
    [super setupSubViews];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setContentInfo:(NSDictionary *)contentInfo {
    _contentInfo = contentInfo;
    self.textFieldView.title = [contentInfo ws_stringForKey:@"title"];
}

#pragma mark - lazyload

- (WSTextFieldView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [WSTextFieldView new];
        [self.contentView addSubview:_textFieldView];
    }
    return _textFieldView;
}

@end
