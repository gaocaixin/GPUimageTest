//
//  UINavigationBar+GXDevelop.h
//  GIFY
//
//  Created by 高才新 on 16/5/17.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (GXDevelop)


/**
 * 全局自定义导航栏 背景颜色和 shadow颜色  背景颜色透明度不能为0   注意 设置之后可能会改变 UIframe的 Y 值
 */
+ (void)gxSetGlobalNavBarBgColor:(UIColor *)bgColor shadowColor:(UIColor *)shadowColor;

/**
 *全局将导航栏设置全透明   注意 设置之后可能会改变 UIframe的 Y 值
 */
+ (void)gxSetGlobalNavBarFullClear;

/**
 * 自定义导航栏 背景颜色和 shadow颜色  背景颜色透明度不能为0   注意 设置之后可能会改变 UIframe的 Y 值
 */
- (void)gxSetNavBarBgColor:(UIColor *)bgColor shadowColor:(UIColor *)shadowColor;

/**
 *将导航栏设置全透明   注意 设置之后可能会改变 UIframe的 Y 值
 */
- (void)gxSetNavBarFullClear;


/**
 *  @author Gordon_LY, 16-09-13 10:09:44
 *
 *  更改导航栏的背景色，title等
 */
- (void)gxUpdateNavBarAppearanceFont:(UIFont *)font titleColor:(UIColor *)titleColor barBgColor:(UIColor *)barBgColor;

@end
