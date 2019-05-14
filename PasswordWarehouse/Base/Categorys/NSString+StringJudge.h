//
//  NSString+StringJudge.h
//  CWGJCarOwner
//
//  Created by mutouren on 9/17/15.
//  Copyright (c) 2015 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringJudge)

#pragma mark 判断字符串是否为web端的null,是返回@""
+ (NSString*)stringJudgeNullWithContent:(NSString*)content;

#pragma mark 验证车牌
- (BOOL)VerifyCarNo;

#pragma mark 验证手机号码
- (BOOL)VerifyPhone;

#pragma mark 验证短信验证码
- (BOOL)VerifySMSNote;

#pragma mark 判断是否是数字
- (BOOL)isNumText;

#pragma 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkIsPassword;

#pragma 正则匹配用户姓名或企业名,20位的中文或英文
- (BOOL)checkIsUserName;

#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkIsUserIdCard;

#pragma 正则匹员工号,12位的数字
- (BOOL)checkIsEmployeeNumber;

#pragma 正则匹配座机号,11位数字
- (BOOL)checkLandlineNumber;

#pragma 正则匹配URL
- (BOOL)checkIsURL;

#pragma 正则匹配银行卡
+ (BOOL)checkBackCardWithNum:(NSString *)cardNo;

@end
