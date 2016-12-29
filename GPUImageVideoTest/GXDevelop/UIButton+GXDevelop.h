//
//  UIButton+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIButton (GXDevelop)

// 快速设置属性
/**
 * 属性的各种数组NHSD 是数组各种状态的开头大写字母 如 :
Btn.gxImagesNHSD = @[image1,[nsnull null], image2];会自动设置UIControlStateNormal和UIControlStateSelected的图片.
 如果想跳过某属性 填[nsnull null]
 */
@property (nonatomic, strong) NSArray * gxImagesNHSD;
@property (nonatomic, strong) NSArray * gxTitlesNHSD;
@property (nonatomic, strong) NSArray * gxTitleColorsNHSD;

/**
 *给按钮添加一个点击出现波纹的效果 内部会设置self.layer.masksToBounds = NO; scaleMaxValue是波纹最大延展半径相对于本身半径的倍数
 */
- (void)gxAddTapRippleEffectWithColor:(UIColor *)color scaleMaxValue:(CGFloat)value duration:(CGFloat)duration;

/**
 *交换图片和 label 的位置  右图字左 interval:间隔值
 */
- (void)gxExchangePositionLableAndImageWithInterval:(CGFloat)interval;
/**
 *图片和 label 的间隔 interval:间隔值
 */
- (void)gxSetInterval:(CGFloat)interval;

/**
 *图片和 label 的间隔 interval:间隔值
 */
- (void)gxSetImageAboveLabelWithInterval:(CGFloat)interval;
@end
