//
//  WSRegisteViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/19.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSRegisteViewController.h"
#import "WSWebViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WSTextFieldView.h"

@interface WSRegisteViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) WSTextFieldView       *accountTF;
@property (nonatomic, strong) WSTextFieldView       *passwordTF;
@property (nonatomic, strong) UIButton              *registBtn;
@property (nonatomic, strong) UIButton              *policBtn;
@end

@implementation WSRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
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
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(50);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(80);
        make.height.mas_equalTo(44);
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
    [self.policBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.registBtn.mas_top).offset(-20);
        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Network

- (void)registUser {
    [self.view endEditing:YES];
    [self showHudWithMessage:nil];
     __weak typeof(self)weakSelf = self;
    [NSObject postWithRelativePath:URL_REGISTE
                          paramate:@{@"login":self.accountTF.textField.text, @"password":self.passwordTF.textField.text}
                           success:^(NSDictionary * _Nonnull dic) {
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                               [weakSelf showAlertMessage:@"注册成功"];
                               [USERDEFAULT setObject:self.accountTF.textField.text forKey:kUserLoginName];
                               [USERDEFAULT synchronize];
                           } fail:^(NSError * _Nonnull error) {
                               [weakSelf showAlertMessage:@"注册失败"];
                           } warning:^(NSString * _Nonnull waring) {
//                               [weakSelf showAlertMessage:waring];
                               [weakSelf showAlertMessage:@"注册失败"];
                           } complete:^{
                               [weakSelf hideHudWithMessage:nil];
                           }];
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
                [weakSelf showAlertMessage:@"密码不能少于6位"];
            }
            return YES;
        }];
        _passwordTF.textFieldDidEndEditingText = ^(UITextField * _Nonnull textField) {
            if (textField.text.length < 6) {
                [weakSelf showAlertMessage:@"密码不能少于6位"];
            }
        };
    }
    return _passwordTF;
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_registBtn];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registBtn.backgroundColor = COLOUR_THEME;
        _registBtn.layer.cornerRadius = 4;
        _registBtn.layer.masksToBounds = YES;
         __weak typeof(self)weakSelf = self;
        [_registBtn bk_whenTapped:^{
            if (weakSelf.accountTF.textField.text.length == 0) {
                [weakSelf showAlertMessage:@"账号不能为空"];
            } else if (weakSelf.passwordTF.textField.text.length == 0) {
                [weakSelf showAlertMessage:@"密码不能为空"];
            } else if (weakSelf.passwordTF.textField.text.length < 6) {
                [weakSelf showAlertMessage:@"密码不能少于6位"];
            } else {
                [weakSelf registUser];
            }
        }];
    }
    return _registBtn;
}

- (UIButton *)policBtn {
    if (!_policBtn) {
        _policBtn = [UIButton new];
        [self.view addSubview:_policBtn];
        NSString *allString = @"我已阅读并接受<用户服务协议>中所明确的事项";
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:allString attributes:@{NSFontAttributeName : FONT(14), NSForegroundColorAttributeName : COLOR_333}];
        NSRange range = [allString rangeOfString:@"<用户服务协议>"];
        [aString addAttribute:NSForegroundColorAttributeName value:COLOUR_THEME range:range];
        [aString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        [_policBtn setAttributedTitle:aString forState:UIControlStateNormal];
        _policBtn.titleLabel.numberOfLines = 0;
         __weak typeof(self)weakSelf = self;
        [_policBtn bk_whenTapped:^{
            WSWebViewController *vc = [WSWebViewController new];
            vc.urlPath = kUserPolice;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _policBtn;
}

@end
