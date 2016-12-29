//
//  CALayer+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface CALayer (GXDevelop)

/**
 *获取 layer 上某点的颜色
 */
- (UIColor *)gxGetColorFromPoint:(CGPoint)point;

/**
 *  给layer添加阴影
 *
 *  @param color   颜色
 *  @param offset  偏移量
 *  @param blur    blur radius
 *  @param opacity 透明
 *  @param rect    shadowPath
 */
- (void)gxAddShadowWithShadowColor:(CGColorRef)color shadowRadius:(CGFloat)blur shadowOpacity:(CGFloat)opacity shadowPath:(CGRect)rect;

/**
 *  设置圆角
 */
- (void)gxSetRoundRect;

- (void)gxSetCornerRadius:(CGFloat)radius;


@end
