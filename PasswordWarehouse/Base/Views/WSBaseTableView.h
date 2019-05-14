//
//  WSBaseTableView.h
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSBaseTableView : UITableView
/**
 是否需要底部安全去，默认为YES, 仅对iOS11.0有效
 */
@property (nonatomic, assign) BOOL   needBottomSafeArea;
/**
 下拉控件
 */
@property (nonatomic, copy) void(^refreshHeader)(void);

/**
 上拉控件
 */
@property (nonatomic, copy) void(^refreshFooter)(void);

/**
 上拉和下啦刷新控件
 isHeader表示是否是下拉控件在操作
 */
@property (nonatomic, copy) void(^refreshWidget)(BOOL isHeader);

/**
 是否正在刷新
 */
@property (nonatomic, assign) BOOL  isRefresh;

/**
 tableView注册headerFooterView，或者cell
 @param classArray 注册的类
 */
- (void)registClass:(NSArray <Class>*)classArray;
@end

NS_ASSUME_NONNULL_END
