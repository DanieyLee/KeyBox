//
//  ActionSheetWindow.m
//  NN
//
//  Created by NN on 16/8/22.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "ActionSheetWindow.h"

@interface ActionSheetViewController()
@property (nonatomic, strong) UIView                             *actionSheetView;
@property (nonatomic, assign) ActionSheetViewAppearDirection      appearDirection;
- (void)hide;
@end

@interface ActionSheetWindow()
@property (nonatomic, strong) UIView               *actionSheetView;
@property (nonatomic, strong) NSArray              *actionSheetViewConstraints;
@property (nonatomic, weak  ) ActionSheetViewController *actionSheetViewController;
@end

@implementation ActionSheetWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNeedLoginNotification:) name:CDNotificationKeyLogin object:nil];
    }
    return self;
}

+ (ActionSheetWindow *)sharedInstace {
    static ActionSheetWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[ActionSheetWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return window;
}

+ (void)showActionSheetView:(UIView *)actionSheetView
              withDirection:(ActionSheetViewAppearDirection)direction
             completeHandle:(void (^)(void))handle {
    ActionSheetWindow *window = [ActionSheetWindow sharedInstace];
    window.actionSheetView = actionSheetView;
    window.actionSheetViewConstraints = actionSheetView.constraints;
    [window makeKeyAndVisible];
    ActionSheetViewController *controller = [[ActionSheetViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.hidden = YES;
    window.actionSheetViewController = controller;
    window.rootViewController = navController;
    __weak typeof(window)weakSelfWindow = window;
    controller.actionSheetView = actionSheetView;
    controller.appearDirection = direction;
    [UIView animateWithDuration:.3f animations:^{
        CGFloat alpha = 0;
        if ([actionSheetView respondsToSelector:@selector(backgroundAlpha)]) {
            alpha = ((ActionSheetView *)actionSheetView).backgroundAlpha;
        }
        weakSelfWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha == 0 ? 0.5 : alpha];
    }];
}

+ (void)hideActionSheetView {
    [self hideActionSheetViewCompleteHandle:nil];
}

+ (void)hideActionSheetViewCompleteHandle:(void (^)(void))handle {
    ActionSheetWindow *window = [ActionSheetWindow sharedInstace];
    ActionSheetViewController *controller = window.actionSheetViewController;
    [controller hide];
    //    [window.actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(0);
    //        make.top.equalTo(window.actionSheetView.superview.mas_bottom);
    //    }];
    //    [window.actionSheetView addConstraints:window.actionSheetViewConstraints];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        [window.actionSheetView.superview layoutIfNeeded];
    //    }];
    [window resignKeyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        window.backgroundColor = [UIColor colorWithWhite:0 alpha:0];;
    } completion:^(BOOL finished) {
        window.hidden = YES;
        if (handle) {
            handle();
        }
    }];
}

- (void)receiveNeedLoginNotification:(NSNotification *)notification {
    [ActionSheetWindow hideActionSheetView];
}

@end

@implementation ActionSheetView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundAlpha = 0.5;
        self.cancelHideWhenClickBorder = YES;
    }
    return self;
}

@end

@interface ActionSheetViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray      *constraints;
@property (nonatomic, assign) CGFloat       topOffset;
@property (nonatomic, assign) CGFloat       bottomOffset;
@end

@implementation ActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    _constraints =  _actionSheetView.constraints;
    [self.view addSubview:_actionSheetView];
    
    if ([_actionSheetView respondsToSelector:@selector(setCancelHideWhenClickBorder:)] && ((ActionSheetView *)_actionSheetView).cancelHideWhenClickBorder) {
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(hideWindew)];
        [self.view addGestureRecognizer:tapG];
        tapG.delegate = self;
    }
    
    BOOL isIphoneX = [UIApplication sharedApplication].statusBarFrame.size.height != 20;
    if (isIphoneX && _appearDirection != ActionSheetViewAppearDirectionFromCenter && _appearDirection != ActionSheetViewAppearDirectionNone) {
        _topOffset = 24;
        _bottomOffset = 34;
        if (_appearDirection != ActionSheetViewAppearDirectionFromBottom) {
            UIView *insertView = [UIView new];
            [self.view addSubview:insertView];
            insertView.backgroundColor = [UIColor grayColor];
            [insertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.actionSheetView);
                make.bottom.equalTo(self.actionSheetView.mas_top);
                make.height.mas_equalTo(self.topOffset);
            }];
            for (UIView *subView in _actionSheetView.subviews) {
                if (subView) {
                    insertView.backgroundColor = subView.backgroundColor;
                    break;
                }
            }
        }
        if (_appearDirection != ActionSheetViewAppearDirectionFromTop) {
            UIView *insertBottomView = [UIView new];
            [self.view addSubview:insertBottomView];
            insertBottomView.backgroundColor = [UIColor whiteColor];
            [insertBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.actionSheetView);
                make.bottom.equalTo(@0);
                make.height.mas_equalTo(self.bottomOffset);
            }];
        }
    }
    
    __weak typeof(self)weakSelf = self;
    switch (_appearDirection) {
        case ActionSheetViewAppearDirectionFromTop:
            
            break;
        case ActionSheetViewAppearDirectionFromLeft:
        {
            [_actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-self.bottomOffset);
                make.top.mas_equalTo(self.topOffset);
                make.right.equalTo(weakSelf.view.mas_left);
            }];
        }
            break;
        case ActionSheetViewAppearDirectionFromRight:
            break;
        case ActionSheetViewAppearDirectionFromBottom:
        {
            [_actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.equalTo(weakSelf.view.mas_bottom);
            }];
        }
            break;
        case ActionSheetViewAppearDirectionFromCenter:
        {
            [_actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.mas_equalTo(0);
            }];
            break;
        }
        default:
            break;
    }
    //子视图如果有frame的，宽高会X2
    self.actionSheetView.autoresizesSubviews = NO;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (_appearDirection) {
        case ActionSheetViewAppearDirectionFromTop:
            
            break;
        case ActionSheetViewAppearDirectionFromLeft:
        {
            [_actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.bottom.mas_equalTo(-self.bottomOffset);
                make.top.mas_equalTo(self.topOffset);
            }];
        }
            break;
        case ActionSheetViewAppearDirectionFromRight:
            break;
        case ActionSheetViewAppearDirectionFromBottom:
        {
            [_actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-self.bottomOffset);
            }];
        }
            break;
        default:
            break;
    }
    [_actionSheetView addConstraints:_constraints];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideWindew {
    [ActionSheetWindow hideActionSheetView];
}

- (void)hide {
    __weak typeof(self)weakSelf = self;
    switch (_appearDirection) {
        case ActionSheetViewAppearDirectionFromTop:
            
            break;
        case ActionSheetViewAppearDirectionFromLeft:
        {
            [_actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.view.mas_left);
                make.bottom.mas_equalTo(-weakSelf.bottomOffset);
                make.top.mas_equalTo(weakSelf.topOffset);
            }];
        }
            break;
        case ActionSheetViewAppearDirectionFromRight:
            break;
        case ActionSheetViewAppearDirectionFromBottom:
        {
            [_actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.equalTo(weakSelf.view.mas_bottom);
            }];
        }
            break;
        case ActionSheetViewAppearDirectionFromCenter:
        {
            break;
        }
        default:
            break;
    }
    [_actionSheetView addConstraints:_constraints];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self hideAlphaHandle];
    } completion:^(BOOL finished) {
        weakSelf.actionSheetView.alpha = 1;
    }];
}

- (void)hideAlphaHandle {
    if (_appearDirection == ActionSheetViewAppearDirectionFromCenter) {
        _actionSheetView.alpha = 0;
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    } else {
        return NO;
    }
}

@end
