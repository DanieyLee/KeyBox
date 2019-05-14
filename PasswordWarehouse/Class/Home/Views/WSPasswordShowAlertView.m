//
//  WSPasswordShowAlertView.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/25.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSPasswordShowAlertView.h"
#import "WSTitleTextFieldTableViewCell.h"
#import "WSBaseButton.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface WSPasswordShowAlertView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSArray               *sectionsArr;
@end

@implementation WSPasswordShowAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(SCALE_L(SCREEN_WIDTH - 40), 44 * 6));
    }];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSTitleTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WSTitleTextFieldTableViewCell class]) forIndexPath:indexPath];
    NSDictionary *rowInfo = [self.sectionsArr objectAtIndex:indexPath.row];
    NSString *key = [rowInfo objectForKey:@"key"];
    cell.contentInfo = rowInfo;
    [cell.textFieldView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
    }];
    cell.textFieldView.textField.text = [self.passwordInfo ws_stringForKey:key];
    cell.textFieldView.textField.bk_shouldBeginEditingBlock = ^BOOL(UITextField *textField) {
        return NO;
    };
     __weak typeof(self)weakSelf = self;
    cell.textFieldView.textField.rightView = nil;
    cell.textFieldView.textField.rightViewMode = UITextFieldViewModeNever;
    if (![key isEqualToString:@"name"] && ![key isEqualToString:@"other"]) {
        if ([weakSelf.passwordInfo ws_stringForKey:key] && [[weakSelf.passwordInfo ws_stringForKey:key] length] == 0) {
        } else {
            cell.textFieldView.textField.rightView = ({
                WSBaseButton *button = [WSBaseButton buttonWithType:UIButtonTypeSystem];
                button.title = @"复制";
                button.frame = CGRectMake(0, 0, 40, 44);
                [button bk_whenTapped:^{
                    [weakSelf copyActionWithKey:key];
                }];
                button;
            });
            cell.textFieldView.textField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - Actions

- (void)copyActionWithKey:(NSString *)key {
    NSString *value = [self.passwordInfo objectForKey:key];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = value;
    [[ActionSheetWindow sharedInstace].actionSheetViewController showAlertMessage:@"已复制到剪切板"];
}

#pragma mark - lazyload

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WSTitleTextFieldTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WSTitleTextFieldTableViewCell class])];
    }
    return _tableView;
}

- (NSArray *)sectionsArr {
    if (!_sectionsArr) {
        _sectionsArr = @[
                         @{
                             @"key" : @"name",
                             @"title" : @"标题",
                             },
                         @{
                             @"key" : @"login",
                             @"title" : @"用户名",
                             },
                         @{
                             @"key" : @"passwordtext",
                             @"title" : @"密码",
                             },
                         @{
                             @"key" : @"levelpasswordtext",
                             @"title" : @"二级密码",
                             },
                         @{
                             @"key" : @"address",
                             @"title" : @"地址",
                             },
                         @{
                             @"key" : @"other",
                             @"title" : @"描述",
                             },
                         ];
    }
    return _sectionsArr;
}

@end
