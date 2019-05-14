//
//  AlertControllerUtil.m
//  bg
//
//  Created by 喵喵炭 on 2017/5/13.
//  Copyright © 2017年 BinaryHunter. All rights reserved.
//

#import "WSAlertControllerUtil.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation WSAlertControllerUtil

+ (void)AlertControllerShowInViewController:(UIViewController *)controller
                                     delegate:(id)delegate
                                    withTitle:(NSString *)title
                                      message:(NSString *)message
                               preferredStyle:(UIAlertControllerStyle)preferredStyle
                            cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonActions:(NSArray<NSString *> *)actions
                      otherButtonParameters:(NSArray<id> *)parameters
                            otherButtonTitles:(NSString *)otherTitles, ... {
    if (!controller) {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:preferredStyle];
    if (cancelButtonTitle) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alertController addAction:cancleAction];
    }
    NSMutableArray *otherTitlesArr = [NSMutableArray array];
    va_list args;
    va_start(args, otherTitles);
    while (otherTitles != nil) {
        [otherTitlesArr addObject:otherTitles];
        if (otherTitles) {
            NSString *actionStr;
            id paramter;
            if (otherTitlesArr.count <= actions.count) {
                actionStr = [actions objectAtIndex:otherTitlesArr.count - 1];
                paramter = [parameters objectAtIndex:otherTitlesArr.count - 1];
            }
            delegate = delegate ? delegate : controller;
            __weak typeof(delegate)weakDelegate = delegate;
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:otherTitles
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    if (actionStr) {
                                                                        SEL selector = NSSelectorFromString(actionStr);
                                                                        if (selector && [weakDelegate respondsToSelector:selector]) {
                                                                            [weakDelegate performSelector:selector withObject:paramter afterDelay:0];
                                                                        }
                                                                    }
                                                                }];
            [alertController addAction:alertAction];
        }
        otherTitles = va_arg(args, NSString *);
    }
    [controller presentViewController:alertController
                             animated:YES
                           completion:nil];
}


@end
