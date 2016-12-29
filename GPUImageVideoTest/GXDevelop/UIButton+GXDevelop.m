//
//  UIButton+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import "UIButton+GXDevelop.h"
#import <objc/runtime.h>
#define kGxAddTapRippleEffectColor  @"kGxAddTapRippleEffectColor"
#define kGxAddTapRippleEffectDuration  @"kGxAddTapRippleEffectDuration"
#import "UIView+GXDevelop.h"

@interface UIButton ()<CAAnimationDelegate>
@property (assign, nonatomic) CGFloat gxRippleScaleMaxValue;
@end

@implementation UIButton (GXDevelop)

@dynamic gxImagesNHSD;
@dynamic gxTitleColorsNHSD;
@dynamic gxTitlesNHSD;

// 快速设置属性
- (void)setGxImagesNHSD:(NSArray *)gxImagesNHSD
{
    [self gxEnumerateNHSDArray:gxImagesNHSD UsingBlock:^(id obj, NSUInteger idx, BOOL *stop, UIControlState buttonState) {
        [self setImage:obj forState:buttonState];
    }];
}
- (void)setGxTitlesNHSD:(NSArray *)gxTitlesNHSD
{
    [self gxEnumerateNHSDArray:gxTitlesNHSD UsingBlock:^(id obj, NSUInteger idx, BOOL *stop, UIControlState buttonState) {
        [self setTitle:obj forState:buttonState];
    }];
}
- (void)setGxTitleColorsNHSD:(NSArray *)gxTitleColorsNHSD
{
    [self gxEnumerateNHSDArray:gxTitleColorsNHSD UsingBlock:^(id obj, NSUInteger idx, BOOL *stop, UIControlState buttonState) {
        [self setTitleColor:obj forState:buttonState];
    }];
}

- (void)gxEnumerateNHSDArray:(NSArray *)array UsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop, UIControlState buttonState))block
{
    __block UIControlState state = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            state = UIControlStateNormal;
        } else if (idx == 1) {
            state = UIControlStateHighlighted;
        }else if (idx == 2) {
            state = UIControlStateSelected;
        }else if(idx == 3) {
            state = UIControlStateDisabled;
        }
        if (![obj isKindOfClass:[NSNull class]]) { // null 跳过设置
            if (block) {
                block(obj, idx, stop, state);
            }
        }
    }];
}


// 水波

static char gxRippleColor;
static char gxRippleDuration;
static char RippleScaleMaxValue;

- (void)gxSetRippleColor:(UIColor *)rippleColor
{
    objc_setAssociatedObject(self, &gxRippleColor, rippleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)gxGetRippleColor
{
    return objc_getAssociatedObject(self, &gxRippleColor);
}
- (void)gxSetRippleDuration:(CGFloat)rippleDuration
{
    objc_setAssociatedObject(self, &gxRippleDuration, @(rippleDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)gxGetRippleDuration
{
    return [objc_getAssociatedObject(self, &gxRippleDuration) floatValue];
}

- (void)setGxRippleScaleMaxValue:(CGFloat)gxRippleScaleMaxValue
{
    objc_setAssociatedObject(self, &RippleScaleMaxValue, @(gxRippleScaleMaxValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)gxRippleScaleMaxValue
{
    return [objc_getAssociatedObject(self, &RippleScaleMaxValue) floatValue];
}

- (void)gxAddTapRippleEffectWithColor:(UIColor *)color scaleMaxValue:(CGFloat)value duration:(CGFloat)duration
{
    [self gxSetRippleColor:color];
    [self gxSetRippleDuration:duration];
    self.gxRippleScaleMaxValue = value;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRipple)];
    [self addGestureRecognizer:tap];
}
- (void)tapRipple {

    
//    NSLog(@"%@", self.layer.sublayers);
    UIColor *effectColor = [self gxGetRippleColor];
    CGFloat animationDurtion = [self gxGetRippleDuration];
    // 圆圈动画
    UIColor *stroke = effectColor?effectColor:[UIColor colorWithWhite:0.8 alpha:0.8];

    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    
    CGPoint shapePosition = [self convertPoint:self.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 3;
    
//    [self.layer addSublayer:circleShape];
    [self.layer insertSublayer:circleShape atIndex:0];
    
    self.layer.masksToBounds = NO;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.gxRippleScaleMaxValue, self.gxRippleScaleMaxValue, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = animationDurtion;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.delegate = self;
    [circleShape addAnimation:animation forKey:@"tapRipple"];
    
    // tap 事件覆盖 control 事件  需要手动执行control 事件
    id target = [self.allTargets anyObject];
    UIControlEvents event = self.allControlEvents;
    NSArray *actions = [self actionsForTarget:target forControlEvent:event];
    NSString * actionStr = [actions lastObject];
    SEL action = NSSelectorFromString(actionStr);
    if ([target respondsToSelector:action]) {
        [target performSelectorOnMainThread:action withObject:self waitUntilDone:NO];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.layer.sublayers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CAShapeLayer class]]) {
            [obj removeFromSuperlayer];
            *stop = YES;
        }
    }];
}


- (void)gxExchangePositionLableAndImageWithInterval:(CGFloat)interval
{
    CGFloat imageW = self.imageView.bounds.size.width + interval/2.;
    CGFloat lableW = self.titleLabel.bounds.size.width + interval/2.;
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, 0, imageW)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, lableW, 0, -lableW)];
}

- (void)gxSetInterval:(CGFloat)interval
{
    CGFloat scale = interval/2.;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, scale, 0, -scale)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -scale, 0, scale)];
}

- (void)gxSetImageAboveLabelWithInterval:(CGFloat)interval{
    CGRect titleRect = self.titleLabel.frame;        //文本控件在按钮中的frame值。
    CGRect imageRect = self.imageView.frame;  //图片控件在按钮中的frame值。
    CGFloat padding = interval;                                     //用于指定文本和图片的间隔值。
    CGFloat selfWidth = self.gxWidth;                                   //按钮控件的宽度
    CGFloat selfHeight = self.gxHeight;                                  //按钮控件的高度
    CGFloat totalHeight=titleRect.size.height+padding+imageRect.size.height;  //图文上下布局时所占用的总高度，注意这里也算上他们之间的间隔值padding
    self.titleEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                      (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2,
                                      -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                      -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2);
    
    self.imageEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                      (selfWidth /2 - imageRect.origin.x - imageRect.size.width /2),
                                      -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                      -(selfWidth /2 - imageRect.origin.x - imageRect.size.width /2));
}

@end
