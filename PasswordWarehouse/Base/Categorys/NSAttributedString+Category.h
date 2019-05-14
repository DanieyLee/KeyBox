//
//  NSAttributeString+Category.h
//  yunFanPiaoWu
//
//  Created by 喵喵炭 on 2018/12/3.
//  Copyright © 2018 炜森. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Category)

- (void)addSpacingWithLength:(CGFloat)spacing;

- (void)appendOriginFormateString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
