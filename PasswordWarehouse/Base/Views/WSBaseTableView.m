//
//  WSBaseTableView.m
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import "WSBaseTableView.h"
#import "UIScrollView+MJRefresh.h"

@implementation WSBaseTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame  style:style];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)setupConfig {
    self.needBottomSafeArea = YES;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.backgroundColor = COLOR_BG;
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.01)];
    self.separatorColor = COLOR_F1EEEF;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)) {
        if (self.needBottomSafeArea) {
            UIEdgeInsets inserts = self.contentInset;
            inserts.bottom += self.superview.safeAreaInsets.bottom;
            self.contentInset = inserts;
        }
    }
}

- (void)setRefreshHeader:(void (^)(void))refreshHeader {
    _refreshHeader = refreshHeader;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (refreshHeader) {
                refreshHeader();
            }
        }];
}

- (void)setRefreshFooter:(void (^)(void))refreshFooter {
    _refreshFooter = refreshFooter;
        self.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            if (refreshFooter) {
                refreshFooter();
            }
        }];
}

- (void)setRefreshWidget:(void (^)(BOOL))refreshWidget {
    _refreshWidget = refreshWidget;
    self.refreshHeader = ^{
        if (refreshWidget) {
            refreshWidget(YES);
        }
    };
    self.refreshFooter = ^{
        if (refreshWidget) {
            refreshWidget(NO);
        }
    };
}

- (void)registClass:(NSArray <Class>*)classArray {
    for (Class className in classArray) {
        NSString *classStr = NSStringFromClass(className);
        NSString *path = [[NSBundle mainBundle] pathForResource:classStr ofType:@"nib"];
        if ([className isSubclassOfClass:[UITableViewCell class]]) {
            if (path) {
                [self registerNib:[UINib nibWithNibName:classStr bundle:nil] forCellReuseIdentifier:classStr];
            } else {
                [self registerClass:className forCellReuseIdentifier:classStr];
            }
        }
        if ([className isSubclassOfClass:[UITableViewHeaderFooterView class]]) {
            if (path) {
                [self registerNib:[UINib nibWithNibName:classStr bundle:nil] forHeaderFooterViewReuseIdentifier:classStr];
            } else {
                [self registerClass:className forHeaderFooterViewReuseIdentifier:classStr];
            }
        }
    }
}


- (BOOL)isRefresh {
    //    return (self.mj_header.state == MJRefreshStateRefreshing || self.mj_footer.state == MJRefreshStateRefreshing);
    return self.isRefresh;
}

@end
