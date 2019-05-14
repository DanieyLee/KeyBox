//
//  NSString+Category.m
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/11/17.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Size)

- (CGFloat)stringLengthWithFont:(UIFont *)font {
    NSAssert(font != nil, @"font cannot be nil");
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    return rect.size.width;
}

@end

@implementation NSString (URLPath)

- (NSString *)originalImageUrl {
    NSString *escapesString = self;
    //    if ([self checkContainChinese]) {
    //    }
    escapesString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return escapesString;
}

@end

@implementation NSString(LeftRightAlign)

- (NSAttributedString *)changeAlignmentRightAndLeftWithContainerViewWidth:(CGFloat)width
                                                                     font:(UIFont *)font {
    if (font == nil) {
        return nil;
    }
    CGFloat length = [self stringLengthWithFont:font];
    CGFloat margin = (width - length) / (self.length - 1);
    margin = MAX(margin, 0);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    [attributedString addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,self.length -1)];
    return attributedString;
}

@end
