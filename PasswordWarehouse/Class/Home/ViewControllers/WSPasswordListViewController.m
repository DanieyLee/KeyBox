//
//  WSPasswordCategoryViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSPasswordListViewController.h"
#import "WSAddPasswordViewController.h"
#import "WSPasswordLoginViewController.h"
#import "WSBaseNavigationController.h"
#import "WSBaseTableView.h"
#import "WSMyPasswordListTableViewCell.h"
#import "WSAlertControllerUtil.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WSPasswordShowAlertView.h"

@interface WSPasswordListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MGSwipeTableCellDelegate>
@property (nonatomic, strong) WSBaseTableView       *tableView;
@property (nonatomic, strong) NSMutableArray        *dataSource;
@property (nonatomic, strong) UISearchBar           *searchBar;
@end

@implementation WSPasswordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadPasswordList];
    [self setupSubViews];
    self.title = @"密码仓库";
    UIBarButtonItem *rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    __weak typeof(self)weakSelf = self;
    self.tableView.refreshHeader = ^{
        [weakSelf loadPasswordList];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataChanged) name:kUserDataChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self)weakSelf = self;
    NSString * sql = [NSString stringWithFormat:@"select * from %@ order by id", TB_PASSWORD];
    [[DBManager sharedInstance] queryForList:sql
                                  parameters:nil handler:^(NSArray *array) {
                                      NSMutableArray *removeArrays = [NSMutableArray array];
                                      for (NSDictionary *dic in array) {
                                          NSString *updateState = [dic ws_stringForKey:kUploadState];
                                          if ([updateState isEqualToString:@"-2"]) {
                                              [removeArrays  addObject:dic];
                                          }
                                      }
                                      weakSelf.dataSource = [NSMutableArray arrayWithArray:array];
                                      [weakSelf.dataSource removeObjectsInArray:removeArrays];
                                      [weakSelf.tableView reloadData];
                                      [weakSelf showEmptyMsg:@"暂无数据\n请点击右上角添加数据" dataCount:weakSelf.dataSource.count];
                                  }];
}

- (void)setupSubViews {
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(64);
        }
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSMyPasswordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WSMyPasswordListTableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *rowInfo = [self.dataSource objectAtIndex:indexPath.row];
    cell.accountLab.text = [rowInfo  ws_stringForKey:@"name"];
    cell.password.text = [rowInfo ws_stringForKey:@"login"];
    cell.leftButtons = ({
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"编辑" backgroundColor:COLOR_RANDOM];
        @[button];
    });
    cell.rightButtons = ({
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:HexColor(0xFF0000)];
        @[button];
    });
    cell.delegate = self;
    cell.touchOnDismissSwipe = YES;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WSPasswordShowAlertView *alertView = [WSPasswordShowAlertView new];
    alertView.passwordInfo = [self.dataSource objectAtIndex:indexPath.row];
    [ActionSheetWindow showActionSheetView:alertView withDirection:ActionSheetViewAppearDirectionFromCenter completeHandle:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - MGSwipeTableCellDelegate

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    if (direction == MGSwipeDirectionLeftToRight) {
        WSAddPasswordViewController *vc = [WSAddPasswordViewController new];
        vc.viewType = PassWordViewTypeEdit;
        vc.passwordInfo = [self.dataSource objectAtIndex:[self.tableView indexPathForCell:cell].row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [WSAlertControllerUtil AlertControllerShowInViewController:self
                                                          delegate:self
                                                         withTitle:@"提示"
                                                           message:@"确认删除此条记录吗？"
                                                    preferredStyle:UIAlertControllerStyleAlert
                                                 cancelButtonTitle:@"否"
                                                otherButtonActions:@[@"delete:"]
                                             otherButtonParameters:@[indexPath]
                                                 otherButtonTitles:@"是", nil];
    }
    return YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *sql_ = [NSString stringWithFormat:@"alter table %@ add other text", TB_PASSWORD];
        [[DBManager sharedInstance] update:sql_ parameters:nil];
        sql_ = [NSString stringWithFormat:@"alert table %@ add address text", TB_PASSWORD];
        [[DBManager sharedInstance] update:sql_ parameters:nil];
    });
    
    NSString *keyword = searchBar.text;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", TB_PASSWORD];
    if (keyword != nil && keyword.length != 0) {
        NSString *query = [NSString stringWithFormat:@" WHERE login LIKE '%%%@%%' OR name LIKE '%%%@%%' OR other LIKE '%%%@%%' OR address LIKE '%%%@%%'", keyword, keyword, keyword, keyword];
        sql = [sql stringByAppendingString:query];
    }
     __weak typeof(self)weakSelf = self;
    [[DBManager sharedInstance] queryForList:sql parameters:nil handler:^(NSArray *array) {
        weakSelf.dataSource = [NSMutableArray arrayWithArray:array];
        [weakSelf.tableView reloadData];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBarSearchButtonClicked:searchBar];
}

#pragma mark - Actions

- (void)addBarButtonAction {
     __weak typeof(self)weakSelf = self;
    if (USER_TOKEN) {
        WSAddPasswordViewController *vc = [WSAddPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WSPasswordLoginViewController *vc = [WSPasswordLoginViewController new];
        vc.needLeftCancelItem = YES;
        WSBaseNavigationController *nav = [[WSBaseNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        vc.loginSuccess = ^{
            [weakSelf loadPasswordList];
        };
    }
}

- (void)appWillEnterForeground {
    WSPasswordLoginViewController *vc = [WSPasswordLoginViewController new];
    WSBaseNavigationController *nav = [[WSBaseNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)userDataChanged {
    [self loadPasswordList];
}

#pragma mark - Network

- (void)loadPasswordList {
     __weak typeof(self)weakSelf = self;
    [NSObject getWithRelativePath:URL_ITEMLIST
                         paramate:nil
                          success:^(NSDictionary * _Nonnull dic) {
                              if ([dic isKindOfClass:[NSArray class]]) {
                                  NSArray *list = (NSArray *)dic;
                                  self.dataSource = [NSMutableArray arrayWithArray:list];
                                  [self.tableView reloadData];
                                  [[DBManager sharedInstance] insertOrUpdateMapList:list
                                                                            forKeys:@[@"id"]
                                                                          tableName:TB_PASSWORD handler:^(int count) {
                                                                              NSLog(@"插入或更新%@条数据", @(count));
                                                                          }];
                                  [weakSelf showEmptyMsg:@"暂无数据\n请点击右上角添加数据" dataCount:self.dataSource.count];
                              }
                          } fail:^(NSError * _Nonnull error) {
                              [weakSelf showEmptyMsg:@"暂无数据\n请点击右上角添加数据" dataCount:self.dataSource.count];
                          } warning:^(NSString * _Nonnull waring) {
                              if ([waring isEqualToString:@"Unauthorized"]) {
                                  [weakSelf showNoRegisteLoginView];
                              } else {
                                  [weakSelf showAlertMessage:waring];
                              }
                          } complete:^{
                              [weakSelf.tableView.mj_header endRefreshing];
                          }];
}

- (void)delete:(NSIndexPath *)indexPath {
    NSDictionary *rowInfo = [self.dataSource objectAtIndex:indexPath.row];
    NSString *deleteId = [rowInfo ws_stringForKey:@"id"];
    if (deleteId.length == 0) {
        [self deleteLocalItemForIndexPath:indexPath];
        return;
    }
    [self showHudWithMessage:nil];
     __weak typeof(self)weakSelf = self;
    NSString *urlPath = [URL_ITEMDELETE stringByAppendingPathComponent:[rowInfo ws_stringForKey:@"id"]];
    [NSObject deleteWithRelativePath:urlPath paramate:nil
                             success:^(NSDictionary * _Nonnull dic) {
                                 NSString * sql = [NSString stringWithFormat:@"delete from %@ where id=?", TB_PASSWORD];
                                 [[DBManager sharedInstance] update:sql parameters:@[rowInfo[@"id"]]];
                                 [self.dataSource removeObjectAtIndex:indexPath.row];
                                 [self.tableView reloadData];
                             } fail:^(NSError * _Nonnull error) {
                                 [weakSelf deleteFailToClode:indexPath];
                             } warning:^(NSString * _Nonnull waring) {
                                 [weakSelf showAlertMessage:waring];
                                 [weakSelf deleteFailToClode:indexPath];
                             } complete:^{
                                 [weakSelf hideHudWithMessage:nil];
                                 [weakSelf showEmptyMsg:@"暂无数据\n请点击右上角添加数据" dataCount:self.dataSource.count];
                             }];
}

- (void)deleteLocalItemForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowInfo = [self.dataSource objectAtIndex:indexPath.row];
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where _id_=?", TB_PASSWORD];
    [[DBManager sharedInstance] update:sql parameters:@[rowInfo[keyForDatabaseId]]];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)deleteFailToClode:(NSIndexPath *)indexPath {
    NSDictionary *rowInfo = [self.dataSource objectAtIndex:indexPath.row];
    NSMutableDictionary *deleteInfo = [NSMutableDictionary dictionaryWithDictionary:rowInfo];
    [deleteInfo setObject:@"-2" forKey:kUploadState];
    [[DBManager sharedInstance] insertOrUpdateMap:deleteInfo forKeys:@[@"id"] tableName:TB_PASSWORD handler:^(sqlite3_int64 count) {
        
    }];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)showNoRegisteLoginView {
    ZAEmptyStyle *style = [ZAEmptyStyle new];
    style.refreshStyle = RefreshClickOnBtnStyle;
    style.btnTipText = @"立即注册";
    style.tipText = @"暂无数据";
    style.btnTitleColor = COLOUR_THEME;
    style.btnLayerBorderColor = COLOR_999;
    style.imageConfig.imageData = @"icon_empty";
    style.imageOragionY = 0.4;
     __weak typeof(self)weakSelf = self;
    style.btnAction = ^{
        WSPasswordLoginViewController *vc = [WSPasswordLoginViewController showFromViewController:weakSelf];
        vc.needLeftCancelItem = YES;
        vc.loginSuccess = ^{
            [weakSelf loadPasswordList];
        };
    };
    [self showWithStyle:style];
}

#pragma mark - lazyload

- (WSBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WSBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WSMyPasswordListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WSMyPasswordListTableViewCell class])];
        _tableView.estimatedRowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.01)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.01)];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        [self.view addSubview:_searchBar];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = COLOR_BG;
        _searchBar.backgroundImage = [UIImage new];
        UITextField *searchField= [_searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor =[UIColor colorWithRed:240 / 255.0 green:240 /255.0 blue:240 /255.0 alpha:1];
        searchField.placeholder = @"请输入搜索的关键词";
        [searchField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
            [textField resignFirstResponder];
            return YES;
        }];
    }
    return _searchBar;
}


@end
