//
//  UIView+Category.m
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/5.
//  Copyright © 2018 艾腾. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (ConvenientInit)

+ (UILabel *)ws_createLabelWithText:(nullable NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont*)font
                   textAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [UILabel new];
    if (text) label.text = text;
    if (textColor) {
        label.textColor = textColor;
    } else {
        label.textColor = COLOR_333;
    }
    if (alignment) label.textAlignment = alignment;
    if (font) {
        label.font = font;
    } else {
        label.font = FONT(15);
    }
    return label;
}

+ (instancetype)ws_createViewWithColor:(UIColor *)color {
    UIView *line = [self new];
    line.backgroundColor = (color && [color isKindOfClass:[UIColor class]] ? color : HexColor(0xe5e5e5));
    return line;
}

+ (UIImageView *)ws_createImageViewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [UIImageView new];
    if (image) {
        imageView.image = image;
    } else {
        imageView.backgroundColor = COLOR_BG;
    }
    return imageView;
}

+ (instancetype)ws_createButtonWithImageName:(NSString *)imageName
                          heightImageName:(NSString *)heightImageName
                        selectedImageName:(NSString *)selectedImageName {
    if (![self isSubclassOfClass:[UIButton class]]) {
        return nil;
    }
    UIButton *button = [self new];
    UIImage *image;
    if (imageName) {
        image = [UIImage imageNamed:imageName];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (heightImageName) {
        image = [UIImage imageNamed:heightImageName];
        if (image) {
            [button setImage:image forState:UIControlStateHighlighted];
        }
    }
    if (selectedImageName) {
        image = [UIImage imageNamed:selectedImageName];
        if (image) {
            [button setImage:image forState:UIControlStateSelected];
        }
    }
    return button;
}


+ (instancetype)ws_collectionViewWithLayout:(UICollectionViewLayout *)layout
                              dataSource:(id)dataSource
                                delegate:(id)delegate
{
    UICollectionView *collectonView = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectonView.backgroundColor = [UIColor whiteColor];
    collectonView.dataSource = dataSource;
    collectonView.delegate = delegate;
    return collectonView;
}

- (void)ws_createCircularViewWithCornerRedius:(CGFloat)cornerRedius {
    self.layer.cornerRadius = cornerRedius;
    self.layer.masksToBounds = YES;
}
@end

@implementation UIView (Drawing)

- (void)addGradientLayerWithDirection:(GradientDirection)direction
                            fromColor:(UIColor *)fromColor
                              toColor:(UIColor *)toColor
                          shadowColor:(UIColor *)shadowColor
{
    shadowColor = shadowColor ? : [UIColor colorWithRed:255.0f/255.0f green:97.0f/255.0f blue:98.0f/255.0f alpha:0.5f];
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.frame = self.bounds;
    shadowLayer.shadowColor = shadowColor.CGColor;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shadowOffset = CGSizeMake(0, 3);
    shadowLayer.shadowRadius = 5;
    
    CGFloat shadowSize = -1;
    CGRect shadowSpreadRect = CGRectMake(-shadowSize, -shadowSize, self.bounds.size.width + shadowSize * 2, self.bounds.size.height + shadowSize * 2);
    
    CGFloat shadowSpreadRadius =  self.layer.cornerRadius == 0 ? 0 : self.layer.cornerRadius + shadowSize;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect
                                                          cornerRadius:shadowSpreadRadius];
    shadowLayer.shadowPath = shadowPath.CGPath;
    
    //Gradient 0 fill for 矩形 32
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.cornerRadius = shadowSpreadRadius;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)fromColor.CGColor,
                             (id)toColor.CGColor];
    
    gradientLayer.locations = @[@0, @1];
    if (direction == GradientDirectionFromLeft) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
    } else if (direction == GradientDirectionFromRight) {
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0);
    } else if (direction == GradientDirectionFromTop) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
    } else if (direction == GradientDirectionFromBottom) {
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
    } else if (direction == GradientDirectionDiagonalFromLeftTop) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
    } else if (direction == GradientDirectionDiagonalFromLeftBottom) {
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
    } else if (direction == GradientDirectionDiagonalFromRightTop) {
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
    } else if (direction == GradientDirectionDiagonalFromRightBottom) {
        gradientLayer.startPoint = CGPointMake(1, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
    }
    [self.layer insertSublayer:gradientLayer atIndex:0];
    [self.layer insertSublayer:shadowLayer below:0];
}

- (void)addCornerWithRaidu:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

+ (void)addCellSectionCornerWithTableView:(UITableView *)tableView
                                     cell:(UITableViewCell *)cell
                             rowIndexPath:(NSIndexPath *)indexPath {
        
        CGFloat cornerRadius = 5.f;
        
        cell.backgroundColor = UIColor.clearColor;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGMutablePathRef linePathRef = CGPathCreateMutable();
        CGMutablePathRef lineLeftPathRef = CGPathCreateMutable();
        CGMutablePathRef lineRightPathRef = CGPathCreateMutable();
        
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        
        BOOL addLine = NO;
        
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            CGPathAddRoundedRect(linePathRef, nil, bounds, cornerRadius, cornerRadius);
            
        } else if (indexPath.row == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathMoveToPoint(linePathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(linePathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddArcToPoint(linePathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            CGPathAddLineToPoint(linePathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathMoveToPoint(linePathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(linePathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddArcToPoint(linePathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(linePathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            
            CGPathMoveToPoint(lineLeftPathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(lineLeftPathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            
            CGPathMoveToPoint(lineRightPathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            CGPathAddLineToPoint(lineRightPathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
            addLine = YES;
        }
        
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
        lineLayer.path = linePathRef;
        lineLayer.lineWidth = 0.5;
        CFRelease(linePathRef);
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = COLOR_EBEBEB.CGColor;
        [layer addSublayer:lineLayer];
        
        CAShapeLayer *lineLeftLayer = [[CAShapeLayer alloc] init];
        lineLeftLayer.path = lineLeftPathRef;
        lineLeftLayer.lineWidth = 0.5;
        CFRelease(lineLeftPathRef);
        lineLeftLayer.fillColor = [UIColor clearColor].CGColor;
        lineLeftLayer.strokeColor = COLOR_EBEBEB.CGColor;
        [layer addSublayer:lineLeftLayer];
        
        CAShapeLayer *lineRightLayer = [[CAShapeLayer alloc] init];
        lineRightLayer.path = lineRightPathRef;
        lineRightLayer.lineWidth = 0.5;
        CFRelease(lineRightPathRef);
        lineRightLayer.fillColor = [UIColor clearColor].CGColor;
        lineRightLayer.strokeColor = COLOR_EBEBEB.CGColor;
        [layer addSublayer:lineRightLayer];
        
        
        if (addLine == YES) {
            
            CALayer *separatorLayer = [[CALayer alloc] init];
            
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            
            CGFloat padding = 8;
            
            separatorLayer.frame = CGRectMake(CGRectGetMinX(bounds)+padding, bounds.size.height-lineHeight, bounds.size.width-padding*2, lineHeight);
            
            separatorLayer.backgroundColor = COLOR_EBEBEB.CGColor;
            
            [layer addSublayer:separatorLayer];
            
        }
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        
        [testView.layer insertSublayer:layer atIndex:0];
        
        testView.backgroundColor = UIColor.clearColor;
        
        cell.backgroundView = testView;
    
}

@end
