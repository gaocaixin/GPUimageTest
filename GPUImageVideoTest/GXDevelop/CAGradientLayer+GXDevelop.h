//
//  CAGradientLayer+GXDevelop.h
//  GXDevelopDemo
//
//  Created by 高才新 on 16/3/31.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
/**
 *渐变的方向
 */
typedef enum : NSUInteger {
    GXGradientLayerDirectionTopToDown,
    GXGradientLayerDirectionLeftToRight,
    GXGradientLayerDirectionTopLeftToDownRight,
    GXGradientLayerDirectionTopRightToDownLeft,
    GXGradientLayerDirectionOther
}   GXGradientLayerDirectionOption;


@interface CAGradientLayer (GXDevelop)

/*
 *    快速返回一个渐变的 layer colors 起始的颜色值
 */
+ (CAGradientLayer *)gxGradientLayerWithColors:(NSArray *)colors layerFrame:(CGRect)frame direction:(GXGradientLayerDirectionOption)direction;
/*
 *    快速返回一个渐变的 layer colors 起始的颜色值
 */
+ (CAGradientLayer *)gxGradientLayerWithColors:(NSArray *)colors layerFrame:(CGRect)frame startPoint:(CGPoint)start endPoint:(CGPoint)end;

@end
