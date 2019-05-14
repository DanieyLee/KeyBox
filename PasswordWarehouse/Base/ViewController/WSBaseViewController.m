//
//  WSBaseViewController.m
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import "WSBaseViewController.h"
#import "MBProgressHUD.h"
#import <Toast/Toast.h>

@interface WSBaseViewController ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger              hudCount;
@end

@implementation WSBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HexColor(0xFAFAFA);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActivity) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //过滤掉子控制器的情况
    if ([self.navigationController.viewControllers containsObject:self]) {
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
    }
    self.navigationController.navigationBar.translucent = self.navigationBarTranslucent;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

- (void)showAlertMessage:(NSString *)message {
    if (!message || message.length == 0) {
        return;
    }
    UIView *showHudView = self.navigationController.view;
    if (showHudView == nil) {
        showHudView = self.view;
    }
    //
    [showHudView hideAllToasts];
    dispatch_async(dispatch_get_main_queue(), ^{
        [showHudView makeToast:message
                      duration:1.0
                      position:CSToastPositionCenter
                         title:nil
                         image:nil
                         style:nil
                    completion:nil];
        
    });
}

- (void)showAlertMessage:(NSString *)message
          completeHandle:(void(^)(void))handle
{
    if (!message || message.length == 0) {
        return;
    }
    [self.navigationController.view makeToast:message
                                     duration:1.0
                                     position:CSToastPositionCenter
                                        title:nil
                                        image:nil
                                        style:nil
                                   completion:^(BOOL didTap) {
                                       if (handle) {
                                           handle();
                                       }
                                   }];
}

- (void)showHudWithMessage:(NSString *)message {
    if (_hudCount == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (message && message.length != 0) {
            hud.label.text = message;
        }
        CGPoint center = hud.center;
        //        center.y = SCREEN_HEIGHT  * (1 - 0.618);
        hud.center = center;
    }
    _hudCount++;
}

- (void)hideHudWithMessage:(NSString *)message {
    _hudCount--;
    _hudCount = (_hudCount > 0 ? : 0);
    if (_hudCount == 0) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (message && message.length != 0) {
            hud.label.text = message;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark Lazyload

- (NSMutableArray *)requestArray {
    if (!_requestArray) {
        _requestArray = [NSMutableArray array];
    }
    return _requestArray;
}

#pragma mark Actions

- (void)appDidBecomeActivity {
    
}

@end
