//
//  ZACustomButton.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/9.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "NNCustomButton.h"

#define PADDING     8

@interface NNCustomButton ()
@property (nonatomic, strong) UIFont        *defaultFont;
@end

@implementation NNCustomButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
   self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

//默认设置
-(void)setup{
    self.imageLabelInsert = PADDING;
    self.exclusiveTouch = YES;
    self.defaultFont = [UIFont systemFontOfSize:15.0];
    self.titleLabel.font = self.defaultFont;
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    CGFloat widthInsert = contentEdgeInsets.left + contentEdgeInsets.right;
    CGFloat heightInsert = contentEdgeInsets.top + contentEdgeInsets.bottom;
    CGFloat contentWith = CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.titleLabel.frame);
    CGFloat contentHeight = CGRectGetHeight(self.imageView.frame) + CGRectGetHeight(self.titleLabel.frame);
    CGSize newSize;
    if (self.layoutType == NNCustomButtonLayoutImageLocationTypeTop || self.layoutType == NNCustomButtonLayoutImageLocationTypeBottom) {
        newSize = CGSizeMake(widthInsert + MAX(self.currentImage.size.width, self.titleLabel.frame.size.width),
                                    heightInsert + contentHeight + self.imageLabelInsert);
        return newSize;
    } else if (self.layoutType == NNCustomButtonLayoutImageLocationTypeRight) {
        newSize = CGSizeMake(widthInsert + self.imageLabelInsert + contentWith,
                                    MAX(CGRectGetHeight(self.imageView.frame), CGRectGetHeight(self.titleLabel.frame)) + heightInsert);
        return newSize;
    }
    return [super sizeThatFits:size];
}

//override
- (CGRect)contentRectForBounds:(CGRect)bounds {
    CGRect rect = [super contentRectForBounds:bounds];
    return rect;
}
//override
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (_layoutType == NNCustomButtonLayoutImageLocationTypeTop) {
        return [self imageRectWithImageTopForContentRect:contentRect];
    } else if (_layoutType == NNCustomButtonLayoutImageLocationTypeRight) {
        return [self imageRectWithImageRightForContentRect:contentRect];
    } else if (self.layoutType == NNCustomButtonLayoutImageLocationTypeBottom) {
        return [self imageRectWithImageBottomForContentRect:contentRect];
    } else {
        return [super imageRectForContentRect:contentRect];
    }
}
//override
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (_layoutType == NNCustomButtonLayoutImageLocationTypeTop) {
        return [self titleRectWithImageTopForContentRect:contentRect];
    } else if (_layoutType == NNCustomButtonLayoutImageLocationTypeRight) {
        return [self titleRectWithImageRightForContentRect:contentRect];
    } else if (self.layoutType == NNCustomButtonLayoutImageLocationTypeBottom) {
        return [self titleRectWithImageBottomForContentRect:contentRect];
    } else {
        return [super titleRectForContentRect:contentRect];
    }
}

#pragma mark NNCustomButtonLayoutImageLocationTypeBottom

- (CGRect)titleRectWithImageBottomForContentRect:(CGRect)contentRect {
    NSString *title = self.currentTitle;
    CGRect titleRect = [self getRectWithTitle:title];
    CGFloat titleW = titleRect.size.width > contentRect.size.width ? contentRect.size.width : titleRect.size.width;
    CGFloat titleH = titleRect.size.height;
    CGFloat imageH = self.currentImage.size.height;
    CGFloat allHeight = titleH + _imageLabelInsert + imageH;
    BOOL beyondBorder = allHeight > contentRect.size.height;
    CGFloat titleX = (contentRect.size.width - titleW) / 2 + self.contentEdgeInsets.left;
    CGFloat titleY = self.contentEdgeInsets.top + (beyondBorder ? (0) : (contentRect.size.height - allHeight) / 2);
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectWithImageBottomForContentRect:(CGRect)contentRect {
    NSString *title = self.currentTitle;
    CGFloat titleH = [self getRectWithTitle:title].size.height;
    CGFloat imageH = self.currentImage.size.height;
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageX = (contentRect.size.width - imageW) / 2 + self.contentEdgeInsets.left;
    CGFloat allHeight = titleH + _imageLabelInsert + imageH;
    BOOL beyondBorder = allHeight > contentRect.size.height;
    CGFloat imageY =  CGRectGetMaxY(self.titleLabel.frame) + (beyondBorder ? 0 : self.imageLabelInsert);
    return CGRectMake(imageX, imageY, imageW, imageH);
}

#pragma mark NNCustomButtonLayoutImageLocationTypeTop

- (CGRect)imageRectWithImageTopForContentRect:(CGRect)contentRect {
    NSString *title = self.currentTitle;
    CGFloat titleH = [self getRectWithTitle:title].size.height;
    CGFloat imageH = self.currentImage.size.height;
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageX = (contentRect.size.width - imageW) / 2 + self.contentEdgeInsets.left;
    CGFloat allHeight = titleH + _imageLabelInsert + imageH;
    BOOL beyondBorder = allHeight > contentRect.size.height;
    CGFloat imageY =  beyondBorder ? self.contentEdgeInsets.top : (contentRect.size.height - allHeight) / 2 + self.contentEdgeInsets.top;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectWithImageTopForContentRect:(CGRect)contentRect {
    NSString *title = self.currentTitle;
    CGRect titleRect = [self getRectWithTitle:title];
    CGFloat titleW = titleRect.size.width > contentRect.size.width ? contentRect.size.width : titleRect.size.width;
    CGFloat titleH = titleRect.size.height;
    CGFloat imageH = self.currentImage.size.height;
    CGFloat allHeight = titleH + _imageLabelInsert + imageH;
    BOOL beyondBorder = allHeight > contentRect.size.height;
    CGFloat titleX = (contentRect.size.width - titleW) / 2 + self.contentEdgeInsets.left;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame) + (beyondBorder ? (0) : _imageLabelInsert);
    return CGRectMake(titleX, titleY, titleW, titleH);
}

#pragma mark NNCustomButtonLayoutImageLocationTypeRight

- (CGRect)titleRectWithImageRightForContentRect:(CGRect)contentRect {
    NSString *title = self.currentTitle;
    CGRect titleRect = [self getRectWithTitle:title];
    CGSize imageSize = [self imageRectWithImageRightForContentRect:contentRect].size;
    CGFloat btnH = contentRect.size.height;
    CGFloat btnW = contentRect.size.width;
    CGFloat titleW = titleRect.size.width;
    CGFloat titleImageW = imageSize.width + titleW + _imageLabelInsert;
    BOOL beyondW = titleImageW > btnW;
    CGFloat titleH = titleRect.size.height;
    CGFloat titleY = (btnH - titleH) / 2 + self.contentEdgeInsets.top;
    CGFloat titleX = self.contentEdgeInsets.left + (beyondW ? (0) : (btnW - titleImageW) / 2);
    CGFloat adjustW = beyondW ? btnW - imageSize.width : titleW;
    return CGRectMake(titleX, titleY, adjustW, titleH);
}

- (CGRect)imageRectWithImageRightForContentRect:(CGRect)contentRect {
    CGFloat   imageH = self.currentImage.size.height;
    CGFloat   imageW = self.currentImage.size.width;
    NSString *title = self.currentTitle;
    CGRect    titleRect = [self getRectWithTitle:title];
    CGFloat   titleImageW = imageW + titleRect.size.width + _imageLabelInsert;
    BOOL beyondW = titleImageW > contentRect.size.width;
    CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame) + (beyondW ? 0 : self.imageLabelInsert);
    CGFloat imageY = (contentRect.size.height - imageH) / 2 + self.contentEdgeInsets.top;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

#pragma mark Private

-(CGRect)getRectWithTitle:(NSString *)title{
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSFontAttributeName] = self.titleLabel.font;
    return [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:md context:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
//    [self sizeToFit];
}

@end
