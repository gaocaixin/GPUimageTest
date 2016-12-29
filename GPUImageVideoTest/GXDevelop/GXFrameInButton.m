//
//  GXFrameInButton.m
//  LOCO
//
//  Created by 高才新 on 16/2/26.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import "GXFrameInButton.h"
#import "UIButton+GXDevelop.h"

@interface GXFrameInButton ()


/**  记录btn的borderColor  */
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,strong) UIColor *borderColorHalf;

@end

@implementation GXFrameInButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _gxTitleLabelFrame  = CGRectZero;
        _gxImageViewFrame = CGRectZero;

    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    if ([NSStringFromCGRect(_gxTitleLabelFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        return [super titleRectForContentRect:contentRect];
//    } else {
//        return _gxTitleLabelFrame;
//    }
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    if ([NSStringFromCGRect(_gxImageViewFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        return [super imageRectForContentRect:contentRect];
//    } else {
//        return _gxImageViewFrame;
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectIsEmpty(self.gxImageViewFrame)) {
        self.imageView.frame = self.gxImageViewFrame;
    }
    if (!CGRectIsEmpty(self.gxTitleLabelFrame)) {
        self.titleLabel.frame = self.gxTitleLabelFrame;
    }
    
    
}

- (void)setGxTitleLabelFrame:(CGRect)gxTitleLabelFrame
{
    _gxTitleLabelFrame = gxTitleLabelFrame;
    [self setNeedsLayout];
}

//- (CGRect)gxTitleLabelFrame
//{
//    return _gxTitleLabelFrame;
//}

- (void)setGxImageViewFrame:(CGRect)gxImageViewFrame
{
    _gxImageViewFrame = gxImageViewFrame;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if (_gxIsExchangePosition) {
        [self gxExchangePositionLableAndImageWithInterval:0];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_gxIsAnimationClick) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            if (highlighted) {
                self.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } else {
                self.transform = CGAffineTransformIdentity;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    if (self.isBorderAnimate) {
        if (highlighted) {
            self.layer.borderColor = self.borderColorHalf.CGColor;
        } else {
            self.layer.borderColor = self.borderColor.CGColor;
        }
    }
}

- (void)setBorderAnimate:(BOOL)borderAnimate
{
    _gxBorderAnimate = borderAnimate;
    self.borderColor = [UIColor colorWithCGColor:self.layer.borderColor];
    self.borderColorHalf = [self.borderColor colorWithAlphaComponent:0.5];
}

@end
