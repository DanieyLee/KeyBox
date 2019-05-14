//
//  WSIndexViewController.m
//  PasswordWarehouse
//
//  Created by NN on 2019/2/13.
//  Copyright © 2019 WeiSen. All rights reserved.
//

#import "WSIndexViewController.h"
#import "WSMineViewController.h"
#import "WSTouchIDUtil.h"
#import "WSBiometricViewController.h"

@interface WSIndexViewController ()
@property (nonatomic, strong) NSArray       *itemsInfoArray;
@end

@implementation WSIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger itemCount = self.itemsInfoArray.count;
    for (NSInteger i = 0; i < itemCount; i++) {
        NSDictionary *itemInfo = [self.itemsInfoArray objectAtIndex:i];
        
        NSString *className = itemInfo[@"className"];
        Class class = NSClassFromString(className);
        
        UIViewController *vc = [class new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
        
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:itemInfo[@"title"]
                                                           image:[UIImage imageNamed:itemInfo[@"imgName"]]
                                                   selectedImage:[UIImage imageNamed:itemInfo[@"selectedImgName"]]];
        nav.tabBarItem = item;
    }
    
}

#pragma mark - Actions

- (void)appBecomeActive {
    WSBiometricViewController *vc = [WSBiometricViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - lazyload

- (NSArray *)itemsInfoArray {
    if (!_itemsInfoArray) {
        _itemsInfoArray = @[
                            @{
                                @"title" : @"所有",
                                @"imgName" : @"tab_password_nor",
                                @"selectedImgName" : @"tab_password_sel",
                                @"className" : @"WSSearchHomeViewController",
                                },
                            @{
                                @"title" : @"设置",
                                @"imgName" : @"tab_setting_nol",
                                @"selectedImgName" : @"tab_setting_sel",
                                @"className" : @"WSMineViewController",
                                }];
    }
    return _itemsInfoArray;
}

@end
