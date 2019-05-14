//
//  ZAEmptyViewConfig.m
//  ZJHFZ
//
//  Created by 喵喵炭 on 2018/3/13.
//  Copyright © 2018年 于宁博. All rights reserved.
//

#import "ZAEmptyViewConfig.h"
#import <ImageIO/ImageIO.h>

@implementation ZAEmptyViewConfig

-(void)setType:(ImageType)type{
    if (_type != type) {
        _type = type;
        if (type == GifImgLocalUrl) { /* 注意:当自定义gif图时,若要自定imageData请再setType之后设置 */
//            self.imageData = @"WyhEmpty.bundle/转圈圈.gif";
            self.gifArray = [self imagesWithGif:self.imageData].mutableCopy;
        }
    }
}

-(NSArray *)imagesWithGif:(NSString *)gifNameInBoundle {
    
    NSAssert(gifNameInBoundle, @"gif路径不得为空");
    
    NSString *dataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:gifNameInBoundle];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArr addObject:image];
        CGImageRelease(imageRef);
    }
    CFRelease(gifSource);
    return imageArr;
}


@end

@implementation ZAEmptyStyle

-(instancetype)init{
    if (self = [super init]) {
        self.isOnlyText = NO;
        self.refreshStyle = noRefreshStyle;
        self.imageConfig = [[ZAEmptyViewConfig alloc]init];
        self.imageMaxWidth = 300;
        self.imageConfig.type = ImgTypeLocalUrl;
//        self.imageConfig.imageData = @"WyhEmpty.bundle/nonetwork";
        self.btnTipText = @"重试";
        self.btnFont = [UIFont systemFontOfSize:15];
        self.btnImage = nil;
        self.btnTitleColor = [UIColor redColor];
        self.btnLayerBorderColor = HexColor(0xf4f5f6);
        self.btnLayerCornerRadius = 2;
        self.btnLayerborderWidth = 1;
        self.btnWidth = 100;
        self.btnHeight = 35;
        self.tipTextColor = [UIColor lightGrayColor];
        self.tipFont = [UIFont systemFontOfSize:17.0f];
        self.imageOragionY = 0.2f;/*默认起点位置在屏幕高的20%位置上*/
        self.maskViewBackgorundColor = [UIColor clearColor];
    }
    return self;
}

@end
