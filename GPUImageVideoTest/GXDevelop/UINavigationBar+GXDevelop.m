//
//  UINavigationBar+GXDevelop.m
//  GIFY
//
//  Created by 高才新 on 16/5/17.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "UINavigationBar+GXDevelop.h"
#import "UIImage+GXDevelop.h"
#import "GXDevelopKey.h"

@implementation UINavigationBar (GXDevelop)

+ (void)gxSetGlobalNavBarBgColor:(UIColor *)bgColor shadowColor:(UIColor *)shadowColor
{
    [UINavigationBar appearance].translucent = NO;
    UIColor *scolor = shadowColor;
    if (!scolor) {
        scolor = [UIColor colorWithWhite:0 alpha:0];
    }
    UIColor *bcolor = bgColor;
    if (!bcolor) {
        bcolor = [UIColor colorWithWhite:0 alpha:0];
    }

    [[UINavigationBar appearance] setShadowImage:[UIImage gxImageWithColor:scolor size:CGSizeMake(GXScreenWidth, 0.5) cornerRadius:0]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage gxImageWithColor:bcolor size:CGSizeMake(GXScreenWidth, 64) cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
+ (void)gxSetGlobalNavBarFullClear
{
    [UINavigationBar appearance].translucent = YES;
    [[UINavigationBar appearance] setShadowImage:[UIImage gxImageWithColor:GXColorFromRGBhueA(0x000000, 0) size:CGSizeMake(GXScreenWidth, 0.5) cornerRadius:0]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage gxImageWithColor:GXColorFromRGBhueA(0x000000, 0) size:CGSizeMake(GXScreenWidth, 64) cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}

- (void)gxSetNavBarBgColor:(UIColor *)bgColor shadowColor:(UIColor *)shadowColor
{
    self.translucent = NO;
    UIColor *scolor = shadowColor;
    if (!scolor) {
        scolor = [UIColor colorWithWhite:0 alpha:0];
    }
    UIColor *bcolor = bgColor;
    if (!bcolor) {
        bcolor = [UIColor colorWithWhite:0 alpha:0];
    }
    [self setShadowImage:[UIImage gxImageWithColor:scolor size:CGSizeMake(GXScreenWidth, 0.5) cornerRadius:0]];
    [self setBackgroundImage:[UIImage gxImageWithColor:bcolor size:CGSizeMake(GXScreenWidth, 64) cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
- (void)gxSetNavBarFullClear
{
    self.translucent = YES;
    [self setShadowImage:[UIImage gxImageWithColor:GXColorFromRGBhueA(0x000000, 0) size:CGSizeMake(GXScreenWidth, 0.5) cornerRadius:0]];
    [self setBackgroundImage:[UIImage gxImageWithColor:GXColorFromRGBhueA(0x000000, 0) size:CGSizeMake(GXScreenWidth, 64) cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}

- (void)gxUpdateNavBarAppearanceFont:(UIFont *)font titleColor:(UIColor *)titleColor barBgColor:(UIColor *)barBgColor
{
    self.titleTextAttributes =
    @{NSFontAttributeName: font,
      NSForegroundColorAttributeName: titleColor};
    self.backgroundColor = barBgColor;
}

@end
