//
//  UIView+ShowEmpty.h
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZAEmptyStyle;

@interface UIView (ShowEmpty)
/**
 若自定义style，有点击方法时，给外界做处理,若没自定义建议使用
 showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count Handler:(void(^)())handleBlock
 */
@property (nonatomic, copy) void(^tipHandler)(void);

/**
 自定义style
 */
@property (nonatomic, strong) ZAEmptyStyle *emptyStyle;


/**
 根据数据源个数展示纯文本视图
 
 @param msg 提示语
 @param count 数据源个数
 */
-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count;

/**
 展示带点击刷新的提示视图
 
 @param msg 提示语
 @param count 数据源个数 若不想通过数据源判断一直传0即可
 @param hasBtn 是否含有Btn 带btn->YES 点击屏幕->NO
 @param handleBlock 刷新方法回调
 */
-(void)showEmptyMsg:(NSString *)msg
              dataCount:(NSUInteger)count
           isHasBtn:(BOOL)hasBtn
            Handler:(void(^)(void))handleBlock;

/**
 根据数据源个数展示自定义图片的提示视图
 
 @param msg 提示语
 @param count 数据源个数
 @param imageName 图片名称,传nil使用默认图
 */
-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count
      customImgName:(NSString *)imageName;

/**
 新增方法
 
 @param msg 提示语
 @param count 数据源个数
 @param imageName 图片名字
 @param handleBlock 回调的block
 */
-(void)showEmptyMsg:(NSString *)msg
              dataCount:(NSUInteger)count
          customImgName:(NSString *)imageName
          imageOragionY:(CGFloat)imageOragionY
               isHasBtn:(BOOL)hasBtn
                Handler:(void(^)(void))handleBlock;



/**
 自定义展示方法
 
 @param style 自定义样式
 */
-(void)showWithStyle:(ZAEmptyStyle *)style;
@end
