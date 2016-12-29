//
//  GXDevelopExtern.h
//  GXDevelopDemo
//
//  Created by 高才新 on 16/3/29.
//  Copyright © 2016年 高才新. All rights reserved.
//

// 用于适配 记录宽高比例等数据

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//typedef enum : NSUInteger { // 没想好 暂时不加
//    GXScreenRatioNormal,    // 正常比例 iphone6 系列等
//    GXScreenRatioCompact,   // 紧凑比例 iphone5 系列等
//    GXScreenRatioLoose      // 宽松比例 ipad 系列等
//} GXScreenRatioType;


//ipad 1:       1024×768像素。长宽比：1.33。
//ipad 2:       1024x768像素。
//ipad 3:       2048×1536像素。
//ipad 4:       2048×1536像素。
//ipad air:     2048×1536像素。
//ipad air2:    2048×1536像素。
//ipad mini:    1024×768像素。
//ipad mini2:   2048×1536像素。

//iphone 4/4s:               分辨率960*640，长宽比：1.5。
//iphone 5/5c/5s/se/6zoom:   分辨率1136*640，长宽比：1.775。
//iphone 6/6s/7/7s:          分辨率1334*750，长宽比：1.779。
//iphone 6+zoom/7+zoom:      分辨率2001*1125，长宽比：1.778。
//iphone 6+/7+:              分辨率2208*1242，长宽比：1.778。


@interface GXDevelopExtern : NSObject

// 全局单例 记录屏幕缩放比例
+ (instancetype)sharedExtern;


@property (nonatomic )  CGFloat  gxScreenWidth;
@property (nonatomic )  CGFloat  gxScreenHeight;
@property (nonatomic )  CGFloat  gxScreenWidthRatio;    // 宽比例
@property (nonatomic )  CGFloat  gxScreenHeightRatio;   // 高比例
@property (nonatomic )  CGFloat  gxScreenWHminRatio;    // 宽高最小比例
@property (nonatomic )  CGFloat  gxScreenWHmaxRatio;    // 宽高最大比例
@property (nonatomic )  CGFloat  gxScreenRatio;         // 屏幕宽高比

//@property (nonatomic )  GXScreenRatioType  screenRatioType; // 屏幕类型

- (void)refreshData;
- (void)refreshDataIfNeed;
@end
