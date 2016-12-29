//
//  UIBezierPath+GXDevelop.h
//  GXDevelopDemo
//
//  Created by 高才新 on 16/3/31.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *渐变的方向
 */
typedef enum : NSUInteger {
    GXBezierPathRemoveSemicircularDirectionTop,
    GXBezierPathRemoveSemicircularDirectionDown,
    GXBezierPathRemoveSemicircularDirectionLeft,
    GXBezierPathRemoveSemicircularDirectionRight
} GXBezierPathRemoveSemicircularDirectionOption;

@interface UIBezierPath (GXDevelop)

/**
 *放回一个UIBezierPath. 矩形去掉莫一边半圆的 path   用于绘制图形
 */
+ (UIBezierPath *)gxBezierPathRectRemoveSemicircular:(CGRect)rect directionOption:(GXBezierPathRemoveSemicircularDirectionOption)directionOption;
@end
