//
//  ZACustomButton.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/9.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NNCustomButtonLayoutImageLocationType) {
    NNCustomButtonLayoutImageLocationTypeLeft = 1,
    NNCustomButtonLayoutImageLocationTypeRight,
    NNCustomButtonLayoutImageLocationTypeTop,
    NNCustomButtonLayoutImageLocationTypeBottom
};

@interface NNCustomButton : UIButton

@property (nonatomic, assign) NNCustomButtonLayoutImageLocationType      layoutType;

@property (nonatomic, assign) CGFloat       imageLabelInsert;

@end
