//
//  JSONUtil.h
//  ZhaoPin
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtil : NSObject

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

+ (NSString *)stringWithJSONObject:(id)obj error:(NSError **)error;

@end
