//
//  UIView+GXDevelopAnimation.m
//  LOCO
//
//  Created by 高才新 on 15/12/24.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+GXDevelopAnimation.h"
#import "UIView+GXDevelop.h"
//#import <FBShimmering/FBShimmeringView.h>
//#import <FBShimmering/FBShimmeringLayer.h>

@implementation UIView (GXDevelopAnimation)


- (CABasicAnimation *)gxAddNotStopRotateAnimationDuration:(CGFloat)duration key:(NSString *)key
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:rotationAnimation forKey:key];
    return rotationAnimation;
}


- (CAAnimation *)gxShakeAnimationWithShakeValue:(CGFloat)value duration:(CGFloat)duration key:(NSString *)key
{
    
    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shake setDuration:duration];
    [shake setValues:@[ @(-value), @(value), @(-value), @(value), @(-value/2), @(value/2), @(-value/4), @(value/4), @(0) ]];
    [self.layer addAnimation:shake forKey:key];
    return shake;
}


//static char uiviewHighlightLayer;
//- (void)gxHighlightAnimationWithDuration:(CGFloat)duration key:(NSString *)key{
//    CAGradientLayer *gradiLayer = objc_getAssociatedObject(self, &uiviewHighlightLayer);
//    if (key.length <= 0) {
//        [gradiLayer removeFromSuperlayer];
//        gradiLayer = nil;
//        objc_setAssociatedObject(self, &uiviewHighlightLayer, gradiLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        return;
//    }
//    CGSize layersize = CGSizeMake(self.b_height*3, self.b_height);
//    if (!gradiLayer) {
//        gradiLayer = [CAGradientLayer layer];
//        gradiLayer.frame = CGRectMake(0, 0, layersize.width, layersize.height);
//        gradiLayer.colors = @[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
//                              (id)[UIColor colorWithWhite:1.0 alpha:0.6].CGColor,
//                              (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor];
//        gradiLayer.locations = @[@(0.0), @(0.5), @(1.0)];
//        gradiLayer.startPoint = CGPointMake(0.2, 0.4);
//        gradiLayer.endPoint   = CGPointMake(0.8, 0.6);
//        [self.layer addSublayer:gradiLayer];
//        objc_setAssociatedObject(self, &uiviewHighlightLayer, gradiLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    [gradiLayer removeAllAnimations];
//    gradiLayer.frame = CGRectMake(-layersize.width, 0, layersize.width, layersize.height);
//    
//    duration = duration*5;
//    if (duration == 0)
//        duration = 2.5;
//    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    rotationAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-layersize.width/2, self.b_height/2)];
//    rotationAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((self.b_width+layersize.width/2)*5, self.b_height/2)];
//    rotationAnimation.duration = duration;
////    rotationAnimation.autoreverses = YES;
//    rotationAnimation.repeatCount = CGFLOAT_MAX;
//    [gradiLayer addAnimation:rotationAnimation forKey:key];
//}
//
//static char uiviewShimerLayer;
//- (void)gxShimmerWith:(UIBezierPath *)path width:(CGFloat)w andColor:(UIColor *)stokeColor{
//    FBShimmeringLayer *shimmerLayer = objc_getAssociatedObject(self, &uiviewShimerLayer);
//    if (w==0)
////        w = 2;
//    if (!stokeColor)
//        stokeColor = [UIColor whiteColor];
//    
//    if (path) {
//        if (!shimmerLayer) {
//            shimmerLayer = [FBShimmeringLayer layer];
//            shimmerLayer.frame = self.bounds;
//            objc_setAssociatedObject(self, &uiviewShimerLayer, shimmerLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            [self.layer addSublayer:shimmerLayer];
//        }
//        
//        CAShapeLayer *layer = (CAShapeLayer *)shimmerLayer.contentLayer;
//        if (!layer) {
//            layer = [CAShapeLayer layer];
//            layer.frame = shimmerLayer.bounds;
//            layer.strokeColor = [UIColor whiteColor].CGColor;
//            layer.fillColor = [UIColor clearColor].CGColor;
//            shimmerLayer.contentLayer = layer;
//        }
//        layer.strokeColor = [stokeColor CGColor];
//        layer.path = path.CGPath;
//        layer.lineWidth = 2;
//        shimmerLayer.shimmering = YES;
//    }else{
//        [shimmerLayer removeFromSuperlayer];
//        shimmerLayer = nil;
//        objc_setAssociatedObject(self, &uiviewShimerLayer, shimmerLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}
//
//static char uiviewBreathLayer;
//- (CAAnimation *)gxBreathAnimationWith:(UIColor *)color duration:(CGFloat)duration key:(NSString *)key
//{
//    CAShapeLayer *layer = objc_getAssociatedObject(self, &uiviewBreathLayer);
//    if (key.length <= 0) {
//        [layer removeFromSuperlayer];
//        layer = nil;
//        objc_setAssociatedObject(self, &uiviewBreathLayer, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        return nil;
//    }
//    if (!color)
//        color = [UIColor whiteColor];
//    if (!duration)
//        duration = 5;
//    
//    if (!layer) {
//        layer = [CAShapeLayer layer];
//        layer.frame = self.bounds;
//        layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
//        layer.lineWidth = 0;
//        [self.layer addSublayer:layer];
//        objc_setAssociatedObject(self, &uiviewBreathLayer, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    layer.fillColor = color.CGColor;
//    
//    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [shake setDuration:duration];
//    [shake setValues:@[ @(0), @(.7), @(0), @(0), @(0)]];
//    shake.repeatCount = CGFLOAT_MAX;
//    
//    [layer addAnimation:shake forKey:key];
//    return shake;
//}
@end
