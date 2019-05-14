//
//  WSPasswordLoginViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSPasswordLoginViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WSRegisteViewController.h"
#import "WSTextFieldView.h"
#import "WSTouchIDUtil.h"

@interface WSPasswordLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) WSTextFieldView       *accountTF;
@property (nonatomic, strong) WSTextFieldView       *passwordTF;
@property (nonatomic, strong) UIButton              *loginBtn;
@property (nonatomic, strong) UIButton              *registBtn;
@property (nonatomic, strong) UIButton              *touchIdLoginBtn;
@end

@implementation WSPasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(10);
    }];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.accountTF.mas_bottom);
        make.height.left.equalTo(self.accountTF);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(50);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(50);
        make.height.mas_equalTo(44);
    }];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(10);
        make.right.equalTo(self.loginBtn);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    UIView *centerLine = [UIView ws_createViewWithColor:COLOR_EBEBEB];
    [self.view addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.accountTF.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    UIView *bottomLine = [UIView ws_createViewWithColor:COLOR_EBEBEB];
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(centerLine);
        make.top.equalTo(self.passwordTF.mas_bottom);
    }];
    
    if (USER_TOKEN && [WSTouchIDUtil touchIDSupport]) {
        [self.touchIdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.registBtn.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
    }
    
    if (self.needLeftCancelItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (USER_TOKEN && [WSTouchIDUtil touchIDSupport]) {
         __weak typeof(self)weakSelf = self;
        [WSTouchIDUtil biometricsAuthentionWithCompleteHandle:^(BOOL success, NSInteger errorCode) {
            if (success) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

+ (instancetype)showFromViewController:(UIViewController *)viewController {
    WSPasswordLoginViewController *vc = [self new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    if (viewController == nil) viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [viewController presentViewController:nav animated:YES completion:nil];
    return vc;
}

#pragma mark - Network

- (void)login {
    [self.view endEditing:YES];
    [self showHudWithMessage:nil];
     __weak typeof(self)weakSelf = self;
    [NSObject postWithRelativePath:URL_LOGIN
                          paramate:@{@"username":self.accountTF.textField.text, @"password": self.passwordTF.textField.text, @"rememberMe": @"true"}
                           success:^(NSDictionary * _Nonnull dic) {
                               if (weakSelf.navigationController.presentingViewController) {
                                   [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                               } else {
                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                               }
                               [USERDEFAULT setObject:dic[@"id_token"] forKey:kUserTocken];
                               [USERDEFAULT synchronize];
                               if (weakSelf.loginSuccess) {
                                   weakSelf.loginSuccess();
                               }
                               [USERDEFAULT setObject:self.accountTF.textField.text forKey:kUserLoginName];
                               [USERDEFAULT synchronize];
                               [weakSelf showAlertMessage:@"登陆成功"];
                           } fail:^(NSError * _Nonnull error) {
                               [weakSelf showAlertMessage:@"登陆失败"];
                           } warning:^(NSString * _Nonnull waring) {
                               [weakSelf showAlertMessage:@"登陆失败"];
                           } complete:^{
                               [weakSelf hideHudWithMessage:nil];
                           }];
}

#pragma mark - Actions

- (void)cancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazyload

- (WSTextFieldView *)accountTF {
    if (!_accountTF) {
        _accountTF = [WSTextFieldView new];
        [self.view addSubview:_accountTF];
        _accountTF.textField.placeholder = @"请输入手机号";
        _accountTF.inputReg = @"^1[0-9]{0,10}$";
        _accountTF.vertifyReg = REG_PHONE;
        _accountTF.textField.keyboardType = UIKeyboardTypeNumberPad;
        NSString *account = [USERDEFAULT stringForKey:kUserLoginName];
        _accountTF.textField.text = account;
    }
    return _accountTF;
}

- (WSTextFieldView *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [WSTextFieldView new];
//        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:_passwordTF];
        _passwordTF.textField.returnKeyType = UIReturnKeyDone;
        _passwordTF.textField.secureTextEntry = YES;
        _passwordTF.textField.delegate = self;
        _passwordTF.textField.placeholder = @"请输入密码";
        _passwordTF.textField.keyboardType = UIKeyboardTypeAlphabet;
        _passwordTF.inputReg = @"^.{6,}$";
         __weak typeof(self)weakSelf = self;
        [_passwordTF.textField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
            if (textField.text.length < 6) {
                [weakSelf showAlertMessage:@"登陆密码不能少于6位"];
            }
            return YES;
        }];
    }
    return _passwordTF;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_loginBtn];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = COLOUR_THEME;
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
         __weak typeof(self)weakSelf = self;
        [_loginBtn bk_whenTapped:^{
            if (weakSelf.accountTF.textField.text.length == 0) {
                [weakSelf showAlertMessage:@"账号不能为空"];
            } else if (weakSelf.passwordTF.textField.text.length == 0) {
                [weakSelf showAlertMessage:@"密码不能为空"];
            } else {
                [weakSelf login];
            }
        }];
    }
    return _loginBtn;
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_registBtn];
        [_registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
         __weak typeof(self)weakSelf = self;
        [_registBtn bk_whenTapped:^{
            WSRegisteViewController *vc = [WSRegisteViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _registBtn;
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
@end

