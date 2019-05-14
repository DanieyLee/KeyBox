//
//  ZABaseButton.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/19.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBaseButton : UIButton

@property (nonatomic, copy) NSString    *title;

@property (nonatomic, copy) NSString    *selectedStateTitle;

@property (nonatomic, copy) NSString    *normalStateLocalImgName;

@property (nonatomic, copy) NSString    *selectedStateLocalImageName;

@property (nonatomic, copy) UIColor     *normalTextColor;

@property (nonatomic, copy) UIColor     *selectedStateTextColor;

@property (nonatomic, copy) UIColor     *unenableBackgroundColor;

@property (nonatomic, strong) id    data;

@end
