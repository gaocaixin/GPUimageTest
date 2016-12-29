//
//  UIColor+GXDevelop.h
//  GIFY
//
//  Created by 小新 on 16/7/8.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GXDevelop)

- (NSUInteger)gxRGBAValue;
+ (UIColor *)gxColorWithRGBAValue:(NSUInteger)rgbaValue;


- (NSString *)gxRGBHexString;
+ (UIColor *)gxColorWithString:(NSString *)str;


@end
