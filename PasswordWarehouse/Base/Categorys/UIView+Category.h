//
//  UIView+Category.h
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConvenientInit)

+ (UILabel *_Nullable)ws_createLabelWithText:(nullable NSString *)text
                          textColor:(nullable UIColor *)textColor
                               font:(nullable UIFont*)font
                      textAlignment:(NSTextAlignment)alignment;

+ (instancetype _Nullable )ws_createViewWithColor:(nullable UIColor *)color;

+ (UIImageView *_Nullable)ws_createImageViewWithImageName:(nullable NSString *)imageName;

@end



typedef NS_ENUM(NSUInteger, GradientDirection) {
    GradientDirectionFromLeft,
    GradientDirectionFromRight,
    GradientDirectionFromTop,
    GradientDirectionFromBottom,
    GradientDirectionDiagonalFromLeftTop,
    GradientDirectionDiagonalFromLeftBottom,
    GradientDirectionDiagonalFromRightTop,
    GradientDirectionDiagonalFromRightBottom,
};

@interface UIView (Drawing)

- (void)addGradientLayerWithDirection:(GradientDirection)direction
                            fromColor:(UIColor *_Nullable)fromColor
                              toColor:(UIColor *_Nullable)toColor
                          shadowColor:(UIColor *_Nullable)shadowColor;

- (void)addCornerWithRaidu:(CGFloat)radius;

+ (void)addCellSectionCornerWithTableView:(UITableView *_Nullable)tableView
                                     cell:(UITableViewCell *_Nullable)cell
                             rowIndexPath:(NSIndexPath *_Nullable)indexPath;

@end
