//
//  CALayer+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import "CALayer+GXDevelop.h"

@implementation CALayer (GXDevelop)


- (UIColor *)gxGetColorFromPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

/**
 *  给layer添加阴影
 *
 *  @param color   颜色
 *  @param offset  偏移量
 *  @param blur    blur radius
 *  @param opacity 透明
 *  @param rect    shadowPath
 */
- (void)gxAddShadowWithShadowColor:(CGColorRef)color shadowRadius:(CGFloat)blur shadowOpacity:(CGFloat)opacity shadowPath:(CGRect)rect
{
    self.shadowColor = color;
    self.shadowRadius = blur;
    self.shadowOpacity = opacity;
    self.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

- (void)gxSetRoundRect
{
    self.cornerRadius = self.bounds.size.height * 0.5;
    self.masksToBounds = YES;
}
- (void)gxSetCornerRadius:(CGFloat)radius
{
    self.cornerRadius = radius;
    self.masksToBounds = YES;
}


@end
