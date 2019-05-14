//
//  ZABaseButton.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/19.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "WSBaseButton.h"

@implementation WSBaseButton

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setTitle:_title forState:UIControlStateNormal];
}

- (void)setSelectedStateTitle:(NSString *)selectedStateTitle {
    _selectedStateTitle = selectedStateTitle;
    [self setTitle:selectedStateTitle forState:UIControlStateSelected];
}

- (void)setNormalStateLocalImgName:(NSString *)normalStateLocalImgName
{
    _normalStateLocalImgName = normalStateLocalImgName;
    [self setImage:[UIImage imageNamed:normalStateLocalImgName] forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (_unenableBackgroundColor) {
        self.backgroundColor = enabled ? COLOUR_THEME : _unenableBackgroundColor;
    }
}

- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    [self setTitleColor:normalTextColor forState:UIControlStateNormal];
}

- (void)setSelectedStateLocalImageName:(NSString *)selectedStateLocalImageName {
    [self setImage:[UIImage imageNamed:selectedStateLocalImageName] forState:UIControlStateSelected];
}

- (void)setSelectedStateTextColor:(UIColor *)selectedStateTextColor {
    _selectedStateTextColor = selectedStateTextColor;
    [self setTitleColor:selectedStateTextColor forState:UIControlStateSelected];
}


@end
