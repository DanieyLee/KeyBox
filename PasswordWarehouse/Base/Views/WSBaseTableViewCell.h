//
//  ZABaseTableViewCell.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/26.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBaseTableViewCell : UITableViewCell

/**
 唯一标识
 */
@property (nonatomic, copy  ) NSString      *key;

/**
 距离边框距离
 */
@property (nonatomic, assign) UIEdgeInsets  contentEdgeInset;


@property (nonatomic, strong, readonly) UIView     *contentInsetView;

/**
 设置子类视图
 */
- (void)setupSubViews;

/**
 设置底部分隔线显示和边距
@param  show 是否显示
 @param inserts 边距
 */
- (void)bottomLineshow:(BOOL)show
            withInsets:(UIEdgeInsets)inserts;


@end
