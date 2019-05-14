//
//  NSString+Category.h
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/11/17.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

- (CGFloat)stringLengthWithFont:(UIFont *)font;

@end

@interface NSString (URLPath)

- (NSString *)originalImageUrl;

@end

@interface NSString(LeftRightAlign)

- (NSAttributedString *)changeAlignmentRightAndLeftWithContainerViewWidth:(CGFloat)width
                                                                     font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
