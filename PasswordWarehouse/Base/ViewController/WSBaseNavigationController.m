//
//  ZABaseNavigationController.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/12.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "WSBaseNavigationController.h"
#import "UIImage+Category.h"

@interface WSBaseNavigationController ()

@end

@implementation WSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIImage *rightItemImg = [UIImage originalImageWithName:@"nav_icon_back"];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightItemImg style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)viewController;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
