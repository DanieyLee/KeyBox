//
//  NSDictionary+Category.h
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/12.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (String)
//placeholder为@""
- (id)ws_stringForKey:(id)aKey;

@end

@interface NSMutableDictionary (String)

- (void)setSafeObject:(id)anObject
               forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
