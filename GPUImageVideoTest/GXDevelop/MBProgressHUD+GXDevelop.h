//
//  MBProgressHUD+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 16/1/7.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//
/**
 *这是对MBProgressHUD的一层包装
 */


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifdef MB_INSTANCETYPE

#import "MBProgressHUD.h"

@interface MBProgressHUD (GXDevelop)

/**
 *快速显示一个hud 信息
 */
+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font;
+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font margin:(CGFloat)margin;

+ (void)gxShowNotiInDebugInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font;

+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image attrText:(NSMutableAttributedString *)attrText;


+ (void)gxShowWaitInView:(UIView *)view text:(NSString *)text font:(UIFont *)font;
+ (void)gxShowWaitInView:(UIView *)view attrText:(NSMutableAttributedString *)attrText;

+ (void)gxShowWaitInView:(UIView *)view text:(NSString *)text font:(UIFont *)font margin:(CGFloat)margin;

+ (void)gxHideInView:(UIView *)view animated:(BOOL)animated;

@end

#endif
