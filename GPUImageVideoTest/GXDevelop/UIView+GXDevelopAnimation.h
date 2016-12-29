//
//  UIView+GXDevelopAnimation.h
//  LOCO
//
//  Created by 高才新 on 15/12/24.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIView (GXDevelopAnimation)
/**
 *给 view 添加一个永久旋转的动画 可通过 view.layer 移除动画
 */
- (CABasicAnimation *)gxAddNotStopRotateAnimationDuration:(CGFloat)duration key:(NSString *)key;
/**
 *给 view 添加一个左右震动动画
 */
- (CAAnimation *)gxShakeAnimationWithShakeValue:(CGFloat)value duration:(CGFloat)duration key:(NSString *)key;
/**
 *给 view 添加一个高亮提示条
 * duration默认是 0.5，动画时间跟间隔时间是 1：4
 * key 为 nil 的时候删除动画
 */
- (void)gxHighlightAnimationWithDuration:(CGFloat)duration key:(NSString *)key;

/**
 * 给 view 添加一个Shimmer动画
 * path       ：shimmer path（为nil的时候会删除shimmer动画），
 * w          ：画笔线宽（默认为2），
 * stokeColor ：画笔颜色（默认为白色）
 */
- (void)gxShimmerWith:(UIBezierPath *)path width:(CGFloat)w andColor:(UIColor *)stokeColor;

/**
 * 给 view 添加一个呼吸动画
 * color      ：呼吸蒙版颜色
 * duration   ：动画时长（默认5秒），
 * key        ：为 nil 的时候删除动画
 */
- (CAAnimation *)gxBreathAnimationWith:(UIColor *)color duration:(CGFloat)duration key:(NSString *)key;
@end
