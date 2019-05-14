//
//  UIView+Frame.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark Setter

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = (CGRect){origin, self.size};
}

- (void)setLeft:(CGFloat)left
{
    [self setOrigin:CGPointMake(left, self.top)];
}

- (void)setTop:(CGFloat)top
{
    [self setOrigin:CGPointMake(self.left, top)];
}

- (void)setRight:(CGFloat)right
{
    self.left = right - self.width;
}

- (void)setBottom:(CGFloat)bottom
{
    self.top = bottom - self.height;
}

- (void)setSize:(CGSize)size
{
    self.frame = (CGRect){self.origin, size};
}

- (void)setWidth:(CGFloat)width
{
    [self setSize:CGSizeMake(width, self.height)];
}

- (void)setHeight:(CGFloat)height
{
    [self setSize:CGSizeMake(self.width, height)];
}

#pragma mark Getter

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)centerX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)height
{
    return self.size.height;
}

- (CGFloat)width
{
    return self.size.width;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left
{
    return self.origin.x;
}

- (CGFloat)top
{
    return self.origin.y;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

@end
