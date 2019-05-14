//
//  UIImage+Category.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
//以UIImageRenderingModeAlwaysOriginal渲染模式渲染图片
+ (UIImage *)originalImageWithName:(NSString *)imageName;

/**
 根据颜色创建图片

 @param color 图片颜色
 @return UIImage对象
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
