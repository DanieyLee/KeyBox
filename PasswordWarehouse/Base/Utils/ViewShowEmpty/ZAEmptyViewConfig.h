//
//  ZAEmptyViewConfig.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EmptyStyle)
{
    RefreshClockOnFullScreenStyle = 0, /*点击屏幕刷新模式*/
    RefreshClickOnBtnStyle ,           /*含有重试按钮模式*/
    noRefreshStyle ,                   /*不含刷新模式*/
};

typedef NS_ENUM(NSInteger, ImageType)
{
    ImgTypeName = 0,    /*图片名称*/
    ImgTypeLocalUrl,    /*图片本地路径*/
    ImgTypeUrl ,        /*图片网络链接*/
    GifImgLocalUrl ,    /*gif图的本地路径，暂不支持网络url*/
};

@interface ZAEmptyViewConfig : NSObject
/**
 imageData 包括:
 - 本地图片名称
 - 本地图片路径
 - 网络图片url
 - 本地gif图片路径
 */
@property (nonatomic, strong) id imageData;

/**
 type为图片数据所属类型 默认图片名称
 */
@property (nonatomic, assign) ImageType type;

/**
 gif图的动画，建议不要进行自定义
 */
//@property (nonatomic, strong ,readwrite) CAKeyframeAnimation *gifAnimation;

/**
 简单动画的gif图片数组
 */
@property (nonatomic, strong) NSMutableArray *gifArray;

@end

@interface ZAEmptyStyle : NSObject


/**
 是否只显示文字，注意若打开后图片和按钮的设置将无效 默认NO
 */
@property (nonatomic, assign) BOOL isOnlyText;

/**
 数据源的个数,必要设置,默认在方法内部实现
 */
@property (nonatomic, assign) NSUInteger dataSourceCount;

/**
 如果需要再次刷新视图时的样式 默认2
 */
@property (nonatomic, assign) EmptyStyle refreshStyle;

/**
 图片集合体
 */
@property (nonatomic, strong) ZAEmptyViewConfig *imageConfig;

/**
 提示语
 */
@property (nonatomic, strong) NSString *tipText;

/**
 提示语的字体大小 默认标准字体17号
 */
@property (nonatomic, strong) UIFont *tipFont;

/**
 点击重试的按钮 (即将开放)
 */
//@property (nonatomic, strong) UIButton *button;

/**
 图片允许的最大宽度
 */
@property (nonatomic, assign) CGFloat imageMaxWidth;

/**
 图片的尺寸，默认 根据图片的大小自适应，设置后大小固定
 */
@property (nonatomic, assign) CGSize imageSize;

/**
 ! 图片的起点y值占父视图的比例 默认0.2f
 */
@property (nonatomic, assign) CGFloat imageOragionY;

/**
 btn的提示语 默认"重试"
 */
@property (nonatomic, strong) NSString *btnTipText;

/**
 btn的图片
 */
@property (nonatomic, strong) UIImage *btnImage;

/**
 btn的字体大小 默认标准字体15号
 */
@property (nonatomic, strong) UIFont *btnFont;

/**
 按钮的宽度
 */
@property (nonatomic, assign) CGFloat btnWidth;

/**
 按钮的高度
 */
@property (nonatomic, assign) CGFloat btnHeight;

/**
 按钮文字颜色 默认红色
 */
@property (nonatomic, strong) UIColor *btnTitleColor;

/**
 按钮圆角 默认2
 */
@property (nonatomic, assign) CGFloat btnLayerCornerRadius;

/**
 按钮的边框宽度
 */
@property (nonatomic, assign) CGFloat btnLayerborderWidth;

/**
 按钮边框颜色
 */
@property (nonatomic, strong) UIColor *btnLayerBorderColor;

/**
 提示文字的颜色
 */
@property (nonatomic, strong) UIColor *tipTextColor;

/**
 控件的父视图，主要是为了用户自定义superView 默认为控制器的view
 */
@property (nonatomic, weak) UIView *superView;


@property (nonatomic, strong) UIColor   *maskViewBackgorundColor;
/**
 按钮回调
 */
@property (nonatomic, copy  ) void(^btnAction)(void);


@end
