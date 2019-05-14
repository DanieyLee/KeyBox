//
//  UIFont+Category.m
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import "UIFont+Category.h"

struct ToleranceTupe {
    CGFloat tolerance;
    CGFloat constant;
};

@implementation UIFont (Category)

+ (UIFont *)ws_customFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)ws_scaleWithLineHeight:(CGFloat)lineHeight
                       fontName:(nullable NSString *)fontName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *globalData = [[userDefault objectForKey:@"ws_globalData"] mutableCopy];
    NSMutableDictionary *toleranceDictionary = [globalData objectForKey:@"fontTolerance"];
    if (!toleranceDictionary) {
        toleranceDictionary = [NSMutableDictionary dictionary];
    }
    fontName = fontName ? fontName : [UIFont systemFontOfSize:15].fontName;
    NSValue *fontInfo = [toleranceDictionary objectForKey:fontName];
    lineHeight = SCALE_FL(lineHeight);
    if (!fontInfo) {
        UIFont *tempFont1 = [UIFont fontWithName:fontName size:15];
        UIFont *tempFont2 = [UIFont fontWithName:fontName size:16];
        CGFloat tolerance = (tempFont2.lineHeight - tempFont1.lineHeight) * 2;
        CGFloat constant = tempFont1.lineHeight - 15 * tolerance;
        struct ToleranceTupe tupe = {tolerance, constant};
        NSValue *value = [NSValue value:&tupe withObjCType:@encode(struct ToleranceTupe)];
        [toleranceDictionary setObject:value forKey:fontName];
        fontInfo = value;
        
        struct ToleranceTupe tupe_;
        [fontInfo getValue:&tupe_];
        [globalData setObject:toleranceDictionary forKey:@"fontTolerance"];
    }
    struct ToleranceTupe tupe;
    [fontInfo getValue:&tupe];
    
    CGFloat newFontSize =  (lineHeight - tupe.constant) / tupe.tolerance;
    UIFont *newFont = [UIFont fontWithName:fontName size:newFontSize];
    return newFont;
}

@end
