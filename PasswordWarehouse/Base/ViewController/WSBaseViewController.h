//
//  WSBaseViewController.h
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ShowEmpty.h"

@interface WSBaseViewController : UIViewController
//是否隐藏导航条，默认NO
@property (nonatomic, assign) BOOL navigationBarHidden;
//是否隐藏状态栏，默认NO
@property (nonatomic, assign) BOOL statusBarHidden;
//是否半透明导航栏，默认NO
@property (nonatomic, assign) BOOL navigationBarTranslucent;
//请求数组
@property (nonatomic, strong) NSMutableArray    *requestArray;
//底部safeArea颜色
@property (nonatomic, strong) UIColor           *bottomSafeAreaColor;
//显示提示信息
- (void)showAlertMessage:(NSString *)message;
- (void)showAlertMessage:(NSString *)message
          completeHandle:(void(^)(void))handle;
//展示加载的显示器
- (void)showHudWithMessage:(NSString *)message;
//隐藏显示器
- (void)hideHudWithMessage:(NSString *)message;
//app变得活跃
- (void)appDidBecomeActivity;

@end

