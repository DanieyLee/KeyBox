//
//  NSDictionary+Category.m
//  yunFanPiaoWu
//
//  Created by develop on 2018/11/12.
//  Copyright © 2018 炜森科技. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (String)

- (id)ws_stringForKey:(id)aKey placeholder:(NSString *)placeholder {
    id obj = [self objectForKey:aKey];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj isEqualToString:@"<null>"]) {
                return placeholder;
            }
            if ([obj length]>0) {
                return obj;
            }
            return placeholder;
        } else if ([obj isKindOfClass:[NSNull class]]) {
            return placeholder;
        } else {
            return [NSString stringWithFormat:@"%@", obj];
        }
    } else {
        return placeholder;
    }
}

- (id)ws_2fNumberStringForKey:(id)aKey placeholder:(NSString *)placeholder {
    id obj = [self objectForKey:aKey];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([obj length]>0) {
                return obj;
            }
            return placeholder;
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            NSDecimalNumber *number;
            if (strcmp([obj objCType], @encode(float)) == 0)
            {
                NSString *numberStr = [NSString stringWithFormat:@"%.2f",[obj floatValue]];
                number = [[NSDecimalNumber alloc]initWithString:numberStr];
                
            }
            else if (strcmp([obj objCType], @encode(double)) == 0)
            {
                NSString *numberStr = [NSString stringWithFormat:@"%.2f",[obj doubleValue]];
                number = [[NSDecimalNumber alloc]initWithString:numberStr];
            }
            else
            {
                NSString *numberStr = [NSString stringWithFormat:@"%ld",[obj longValue]];
                number = [[NSDecimalNumber alloc]initWithString:numberStr];
            }
            return [number stringValue];
        }
        else {
            return [NSString stringWithFormat:@"%@", obj];
        }
    } else {
        return placeholder;
    }
}

- (id)ws_2fNumberStringForKey:(id)aKey {
    return [self ws_2fNumberStringForKey:aKey placeholder:@""];
}

- (id)ws_stringForKey:(id)aKey {
    return [self ws_stringForKey:aKey placeholder:@""];
}

@end

@implementation NSMutableDictionary(String)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || [anObject isEqual:[NSNull null]]) {
        anObject = @"";
    }
    [self setObject:anObject forKey:aKey];
}


@end

