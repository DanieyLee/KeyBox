//
//  AppDelegate.m
//  PasswordWarehouse
//
//  Created by NN on 2018/12/27.
//  Copyright © 2018 WeiSen. All rights reserved.
//

#import "AppDelegate.h"
#import "WSIndexViewController.h"
#import "WSPasswordLoginViewController.h"
#import "WSConfigeManager.h"
#import "WSBiometricViewController.h"
#import "WSPasswordListViewController.h"
#import "WSBaseNavigationController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "WSPasswordUploadUtil.h"
#import <Accelerate/Accelerate.h>

@interface AppDelegate ()
@property (nonatomic, strong) UIVisualEffectView    *effectView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    WSPasswordListViewController *homeVC = [WSPasswordListViewController new];
    WSBaseNavigationController *nav = [[WSBaseNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = nav;
   
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown) {
            [[WSPasswordUploadUtil sharedPasswordUploadUtil] startUpload];
        }
    }];
    
    [[WSPasswordUploadUtil sharedPasswordUploadUtil] startUpload];
    
//    BOOL canPasswordAccess = [WSConfigeManager sharedConfigeManager].passcodeAccess;
//    BOOL biometricAccess = [WSTouchIDUtil biomericsSupport];
//    if (canPasswordAccess) {
//        BOOL canBiomericAccess = [WSConfigeManager sharedConfigeManager].touchIDAccess;
//        if (biometricAccess && canBiomericAccess) {
//            WSBiometricViewController *vc = [WSBiometricViewController new];
//            [homeVC presentViewController:vc animated:NO completion:nil];
//        } else {
//            [WSPasswordLoginViewController showFromViewController:homeVC];
//        }
//    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self addBlurEffectWithUIVisualEffectView];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self removeBlurEffectWithUIVisualEffectView];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) addBlurEffectWithUIVisualEffectView {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.effectView];
}

-(void) removeBlurEffectWithUIVisualEffectView {
    [UIView animateWithDuration:0.5 animations:^{
        [self.effectView removeFromSuperview];
    }];
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        // 毛玻璃view 视图
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        // 设置模糊透明度
        _effectView.alpha = 0.9;
        _effectView.frame = [UIScreen mainScreen].bounds;
    }
    
    return _effectView;
}
@end
