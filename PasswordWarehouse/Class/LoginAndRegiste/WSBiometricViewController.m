//
//  WSBiometricViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSBiometricViewController.h"
#import "WSPasswordLoginViewController.h"

@interface WSBiometricViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *touchIdLoginBtn;
@property (nonatomic, strong) UIButton    *otherLoginBtn;
@end

@implementation WSBiometricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.imageView   mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-60);
    }];
    [self.touchIdLoginBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.imageView.mas_bottom).offset(40);
    }];
    [self.otherLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
}

#pragma mark - lazyload

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_touchId"]];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(UIButton *)touchIdLoginBtn {
    if (!_touchIdLoginBtn) {
        _touchIdLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_touchIdLoginBtn setTitle:@"使用touchID登录" forState:UIControlStateNormal];
        [self.view addSubview:_touchIdLoginBtn];
         __weak typeof(self)weakSelf = self;
        [_touchIdLoginBtn bk_whenTapped:^{
            [WSTouchIDUtil biometricsAuthentionWithCompleteHandle:^(BOOL success, NSInteger errorCode) {
                if (success) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
    }
    return _touchIdLoginBtn;
}

- (UIButton *)otherLoginBtn {
    if (!_otherLoginBtn) {
        _otherLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_otherLoginBtn setTitle:@"使用其他方式登陆" forState:UIControlStateNormal];
        [self.view addSubview:_otherLoginBtn];
         __weak typeof(self)weakSelf = self;
        [_otherLoginBtn bk_whenTapped:^{
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                [WSPasswordLoginViewController showFromViewController:nil];
            }];
        }];
    }
    return _otherLoginBtn;
}

@end
