//
//  WSAddPasswordViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSAddPasswordViewController.h"
#import "WSTitleTextFieldTableViewCell.h"

@interface WSAddPasswordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSArray               *sectionsArr;
@property (nonatomic, strong) NSMutableDictionary   *parameters;
@end

@implementation WSAddPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupNav {
    NSString *title, *rightBarTitle;
    switch (self.viewType) {
        case PassWordViewTypeAdd: {
            title = @"新增";
            rightBarTitle = @"保存";
        }
            break;
        case PassWordViewTypeShow: {
            title = self.passwordInfo[@"name"];
            rightBarTitle = @"编辑";
            self.parameters = [NSMutableDictionary dictionaryWithDictionary:self.passwordInfo];
        }
            break;
        case PassWordViewTypeEdit: {
            title = self.passwordInfo[@"name"];
            rightBarTitle = @"保存";
            self.parameters = [NSMutableDictionary dictionaryWithDictionary:self.passwordInfo];
        }
            break;
        default:
            break;
    }
    self.title = title;
    UIBarButtonItem *rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:rightBarTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
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
     __weak typeof(self)weakSelf = self;
    cell.contentInfo = rowInfo;
    cell.textFieldView.textField.placeholder = (_viewType == PassWordViewTypeShow ? @"" : [NSString stringWithFormat:@"请输入%@", rowInfo[@"title"]]);
    cell.textFieldView.textFieldDidEndEditingText = ^(UITextField * _Nonnull textField) {
        [weakSelf.parameters setObject:textField.text forKey:rowInfo[@"key"]];
    };
    [cell.textFieldView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
    }];
    cell.textFieldView.textField.text = [self.parameters ws_stringForKey:key];
    cell.textFieldView.textField.userInteractionEnabled = (self.viewType != PassWordViewTypeShow);
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

#pragma mark - network

- (void)save {
    [self.view endEditing:YES];
    if (![self vertifySuccess]) {
        return;
    }
    [self showHudWithMessage:nil];
     __weak typeof(self)weakSelf = self;
    [NSObject postWithRelativePath:URL_ADDITEM
                          paramate:self.parameters
                           success:^(NSDictionary * _Nonnull dic) {
                               [[DBManager sharedInstance] insertOrUpdateMap:dic forKeys:@[@"id"] tableName:TB_PASSWORD handler:nil];
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           } fail:^(NSError * _Nonnull error) {
                               [weakSelf saveFailToCloud];
                           } warning:^(NSString * _Nonnull waring) {
                               [weakSelf showAlertMessage:waring];
                           } complete:^{
                               [weakSelf hideHudWithMessage:nil];
                           }];
}
//云存储失败
- (void)saveFailToCloud {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [parameters setObject:@"-1" forKey:kUploadState];
    [[DBManager sharedInstance] insertMap:parameters tableName:TB_PASSWORD handler:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//云修改失败
- (void)modifyFailToCloud {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [parameters setObject:@"-1" forKey:kUploadState];
    [[DBManager sharedInstance] insertOrUpdateMap:parameters forKeys:@[@"id"] tableName:TB_PASSWORD handler:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modify {
    [self.view endEditing:YES];
    if (![self vertifySuccess]) {
        return;
    }
    [self showHudWithMessage:nil];
    __weak typeof(self)weakSelf = self;
    [NSObject putWithRelativePath:URL_ITEMEDITE
                          paramate:self.parameters
                           success:^(NSDictionary * _Nonnull dic) {
                               [[DBManager sharedInstance] insertOrUpdateMap:dic forKeys:@[@"id"] tableName:TB_PASSWORD handler:nil];
                               [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                           } fail:^(NSError * _Nonnull error) {
                               [weakSelf modifyFailToCloud];
                           } warning:^(NSString * _Nonnull waring) {
                               [weakSelf showAlertMessage:waring];
                           } complete:^{
                               [weakSelf hideHudWithMessage:nil];
                           }];
}

- (BOOL)vertifySuccess {
    for (NSDictionary *rowInfo in self.sectionsArr) {
        NSString *key = rowInfo[@"key"];
        NSString *title = rowInfo[@"title"];
        if ([key isEqualToString:@"name"] || [key isEqualToString:@"login"]) {
            NSString *value = [self.parameters ws_stringForKey:key];
            if (value.length == 0) {
                [self showAlertMessage:[title stringByAppendingString:@"不能为空"]];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Actions

- (void)rightBarButtonAction {
    switch (self.viewType) {
        case PassWordViewTypeAdd:
            [self save];
            break;
        case PassWordViewTypeShow: {
            WSAddPasswordViewController *vc = [WSAddPasswordViewController new];
            vc.viewType = PassWordViewTypeEdit;
            vc.passwordInfo = self.passwordInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PassWordViewTypeEdit:
            [self modify];
            break;
        default:
            break;
    }
}

#pragma mark - lazyload

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
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


- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

@end



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 {
 "address": "string",
 "levelpasswordtext": "string",//二级密码
 "login": "string",
 "name": "string",//类型
 "other": "string",
 "passwordtext": "string",
 }
 }
 */
