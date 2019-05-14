//
//  UIImage+Category.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)originalImageWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return originalImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect imageRect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
