//
//  UIFont+Category.h
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Category)

+ (UIFont *)ws_customFontOfSize:(CGFloat)fontSize;

+ (UIFont *)ws_scaleWithLineHeight:(CGFloat)lineHeight
                       fontName:(nullable NSString *)fontName;

@end

NS_ASSUME_NONNULL_END
