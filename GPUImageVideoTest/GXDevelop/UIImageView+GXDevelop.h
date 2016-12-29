//
//  UIImageView+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIImageView (GXDevelop)
/**
 *快速设置属性
 */
- (void)gxSetFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image;
- (void)gxSetContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image;

+ (UIImageView *)gxImageViewFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image;

+ (UIImageView *)gxImageViewContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image;



/**
 *  @author Gordon_LY, 16-09-08 14:09:45
 *
 *  图片360度旋转
 */
- (void)gxRotate360DegreeWithDuration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount;
- (void)gxStopRotate;


@end
