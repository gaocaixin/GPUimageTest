//
//  UIImageView+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import "UIImageView+GXDevelop.h"

@implementation UIImageView (GXDevelop)

- (void)gxSetFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image
{
    [self setFrame:frame];
    self.contentMode = contentMode;
    if (image) {
        self.image = image;
    }
    if (!backgroundColor) {
        backgroundColor = [UIColor clearColor];    
    }
    self.backgroundColor = backgroundColor;
}

- (void)gxSetContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image
{
    self.contentMode = contentMode;
    if (image) {
        self.image = image;
    }
    if (!backgroundColor) {
        backgroundColor = [UIColor clearColor];
    }
    self.backgroundColor = backgroundColor;
}

+ (UIImageView *)gxImageViewFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView gxSetFrame:frame contentMode:contentMode backgroundColor:backgroundColor image:image];
    return imageView;
}

+ (UIImageView *)gxImageViewContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView gxSetContentMode:contentMode backgroundColor:backgroundColor image:image];
    return imageView;
}

/**
 *  @author Gordon_LY, 16-09-08 14:09:41
 *
 *  旋转
 */
- (void)gxRotate360DegreeWithDuration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)gxStopRotate {
    [self.layer removeAllAnimations];
}

@end
