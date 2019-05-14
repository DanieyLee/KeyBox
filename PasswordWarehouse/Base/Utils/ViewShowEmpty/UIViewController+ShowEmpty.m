//
//  UIViewController+ShowEmpty.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "UIViewController+ShowEmpty.h"
#import "UIView+ShowEmpty.h"
#import "ZAEmptyViewConfig.h"
#import <objc/runtime.h>

@implementation UIViewController (ShowEmpty)

-(void)showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count
{
    self.view.emptyStyle = self.emptyStyle;
    [self.view showEmptyMsg:msg dataCount:count];
}

-(void)showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count isHasBtn:(BOOL)hasBtn Handler:(void(^)(void))handleBlock
{
    self.view.emptyStyle = self.emptyStyle;
    [self.view showEmptyMsg:msg dataCount:count isHasBtn:hasBtn Handler:handleBlock];
}

-(void)showEmptyMsg:(NSString *)msg dataCount:(NSUInteger)count customImgName:(NSString *)imageName{
    
    self.view.emptyStyle = self.emptyStyle;
    [self.view showEmptyMsg:msg dataCount:count customImgName:imageName];
}

-(void)showEmptyMsg:(NSString *)msg
          dataCount:(NSUInteger)count
      customImgName:(NSString *)imageName
      imageOragionY:(CGFloat)imageOragionY
           isHasBtn:(BOOL)hasBtn
            Handler:(void(^)(void))handleBlock{
    
    [self.view showEmptyMsg:msg dataCount:count customImgName:imageName imageOragionY:imageOragionY isHasBtn:hasBtn Handler:handleBlock];
    
}


-(void)showWithStyle:(ZAEmptyStyle *)style{
    
    [self.view showWithStyle:style];
}


#pragma mark - block

-(void)setTipHandler:(void (^)(void))tipHandler{
    self.view.tipHandler = tipHandler;
}
-(void (^)(void))tipHandler{
    return self.view.tipHandler;
}

#pragma mark - wyhStyle
-(void)setEmptyStyle:(ZAEmptyStyle *)emptyStyle {
    self.view.emptyStyle = emptyStyle;
}
-(ZAEmptyStyle *)emptyStyle {
    return self.view.emptyStyle;
}

@end

