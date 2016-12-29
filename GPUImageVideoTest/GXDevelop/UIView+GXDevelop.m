//
//  UIView+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 16/1/28.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import "UIView+GXDevelop.h"
#import <objc/runtime.h>

@interface UIView ()<CAAnimationDelegate>

@property (strong, nonatomic) CAGradientLayer *slideHighlightLayer;
@property (nonatomic) NSNumber * slideHighlightedDurtion;
@property (nonatomic) NSNumber * slideHighlightedScale;
@property (nonatomic) NSNumber * slideHighlightedInterval;
@property (nonatomic) NSNumber * slideHighlightedRepeatCount;

@end

@implementation UIView (GXDevelop)



- (CGFloat)gxX
{
    return CGRectGetMinX(self.frame);
}
- (void)setGxX:(CGFloat)gxX
{
    CGRect frame = self.frame;
    frame.origin.x = gxX;
    self.frame = frame;
}

- (CGFloat)gxY
{
    return CGRectGetMinY(self.frame);
}
- (void)setGxY:(CGFloat)gxY
{
    CGRect frame = self.frame;
    frame.origin.y = gxY;
    self.frame = frame;
}

- (CGFloat)gxMaxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setGxMaxX:(CGFloat)gxMaxX
{
    CGRect frame = self.frame;
    frame.origin.x = gxMaxX-self.gxWidth;
    self.frame = frame;
}

- (CGFloat)gxMaxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setGxMaxY:(CGFloat)gxMaxY
{
    CGRect frame = self.frame;
    frame.origin.y = gxMaxY-self.gxHeight;
    self.frame = frame;
}

- (CGPoint)gxOrigin
{
    return self.frame.origin;
}
- (void)setGxOrigin:(CGPoint)gxOrigin
{
    CGRect frame = self.frame;
    frame.origin = gxOrigin;
    self.frame = frame;
}

//- (CGFloat)gxMidX
//{
//    return CGRectGetMidX(self.frame);
//}
//- (CGFloat)gxMidY
//{
//    return CGRectGetMidY(self.frame);
//}
- (CGSize)gxSize
{
    return self.frame.size;
}
- (void)setGxSize:(CGSize)gxSize
{
    CGRect frame = self.frame;
    frame.size = gxSize;
    self.frame = frame;
}

- (CGFloat)gxWidth
{
    return CGRectGetWidth(self.frame);
}
- (void)setGxWidth:(CGFloat)gxWidth
{
    CGRect frame = self.frame;
    frame.size.width = gxWidth;
    self.frame = frame;
}

- (CGFloat)gxWidthHalf
{
    return CGRectGetWidth(self.frame)/2.0;
}
- (void)setGxWidthHalf:(CGFloat)gxWidthHalf
{
    CGRect frame = self.frame;
    frame.size.width = gxWidthHalf*2;
    self.frame = frame;
}

- (CGFloat)gxHeight
{
    return CGRectGetHeight(self.frame);
}
- (void)setGxHeight:(CGFloat)gxHeight
{
    CGRect frame = self.frame;
    frame.size.height = gxHeight;
    self.frame = frame;
}

- (CGFloat)gxHeightHalf
{
    return CGRectGetHeight(self.frame)/2.0;
}
- (void)setGxHeightHalf:(CGFloat)gxHeightHalf
{
    CGRect frame = self.frame;
    frame.size.height = gxHeightHalf*2;
    self.frame = frame;
}

- (CGSize)gxBsize
{
    return self.bounds.size;
}
- (void)setGxBsize:(CGSize)gxBsize
{
    CGRect frame = self.bounds;
    frame.size = gxBsize;
    self.bounds = frame;
}

- (CGFloat)gxBwidth
{
    return CGRectGetWidth(self.bounds);
}
- (void)setGxBwidth:(CGFloat)gxBwidth
{
    CGRect frame = self.bounds;
    frame.size.width = gxBwidth;
    self.bounds = frame;
}

- (CGFloat)gxBwidthHalf
{
    return CGRectGetWidth(self.bounds)/2.0;
}
- (void)setGxBwidthHalf:(CGFloat)gxBwidthHalf
{
    CGRect frame = self.bounds;
    frame.size.width = gxBwidthHalf*2;
    self.bounds = frame;
}

- (CGFloat)gxBheight
{
    return CGRectGetHeight(self.bounds);
}
- (void)setGxBheight:(CGFloat)gxBheight
{
    CGRect frame = self.bounds;
    frame.size.height = gxBheight;
    self.bounds = frame;
}

- (CGFloat)gxBheightHalf
{
    return CGRectGetHeight(self.bounds)/2.0;
}
- (void)setGxBheightHalf:(CGFloat)gxBheightHalf
{
    CGRect frame = self.bounds;
    frame.size.height = gxBheightHalf*2;
    self.bounds = frame;
}





//- (void)setGxMidX:(CGFloat)gxMidX
//{
//    CGRect frame = self.frame;
//    frame.origin.x = gxMidX-self.gxWidthHalf;
//    self.frame = frame;
//}
//- (void)setGxMidY:(CGFloat)gxMidY
//{
//    CGRect frame = self.frame;
//    frame.origin.y = gxMidY - self.gxHeightHalf;
//    self.frame = frame;
//}







- (CGPoint)gxCenter
{
    return self.center;
}
- (void)setGxCenter:(CGPoint)gxCenter
{
    self.center = gxCenter;
}

- (CGPoint)gxCenterIn
{
    return CGPointMake(self.gxWidthHalf, self.gxHeightHalf);
}




-(CGFloat)gxCenterX
{
    return self.center.x;
}
- (void)setGxCenterX:(CGFloat)gxCenterX
{
    CGPoint center = self.center;
    center.x = gxCenterX;
    self.center = center;
}

- (CGFloat)gxCenterY
{
    return self.center.y;
}
- (void)setGxCenterY:(CGFloat)gxCenterY
{
    CGPoint center = self.center;
    center.y = gxCenterY;
    self.center = center;
}

- (CGFloat)gxCenterInX
{
    return self.frame.size.width/2.;
}
- (CGFloat)gxCenterInY
{
    return self.frame.size.height/2.;
}


// Transform
- (CGFloat) gxXScale {
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat) gxYScale {
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat) gxRadians { 
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (CGFloat) gxAngle {
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a) * (180 / M_PI);
}

- (CGFloat) gxTx {
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (CGFloat) gxTy {
    CGAffineTransform t = self.transform;
    return t.ty;
}


- (UIColor *)gxGetColorFromPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

// 添加高光
- (CAGradientLayer *)slideHighlightLayer
{
    return objc_getAssociatedObject(self, @selector(slideHighlightLayer));
}
- (void)setSlideHighlightLayer:(CAGradientLayer *)slideHighlightLayer
{
    objc_setAssociatedObject(self, @selector(slideHighlightLayer), slideHighlightLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)slideHighlightedDurtion
{
    return objc_getAssociatedObject(self, @selector(slideHighlightedDurtion));
}
- (void)setSlideHighlightedDurtion:(NSNumber *)slideHighlightedDurtion
{
    objc_setAssociatedObject(self, @selector(slideHighlightedDurtion), slideHighlightedDurtion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)slideHighlightedInterval
{
    return objc_getAssociatedObject(self, @selector(slideHighlightedInterval));
}
- (void)setSlideHighlightedInterval:(NSNumber *)slideHighlightedInterval
{
    objc_setAssociatedObject(self, @selector(slideHighlightedInterval), slideHighlightedInterval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)slideHighlightedRepeatCount
{
    return objc_getAssociatedObject(self, @selector(slideHighlightedRepeatCount));
}
- (void)setSlideHighlightedRepeatCount:(NSNumber *)slideHighlightedRepeatCount
{
    objc_setAssociatedObject(self, @selector(slideHighlightedRepeatCount), slideHighlightedRepeatCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)slideHighlightedScale
{
    return objc_getAssociatedObject(self, @selector(slideHighlightedScale));
}
- (void)setSlideHighlightedScale:(NSNumber *)slideHighlightedScale
{
    objc_setAssociatedObject(self, @selector(slideHighlightedScale), slideHighlightedScale, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)gxAddSlideHighlightedEffectWithHighlightedColor:(UIColor *)highlightColor lowlightColor:(UIColor *)lowlightColor scale:(CGFloat)scale animDuration:(CGFloat)duration animInterval:(CGFloat)interval animRepeatCount:(NSInteger)repeatCount
{
    if (!highlightColor) {
        highlightColor = [UIColor whiteColor];
    }
    if (!lowlightColor) {
        lowlightColor = [UIColor blackColor];
    }
    if (!scale) {
        scale = 0.25;
    }
    if (!duration) {
        duration = 2.2;
    }
    if (!interval) {
        interval = 1;
    }
    if (!repeatCount) {
        repeatCount = NSIntegerMax;
    }
    self.slideHighlightedDurtion = @(duration);
    self.slideHighlightedInterval = @(interval);
    self.slideHighlightedRepeatCount = @(repeatCount);
    self.slideHighlightedScale = @(scale);
    
    CAGradientLayer *layerGr = [[CAGradientLayer alloc] init];
    layerGr.frame = self.frame;
    [self.superview.layer addSublayer:layerGr];
    self.slideHighlightLayer = layerGr;
    layerGr.colors = @[(__bridge id)lowlightColor.CGColor ,(__bridge id)highlightColor.CGColor ,(__bridge id)lowlightColor.CGColor];
    layerGr.locations = @[@(-scale*2), @(-scale), @(0)];
    layerGr.startPoint = CGPointMake(0, 0);
    layerGr.endPoint = CGPointMake(1, 0);
    
    layerGr.mask = self.layer;
    self.frame = layerGr.bounds;
    
    [self slideHighlightedEffectAnimation];
    
    return layerGr;
}

- (void)slideHighlightedEffectAnimation
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    fadeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeAnim.removedOnCompletion = NO;
    fadeAnim.repeatCount = self.slideHighlightedRepeatCount.integerValue ;
    //    fadeAnim.repeatCount = 1;
    fadeAnim.beginTime = CACurrentMediaTime()+ self.slideHighlightedInterval.floatValue;
    CGFloat scale = self.slideHighlightedScale.floatValue;
    fadeAnim.fromValue = @[@(-scale*2), @(-scale), @(0)];
    fadeAnim.toValue   = @[@(1.0), @(1+scale), @(1+scale*2)];
    fadeAnim.duration  = self.slideHighlightedDurtion.floatValue;
    fadeAnim.delegate = self;
    [self.slideHighlightLayer addAnimation:fadeAnim forKey:@"slideHighlightedEffectAnimation"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    if (self.slideHighlightedRepeatCount.intValue > 0) {
//        [self slideHighlightedEffectAnimation];
//        int count  = self.slideHighlightedRepeatCount.intValue;
//        self.slideHighlightedRepeatCount = @(count-1);
//    }
}
- (void)gxAddSlideHighlightedEffect
{
    [self gxAddSlideHighlightedEffectWithHighlightedColor:nil lowlightColor:nil scale:0 animDuration:0 animInterval:0 animRepeatCount:0];
}


- (UIImage *)gxGetViewShot
{
    NSAssert([NSThread isMainThread], nil);
    
    UIGraphicsBeginImageContext(self.bounds.size);
    BOOL isCom = [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    if (isCom) {
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return screenshot;
    } else {
        return nil;
    }
}
- (UIImage *)gxGetViewShotWithMarge:(CGFloat)marge
{
    CGRect frame = CGRectMake(-marge, -marge, CGRectGetWidth(self.bounds)+2*marge, CGRectGetHeight(self.bounds)+2*marge);

    UIGraphicsBeginImageContext(self.bounds.size);
    BOOL isCom = [self drawViewHierarchyInRect:frame afterScreenUpdates:NO];
    if (isCom) {
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return screenshot;
    } else {
        return nil;
    }
}

-(UIImage *)gxGetViewShotWithScale:(CGFloat)scale
{
    // Create the image context
    CGSize size = self.bounds.size;
    size = CGSizeMake(size.width*scale, size.height*scale);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    // Get the snapshot
    UIImage *snapshotImage = nil;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM (context, scale, scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}


- (void)gxConvertCoordinationTo:(UIView *)subView with:(CGContextRef)context{
    if (!subView || !context)
        return;
    
    NSAssert(([subView superview]==self), @"should be subview");
    
    CGPoint center = CGPointMake(subView.bounds.size.width/2, subView.bounds.size.height/2);
    center = [subView convertPoint:center toView:[subView superview]];
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextConcatCTM(context, subView.transform);
    CGContextTranslateCTM(context, -subView.bounds.size.width/2, -subView.bounds.size.height/2);
}
- (UIBezierPath *)gxConvertBezierPath:(UIBezierPath *)path to:(UIView *)view{
    if (!path)
        return nil;
    
    UIBezierPath *bPath = [UIBezierPath bezierPathWithCGPath:[path CGPath]];
    
    CGAffineTransform trans = CGAffineTransformIdentity;
    //    CGPoint center = [self convertPoint:CGPointMake(view.b_width/2, view.b_height/2) fromView:view];
    CGPoint topleft = [self convertPoint:CGPointMake(view.bounds.origin.x, view.bounds.origin.y) fromView:view];
    
    //    trans = CGAffineTransformTranslate(trans, (center.x-view.b_width/2), (center.y-view.b_height/2));
    //    trans = CGAffineTransformConcat(trans, view.transform);
    //    trans = CGAffineTransformInvert(trans);
    
    CGFloat scale = sqrt(view.transform.a*view.transform.a + view.transform.c*view.transform.c);
    CGFloat angle = atan2f(view.transform.b, view.transform.a);;
    
    trans = CGAffineTransformTranslate(trans, topleft.x, topleft.y);
    trans = CGAffineTransformScale(trans, scale, scale);
    trans = CGAffineTransformRotate(trans, angle);
    trans = CGAffineTransformInvert(trans);
    
    [bPath applyTransform:trans];
    
    
    return bPath;
}

@end
