//
//  UIView+ShowEmpty.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "UIView+ShowEmpty.h"
#import "ZAEmptyViewConfig.h"
#import <objc/runtime.h>
#import "UIView+Frame.h"

static UITableViewCellSeparatorStyle superViewSeparatorStyle;/*不能使用const修饰*/
NSString *const za_defaultTipText = @"暂无内容";
NSString *const za_defaultBtnTipText = @"重试";
NSString *const za_btnKey = @"btnKey";
NSString *const za_labelKey = @"labelKey";
NSString *const za_blockKey = @"blockKey";
NSString *const za_imageKey = @"imageKey";
NSString *const za_styleKey = @"styleKey";
NSString *const za_isShowedKey = @"isShowedKey";
NSString *const za_coverViewKey = @"coverViewKey";

@interface UIView ()

@property (nonatomic, strong) NSString *isShowed; /*是否正在展示,主要防止重复添加*/

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation UIView (ShowEmpty)
static CGFloat superViewWidth = 0.0;
static CGFloat superViewHeight = 0.0;
static UITapGestureRecognizer *tempTapGes;

-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count
{
    if (!self.emptyStyle) {
        ZAEmptyStyle *wyhStyle = [[ZAEmptyStyle alloc]init];
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.superView = self;
        wyhStyle.isOnlyText = YES;
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.maskViewBackgorundColor = COLOR_BG;
        self.emptyStyle = wyhStyle;
    }
    
    self.emptyStyle.tipText = msg;
    self.emptyStyle.dataSourceCount = count;
    
    [self showWithStyle:self.emptyStyle];
}

-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count
           isHasBtn:(BOOL)hasBtn
            Handler:(void(^)(void))handleBlock
{
    if (!self.emptyStyle) {
        ZAEmptyStyle *wyhStyle = [[ZAEmptyStyle alloc]init];
        wyhStyle.superView = self;
        self.emptyStyle = wyhStyle;
        wyhStyle.imageConfig.imageData = @"icon_empty";
        wyhStyle.btnTitleColor = COLOUR_THEME;
        wyhStyle.maskViewBackgorundColor = [UIColor whiteColor];
    }
    self.emptyStyle.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
    self.emptyStyle.tipText = msg;
    self.emptyStyle.dataSourceCount = count;
    self.tipHandler = handleBlock;
    [self showWithStyle:self.emptyStyle];
}

-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count
      customImgName:(NSString *)imageName
{
    if (!self.emptyStyle) {
        ZAEmptyStyle *wyhStyle = [[ZAEmptyStyle alloc]init];
        wyhStyle.refreshStyle = noRefreshStyle;
        wyhStyle.tipFont = FONT(15);
        wyhStyle.isOnlyText = NO;
        if (imageName) {
            wyhStyle.imageConfig.type = ImgTypeName;
            wyhStyle.imageConfig.imageData = imageName;
        }
        wyhStyle.superView = self;
        self.emptyStyle = wyhStyle;
    }
    self.emptyStyle.tipText = msg;
    self.emptyStyle.dataSourceCount = count;
    [self showWithStyle:self.emptyStyle];
}

-(void)showEmptyMsg:(NSString *)msg
              dataCount:(NSUInteger)count
          customImgName:(NSString *)imageName
          imageOragionY:(CGFloat)imageOragionY
               isHasBtn:(BOOL)hasBtn
                Handler:(void(^)(void))handleBlock
{
    if (!self.emptyStyle) {
        ZAEmptyStyle *wyhStyle = [[ZAEmptyStyle alloc]init];
        wyhStyle.superView = self;
        wyhStyle.tipFont = FONT(15);
        self.emptyStyle = wyhStyle;
    }
    self.emptyStyle.refreshStyle = RefreshClockOnFullScreenStyle;
    self.emptyStyle.imageOragionY = imageOragionY;
    self.emptyStyle.tipText = msg;
    self.emptyStyle.imageConfig.imageData = imageName?:self.emptyStyle.imageConfig.imageData;
    self.emptyStyle.imageConfig.type = ImgTypeName;
    self.emptyStyle.dataSourceCount = count;
    
    if (!handleBlock) {
        self.emptyStyle.refreshStyle = noRefreshStyle;
    }else {
        self.tipHandler = handleBlock;
        self.emptyStyle.refreshStyle = hasBtn?RefreshClickOnBtnStyle:RefreshClockOnFullScreenStyle;
    }
    [self showWithStyle:self.emptyStyle];
}

/**
 自定义展示方法
 
 @param style 自定义样式
 */
-(void)showWithStyle:(ZAEmptyStyle *)style {
    
    if (style.dataSourceCount == 0) {
        
        if (YES==[self.isShowed boolValue]) return;
        
        [self removeSubViews];
        
        if (!style.superView) style.superView = self;
        
        self.isShowed = @"1";
        
        self.emptyStyle = style;
        
        [self setupCoverViewPostionWithStyle:style];
        
        [self setupSubViewsPositionWithStyle:style];
        
    }else{
        
        [self removeSubViews];
    }
}

/**
 布局coverView
 
 @param style 自定义样式
 */
-(void)setupCoverViewPostionWithStyle:(ZAEmptyStyle *)style{
    
    CGFloat coverX = 0.0;
    CGFloat coverY = 0.0;
    __block UITableView *coverTable;
    /** 为了更方便用户调用,默认直接将coverView加在tableView上,若有不同需求可自行在此修改*/
    if (![style.superView isKindOfClass:[UITableView class]]) {
        [style.superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITableView class]]) {
                coverTable = (UITableView *)obj;
                style.superView = coverTable;
                *stop = YES;
            }
        }];
    }
    
    if ([style.superView isKindOfClass:[UITableView class]]) {
        __block UIView *tableViewWrapperView;
        
        [((UITableView *)style.superView).subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                tableViewWrapperView = obj;
                *stop = YES;
            }
        }];
        //        style.superView = tableViewWrapperView;
        
        if (tableViewWrapperView.y != style.superView.y) {
            coverY = -64.0; /* 因为当某些导航栏透明效果影响,tableView的wrapperView起点会偏移64 */
        }
    }
    if (CGRectEqualToRect(style.superView.frame, CGRectZero)) {
        [style.superView layoutIfNeeded];
    }
    superViewWidth = style.superView.width;
    superViewHeight = style.superView.height;
    
    UIView *coverView = [[UIView alloc]init];
    coverView.frame = CGRectMake(coverX, coverY, superViewWidth, superViewHeight);
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = [UIColor clearColor];
    self.coverView = coverView;
    coverView.backgroundColor = style.maskViewBackgorundColor;
    [self.emptyStyle.superView addSubview:self.coverView];
}

/**
 根据style进行布局视图
 
 @param style 自定义样式
 */
-(void)setupSubViewsPositionWithStyle:(ZAEmptyStyle *)style {
    
    NSAssert(style, @"style样式不能为空，请检查");
    NSAssert(style.superView, @"必须需要设置父视图，请不要误删style.superView");
    
    if (style.isOnlyText) {
        self.tipImageView = nil;
        self.tipButton = nil;
        
        [self setupTipLabelWithStyle:style];
        
        if (self.tipHandler != nil) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
            tempTapGes = tap;
            self.coverView.userInteractionEnabled = YES;
            [self.coverView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        }
        
        return;
    }
    
    if (style.refreshStyle == RefreshClickOnBtnStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
        
        [self setupButtonWithStyle:style]; /*必须写在setLabel的后面*/
        
    }
    
    if (style.refreshStyle == RefreshClockOnFullScreenStyle) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickAction)];
        tempTapGes = tap;
        self.coverView.userInteractionEnabled = YES;
        [self.coverView addGestureRecognizer:tap]; /*建议superview自定义，避免用主控器的view直接添加手势*/
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
    }
    
    if (style.refreshStyle == noRefreshStyle) {
        
        [self setupImageViewWithStyle:style];
        
        [self setupTipLabelWithStyle:style];
    }
    
    //父视图若为tableView则应去除分割线
    if ([style.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)style.superView;
        if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            superViewSeparatorStyle = tableView.separatorStyle;/*全局变量superViewSeparatorStyle存储原分割线样式*/
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}

-(void)setupTipLabelWithStyle:(ZAEmptyStyle *)style{
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = !style.tipText ? za_defaultTipText : style.tipText;/* defaultTipText 为默认提示语*/
    tipLabel.textColor = style.tipTextColor;
    tipLabel.font = style.tipFont;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame = CGRectMake(0, 0, superViewWidth - 40, 0);
    [tipLabel sizeToFit];
    NSAssert(superViewHeight>tipLabel.height, @"设置的文本太长，超出了父视图的高度！");
    
    [self.coverView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    if (!style.isOnlyText) {
        
        NSAssert(self.tipImageView, @"setupTiplabel必须在setupImage之后，否则获取不到image的frame");
        
        CGFloat tipX = (superViewWidth - tipLabel.width) * 0.5;
        CGFloat tipY = self.tipImageView.bottom + 15;
        tipLabel.frame = CGRectMake(tipX, tipY, tipLabel.width, tipLabel.height);
        
    }else{
        
        tipLabel.frame = CGRectMake((superViewWidth - tipLabel.width)/2, (superViewHeight - tipLabel.height)/2, tipLabel.width, tipLabel.height);
    }
}

-(void)setupImageViewWithStyle:(ZAEmptyStyle *)style{
    
    NSAssert(style.imageConfig.imageData, @"图片数据不能为空");
    
    UIImageView *imgView = [[UIImageView alloc] init];
    
    
    switch (style.imageConfig.type) {
        case ImgTypeName: { imgView.image = [UIImage imageNamed:style.imageConfig.imageData]; } break;
            
        case ImgTypeLocalUrl:
        {
            NSString * filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:style.imageConfig.imageData];
            imgView.image = [UIImage imageWithContentsOfFile:filePath];
        }
            break;
            
        case ImgTypeUrl:
        {
            __block NSData *imgData;
            //此处暂时必须同步处理,若出现明显卡顿可用SDWebImage进行加载
            imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:style.imageConfig.imageData]];
            imgView.image = [[UIImage alloc]initWithData:imgData];
            
        }
            break;
        case GifImgLocalUrl:
        {
            imgView.animationImages = style.imageConfig.gifArray;
            imgView.animationDuration = 1;
            imgView.animationRepeatCount = MAXFLOAT;
            [imgView startAnimating];
        }
            break;
        default:
            break;
    }
    [imgView sizeToFit];
    if (style.imageSize.width != 0) {
        NSAssert(style.imageSize.width <= superViewWidth, @"");
        imgView.size = style.imageSize;
    }else{
        NSAssert(style.imageMaxWidth>0, @"图片允许的最大宽度不得小于0");
        CGFloat allowedMaxW = style.imageMaxWidth;
        CGFloat allowedMaxH = style.imageMaxWidth*imgView.height/imgView.width;
        imgView.width = imgView.width > allowedMaxW ? allowedMaxW :imgView.width;
        imgView.height = imgView.height > allowedMaxH ? allowedMaxH:imgView.height;
    }
    CGFloat imagVx = (superViewWidth - imgView.width) * 0.5;
    CGFloat imagVy = superViewHeight*style.imageOragionY;
    imgView.frame = CGRectMake(imagVx, imagVy, imgView.width, imgView.height);
    [self.coverView addSubview:imgView];
    self.tipImageView = imgView;
}

-(void)setupButtonWithStyle:(ZAEmptyStyle *)style{
    
    NSAssert(self.tipLabel != nil, @"setupBtn必须在setupLabel之后，否则获取不到label的frame");
    style.btnTipText = !style.btnTipText ? za_defaultBtnTipText : style.btnTipText;
    style.btnTitleColor = !style.btnTitleColor ? [UIColor redColor] : style.btnTitleColor;
    style.btnLayerBorderColor = !style.btnLayerBorderColor ? [UIColor lightGrayColor] : style.btnLayerBorderColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style.btnTipText forState:UIControlStateNormal];
    btn.titleLabel.font = style.btnFont?:[UIFont systemFontOfSize:15.f];
    if (style.btnImage) [btn setBackgroundImage:style.btnImage forState:(UIControlStateNormal)];
    [btn setTitleColor:style.btnTitleColor forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor lightGrayColor];
    btn.frame = CGRectZero;
    [btn sizeToFit];
    btn.width = btn.width>style.btnWidth?(btn.width+10):style.btnWidth;
    btn.height = btn.height>style.btnHeight?btn.height:style.btnHeight;
    CGFloat btnX = (superViewWidth - btn.width) * .5f;
    CGFloat btnY = CGRectGetMaxY(self.tipLabel.frame) + 20;/*20是一个神奇数字*/
    btn.x = btnX;
    btn.y = btnY;
    btn.layer.borderColor = style.btnLayerBorderColor.CGColor;
    btn.layer.borderWidth = style.btnLayerborderWidth;
    btn.layer.cornerRadius = style.btnLayerCornerRadius;
    btn.layer.masksToBounds = YES;
    self.tipButton = btn;
    [self.coverView addSubview:btn];
    self.coverView.userInteractionEnabled = YES;
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - btnClickAction
-(void)btnClickAction{
    if (self.emptyStyle.btnAction) {
        self.emptyStyle.btnAction();
    } else {
        //    NSLog(@"点击了刷新");
        [self removeSubViews]; /*remove一定要放在回调block之前*/
        
        if (self.tipHandler) {
            self.tipHandler();
        }
    }
}

-(void)removeSubViews{
    self.isShowed = @"0";
    if ([self.emptyStyle.superView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.emptyStyle.superView;
        tableView.separatorStyle = superViewSeparatorStyle;/*恢复分割线样式*/
    }
    if (tempTapGes!=nil) {
        [self.coverView removeGestureRecognizer:tempTapGes];
    }
    [self.tipLabel removeFromSuperview];
    [self.tipButton removeFromSuperview];
    [self.tipImageView removeFromSuperview];
    [self.coverView removeFromSuperview];
    
}

#pragma mark - setter and getter

#pragma mark - label
-(void)setTipLabel:(UILabel *)tipLabel{
    objc_setAssociatedObject(self, &za_labelKey, tipLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)tipLabel{
    
    return objc_getAssociatedObject(self, &za_labelKey);
}

#pragma mark - button
-(void)setTipButton:(UIButton *)tipButton{
    objc_setAssociatedObject(self, &za_btnKey, tipButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)tipButton{
    return objc_getAssociatedObject(self, &za_btnKey);
}

#pragma mark - imageView
-(void)setTipImageView:(UIImageView *)tipImageView{
    objc_setAssociatedObject(self, &za_imageKey, tipImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)tipImageView{
    return objc_getAssociatedObject(self, &za_imageKey);
}

#pragma mark - block
-(void)setTipHandler:(void (^)(void))tipHandler{
    objc_setAssociatedObject(self, &za_blockKey, tipHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)(void))tipHandler{
    return objc_getAssociatedObject(self, &za_blockKey);
}

#pragma mark - wyhStyle
-(void)setEmptyStyle:(ZAEmptyStyle *)emptyStyle{
    objc_setAssociatedObject(self, &za_styleKey, emptyStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ZAEmptyStyle *)emptyStyle{
    return objc_getAssociatedObject(self, &za_styleKey);
}

#pragma mark - isShowed
-(void)setIsShowed:(NSString *)isShowed{
    objc_setAssociatedObject(self, &za_isShowedKey, isShowed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)isShowed{
    return objc_getAssociatedObject(self, &za_isShowedKey);
}

#pragma mark - coverView
-(void)setCoverView:(UIView *)coverView{
    objc_setAssociatedObject(self, &za_coverViewKey, coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)coverView{
    return objc_getAssociatedObject(self, &za_coverViewKey);
}

@end
