//
//  WSMineViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSMineViewController.h"
#import "WSPasswordLoginViewController.h"
#import "WSChangePasswordViewController.h"

@interface WSMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSArray           *sectionsArr;
@end

@implementation WSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *secitonInfo = [self.sectionsArr objectAtIndex:section];
    NSArray *rows = [secitonInfo objectForKey:@"rows"];
    return rows ? rows.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSDictionary *secitonInfo = [self.sectionsArr objectAtIndex:indexPath.section];
    NSArray *rows = [secitonInfo objectForKey:@"rows"];
    if (rows.count > indexPath.row) {
        NSDictionary *rowInfo = [rows objectAtIndex:indexPath.row];
        NSString *title = [rowInfo objectForKey:@"title"];
        NSString *key = [rowInfo objectForKey:@"key"];
        cell.textLabel.text = title;
         __weak typeof(self)weakSelf = self;
        if ([key isEqualToString:@"passwordAccess"] || [key isEqualToString:@"TouchID"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = ({
                UISwitch *switchView = [UISwitch new];
                [switchView addTarget:weakSelf action:@selector(switchButtonChanged:) forControlEvents:UIControlEventValueChanged];
                switchView.tag = indexPath.section * 100 + indexPath.row;
                BOOL switchState = NO;
                if ([key isEqualToString:@"passwordAccess"]) {
                    switchState = [WSConfigeManager sharedConfigeManager].passcodeAccess;
                } else if ([key isEqualToString:@"TouchID"]) {
                    switchState = [WSConfigeManager sharedConfigeManager].touchIDAccess;
                }
                switchView.on = switchState;
                switchView;
            });
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *secitonInfo = [self.sectionsArr objectAtIndex:section];
    NSString *title = [secitonInfo objectForKey:@"title"];
    return title;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WSChangePasswordViewController *vc = [WSChangePasswordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - switchButtonChanged

- (void)switchButtonChanged:(UISwitch *)switchView {
     __weak typeof(self)weakSelf = self;
    NSInteger tag = switchView.tag;
    NSInteger section = tag / 100;
    NSInteger row = tag % 100;
    NSDictionary *rowInfo = [[[self.sectionsArr objectAtIndex:section] objectForKey:@"rows"] objectAtIndex:row];
    NSString *key = [rowInfo objectForKey:@"key"];
    BOOL featureOn = [self acquireCurrentStateWithKey:key];
    if ([key isEqualToString:@"passwordAccess"]) {
        if (featureOn == NO) {
            WSPasswordLoginViewController *vc = [WSPasswordLoginViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            vc.inputPasswordWithResult = ^(BOOL passwordCorrect) {
                if (passwordCorrect) {
                    [WSConfigeManager sharedConfigeManager].passcodeAccess = YES;
                    [weakSelf.tableView reloadData];
                }
            };
        } else {
            [WSConfigeManager sharedConfigeManager].passcodeAccess = NO;
        }
    } else if ([key isEqualToString:@"TouchID"]) {
        [WSConfigeManager sharedConfigeManager].touchIDAccess = !featureOn;
    }
    [_tableView reloadData];
}

- (BOOL)acquireCurrentStateWithKey:(NSString *)key {
    WSConfigeManager *manager = [WSConfigeManager sharedConfigeManager];
    if ([key isEqualToString:@"passwordAccess"]) {
        return manager.passcodeAccess;
    } else if ([key isEqualToString:@"TouchID"]) {
        return manager.touchIDAccess;
    }
    return NO;
}

#pragma mark - lazyload

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (NSArray *)sectionsArr {
    if (!_sectionsArr) {
        _sectionsArr = @[
                         @{
                             @"key" : @"security",
                             @"title" : @"安全",
                             @"rows" : @[
                                     @{
                                         @"key" : @"passwordAccess",
                                         @"title" : @"启动密码功能",
                                         @"feature" : @(WSConfigeFeaturesPasscodeAccess),
                                         },
                                     @{
                                         @"key" : @"TouchID",
                                         @"title" : @"Touch ID",
                                         @"feature" : @(WSConfigeFeaturesTouchIDAccess),
                                         },
                                     @{
                                         @"key" : @"changePassword",
                                         @"title" : @"更改密码",
//                                         @"feature" : @(WSConfigeFeaturesTouchIDAccess),
                                         },
                                     ],
                             }
                         ];
    }
    return _sectionsArr;
}

@end
