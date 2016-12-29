//
//  UIView+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 16/1/28.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIView (GXDevelop)

// 坐标
@property (nonatomic, assign) CGPoint gxOrigin;
@property (nonatomic, assign) CGFloat gxX;
@property (nonatomic, assign) CGFloat gxY;
@property (nonatomic, assign) CGFloat gxMaxX;
@property (nonatomic, assign) CGFloat gxMaxY;

// 尺寸
// frame
@property (nonatomic, assign) CGSize  gxSize;
@property (nonatomic, assign) CGFloat gxWidth;
@property (nonatomic, assign) CGFloat gxHeight;
@property (nonatomic, assign) CGFloat gxWidthHalf;
@property (nonatomic, assign) CGFloat gxHeightHalf;
// bounds
@property (nonatomic, assign) CGSize  gxBsize;
@property (nonatomic, assign) CGFloat gxBwidth;
@property (nonatomic, assign) CGFloat gxBheight;
@property (nonatomic, assign) CGFloat gxBwidthHalf;
@property (nonatomic, assign) CGFloat gxBheightHalf;

// 中心点
@property (nonatomic, assign) CGPoint gxCenter;
@property (nonatomic, assign, readonly) CGPoint gxCenterIn;
@property (nonatomic, assign) CGFloat gxCenterX;
@property (nonatomic, assign) CGFloat gxCenterY;
@property (nonatomic, assign, readonly) CGFloat gxCenterInX;
@property (nonatomic, assign, readonly) CGFloat gxCenterInY;

/**
 * Shortcut for transform
 *
 */
@property (nonatomic, readonly) CGFloat gxRadians;  // 弧度
@property (nonatomic, readonly) CGFloat gxAngle;    // 角度
@property (nonatomic, readonly) CGFloat gxXScale;
@property (nonatomic, readonly) CGFloat gxYScale;
@property (nonatomic, readonly) CGFloat gxTx;
@property (nonatomic, readonly) CGFloat gxTy;




/**
 *获取 view的 layer 上某点的颜色
 */
- (UIColor *)gxGetColorFromPoint:(CGPoint)point;

/**
 *给一个 view 添加滑动高光效果  类似 iphone 锁屏"滑动来解锁"效果
 注意:设置前需要将 view 的 frame 设置完成并且已经添加到 superview
 */
- (void)gxAddSlideHighlightedEffect;
/**
 *自定义 高光效果
 scale 0-1 // 高光宽度占据比例
 */
- (CAGradientLayer *)gxAddSlideHighlightedEffectWithHighlightedColor:(UIColor *)highlightColor lowlightColor:(UIColor *)lowlightColor scale:(CGFloat)scale animDuration:(CGFloat)duration animInterval:(CGFloat)interval animRepeatCount:(NSInteger)repeatCount;

/**
 *获取屏幕截图
 */
- (UIImage *)gxGetViewShot;
/**
 *获取屏幕截图 marge:内边距
 */
- (UIImage *)gxGetViewShotWithMarge:(CGFloat)marge;
/**
 *获取屏幕截图 scale:缩放
 */
-(UIImage *)gxGetViewShotWithScale:(CGFloat)scale;


- (void)gxConvertCoordinationTo:(UIView *)subView with:(CGContextRef)context;
- (UIBezierPath *)gxConvertBezierPath:(UIBezierPath *)path to:(UIView *)view;

@end
