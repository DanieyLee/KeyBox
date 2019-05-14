//
//  WSTextFieldView.h
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/11/14.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSTextField : UITextField

@end

@interface WSTextFieldView : UIView
//输入框
@property (nonatomic, strong, readonly) WSTextField   *textField;

@property (nonatomic, strong, readonly) UILabel       *titleLabel;
//标题
@property (nonatomic, copy) NSString        *title;

//输入最大长度,>0才起作用
@property (nonatomic, assign) NSUInteger    maxLength;
//超过最大长度提示
@property (nonatomic, strong) NSString      *maxLengthAlert;
//输入正则
@property (nonatomic, copy) NSString    *inputReg;
//验证正则
@property (nonatomic, copy) NSString    *vertifyReg;
//验证提示
@property (nonatomic, copy) NSString    *vertifyAlert;
//编辑结束
@property (nonatomic, copy) void(^textFieldDidEndEditingText)(UITextField *textField);


@end

NS_ASSUME_NONNULL_END
