//
//  WSConfigeManager.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/14.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSConfigeManager.h"

@interface WSConfigeManager ()
@property (nonatomic, strong) NSMutableDictionary   *configeDic;
- (void)setConfige:(id)confige forKey:(WSConfigeFeatures)key;
- (id)configeForKey:(WSConfigeFeatures)key;
@end

@implementation WSConfigeManager

static WSConfigeManager *configeManager;

+ (instancetype)sharedConfigeManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configeManager = [WSConfigeManager new];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([[userDefaults objectForKey:@"haveDefaultConfige"] boolValue] == NO) {
            [configeManager configeDic];
            [userDefaults setBool:YES forKey:@"haveDefaultConfige"];
        }
    });
    return configeManager;
}

- (void)setConfige:(id)confige forKey:(WSConfigeFeatures)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:confige forKey:@(key).stringValue];
}

- (id)configeForKey:(WSConfigeFeatures)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@(key).stringValue];
}

#pragma mark - lazyload

- (NSMutableDictionary *)configeDic {
    if (!_configeDic) {
        _configeDic = [@{
                        @(WSConfigeFeaturesPasscodeAccess) : @(YES),
                        @(WSConfigeFeaturesTouchIDAccess) : @(NO),
                        } mutableCopy];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (NSNumber *confige in _configeDic.allKeys) {
            [userDefaults setObject:_configeDic[confige] forKey:confige.stringValue];
        }
    }
    return _configeDic;
}

- (BOOL)touchIDAccess {
    return [[self configeForKey:WSConfigeFeaturesTouchIDAccess] boolValue];
}

- (void)setTouchIDAccess:(BOOL)touchIDAccess {
    [self setConfige:@(touchIDAccess) forKey:WSConfigeFeaturesTouchIDAccess];
}

- (BOOL)passcodeAccess {
    return [[self configeForKey:WSConfigeFeaturesPasscodeAccess] boolValue];
}

- (void)setPasscodeAccess:(BOOL)passcodeAccess {
    [self setConfige:@(passcodeAccess) forKey:WSConfigeFeaturesPasscodeAccess];
}

@end
