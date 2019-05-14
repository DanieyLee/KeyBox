//
//  JSONUtil.m
//  ZhaoPin
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 riicy. All rights reserved.
//

#import "JSONUtil.h"

@implementation JSONUtil

+(id)JSONObjectWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    if (data!=nil) {
        NSString * responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSArray * specialCharacters = @[@"\\v", @"\v", @"\t", @"	"];
        for (NSString * specialCharacter in specialCharacters) {
            responseString = [responseString stringByReplacingOccurrencesOfString : specialCharacter withString : @"" ];
        }
        
        NSData * d = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (d) {
            return [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:error];
        }
    }
    return nil;
}

+ (NSString *)stringWithJSONObject:(id)obj error:(NSError *__autoreleasing *)error {
    if (obj) {
        NSError * err = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
        if (err) {
            *error = err;
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

@end
