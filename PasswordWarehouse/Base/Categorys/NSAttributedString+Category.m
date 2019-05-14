//
//  NSAttributeString+Category.m
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/12/3.
//  Copyright © 2018 炜森. All rights reserved.
//

#import "NSAttributedString+Category.h"

@implementation NSMutableAttributedString (Category)

- (void)addSpacingWithLength:(CGFloat)spacing {
    NSString *tempStr = @" ";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : FONT(0.001)}];
    [attributedStr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0,attributedStr.length)];
    [self appendAttributedString:attributedStr];
}

- (void)appendOriginFormateString:(NSString *)string {
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string attributes:nil];
    [self appendAttributedString:attributedStr];
}

@end
