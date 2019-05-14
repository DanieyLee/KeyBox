//
//  ActionSheetWindow.h
//  NN
//
//  Created by NN on 16/8/22.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "WSBaseViewController.h"

typedef enum : NSUInteger {
    ActionSheetViewAppearDirectionNone,
    ActionSheetViewAppearDirectionFromTop,
    ActionSheetViewAppearDirectionFromLeft,
    ActionSheetViewAppearDirectionFromBottom,
    ActionSheetViewAppearDirectionFromRight,
    ActionSheetViewAppearDirectionFromCenter
} ActionSheetViewAppearDirection;

@interface ActionSheetView : UIView
@property (nonatomic, assign) CGFloat      backgroundAlpha;
@property (nonatomic, assign) BOOL         cancelHideWhenClickBorder;
@end

@interface ActionSheetViewController : WSBaseViewController

@end

@interface ActionSheetWindow : UIWindow

+ (ActionSheetWindow *)sharedInstace;

@property (nonatomic, weak, readonly) ActionSheetViewController *actionSheetViewController;

+ (void)showActionSheetView:(UIView *)actionSheetView
              withDirection:(ActionSheetViewAppearDirection)direction
             completeHandle:(void(^)(void))handle;

+ (void)hideActionSheetView;

+ (void)hideActionSheetViewCompleteHandle:(void(^)(void))handle;

@end
