//
//  CAGradientLayer+GXDevelop.m
//  GXDevelopDemo
//
//  Created by 高才新 on 16/3/31.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import "CAGradientLayer+GXDevelop.h"

@implementation CAGradientLayer (GXDevelop)

+ (CAGradientLayer *)gxGradientLayerWithColors:(NSArray *)colors layerFrame:(CGRect)frame direction:(GXGradientLayerDirectionOption)direction
{
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.frame    = frame;
    layer.colors = colors;
    CGPoint  start = CGPointMake(0.5, 0);
    CGPoint end = CGPointMake(0.5, 1);
    
    switch (direction) {
        case GXGradientLayerDirectionTopToDown:
        {
            //            start = CGPointMake(0.5, 0);
            //            end = CGPointMake(0.5, 1);
        }
            break;
        case GXGradientLayerDirectionLeftToRight:
        {
            start = CGPointMake(0, 0.5);
            end = CGPointMake(1, 0.5);
        }
            break;
        case GXGradientLayerDirectionTopLeftToDownRight:
        {
            start = CGPointMake(0, 0);
            end = CGPointMake(1, 1);
        }
            break;
        case GXGradientLayerDirectionTopRightToDownLeft:
        {
            start = CGPointMake(1, 0);
            end = CGPointMake(0, 1);
        }
            break;
        case GXGradientLayerDirectionOther:
        {
            //            start = CGPointMake(0.5, 0);
            //            end = CGPointMake(0.5, 1);
        }
            break;
        default:
            break;
    }
    
    layer.startPoint = start;
    layer.endPoint   = end;
    return layer;
}


+ (CAGradientLayer *)gxGradientLayerWithColors:(NSArray *)colors layerFrame:(CGRect)frame startPoint:(CGPoint)start endPoint:(CGPoint)end
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame    = frame;
    layer.colors = colors;
    layer.startPoint = start;
    layer.endPoint   = end;
    return layer;
}


@end
