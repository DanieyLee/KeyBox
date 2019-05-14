//
//  WSTextFieldView.m
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/11/14.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import "WSTextFieldView.h"
#import "WSBaseViewController.h"
#import <Toast/Toast.h>

@interface WSTextFieldView ()<UITextFieldDelegate>
@property (nonatomic, strong) WSTextField                 *textField;
@property (nonatomic, strong) UILabel                     *titleLabel;
@end

@implementation WSTextFieldView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeSubviews];
        self.backgroundColor = HexColor(0xFFFFFF);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.right.mas_equalTo(-8);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark Lazyload

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel ws_createLabelWithText:nil textColor:COLOR_333 font:FONT(15) textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (WSTextField *)textField
{
    if (!_textField) {
        _textField = [WSTextField new];
        [self addSubview:_textField];
        _textField.font = FONT(15);
        _textField.textColor = COLOR_333;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //去掉，拼音之间的空格特殊字符
    //    newText = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
    newText = [self removeSelectedRangeForString:newText];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (_inputReg && _inputReg.length != 0) {
        NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _inputReg];
        if ([inputPredicate evaluateWithObject:newText]) {
            if (textField.secureTextEntry) {
                textField.text = newText;
                return NO;
            }
            return YES;
        } else {
            if (_maxLength > 0 & newText.length > _maxLength) {
                textField.text = [newText substringToIndex:_maxLength];
            }
            [self showAlertTip:newText];
            return NO;
        }
    }
    if (textField.secureTextEntry) {
        textField.text = newText;
        return NO;
    }
    return YES;
}

- (void)showAlertTip:(NSString *)text {
    UIViewController *controller =  [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([controller isKindOfClass:[WSBaseViewController class]]) {
        WSBaseViewController *currentVC = (WSBaseViewController *)controller;
        if (text && _maxLength > 0 & text.length > _maxLength) {
            NSString *message = _maxLengthAlert ? _maxLengthAlert : [NSString stringWithFormat:@"输入不能超过%@个字符", @(_maxLength)];
            [currentVC.view makeToast:message];
            return;
        }
        if (_vertifyAlert && _vertifyAlert.length != 0 && self.textField.text.length != 0) {
            [currentVC showAlertMessage:_vertifyAlert];
        }
    }
}

- (NSString *)removeSelectedRangeForString:(NSString *)string {
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.textField markedTextRange];
        //获取高亮部分
        //        UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
        NSString *selectedStr = [self.textField textInRange:selectedRange];
        NSString *newString = [string stringByReplacingOccurrencesOfString:selectedStr withString:@""];
        return newString;
    } else {
        
    }
    return string;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_vertifyReg && _vertifyReg.length != 0) {
        NSPredicate *vertifyPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _vertifyReg];
        if (![vertifyPredicate evaluateWithObject:textField.text]) {
            [self showAlertTip:self.vertifyAlert];
        }
    }
    if (_textFieldDidEndEditingText) {
        self.textFieldDidEndEditingText(textField);
    }
}

- (void)dealloc {
    self.textField.secureTextEntry = NO;
//    NSLog(@"%@ dealloc", self);
}



@end


@implementation WSTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect clearButtonRect = [super clearButtonRectForBounds:bounds];
    CGRect newRect = CGRectInset(clearButtonRect, -5, -5);
    return newRect;
}


@end
