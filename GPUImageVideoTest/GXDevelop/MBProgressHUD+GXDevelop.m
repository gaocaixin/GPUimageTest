//
//  MBProgressHUD+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 16/1/7.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

//(丢弃) 扩展应用禁止访问sharedApplication, 会报错. 解决方法:给 app扩展 定义预编译宏:GXDevelopExtension (Build Settings->Preprocessor Macros 的 debug 和 release 各添加:GXDevelopExtension)

#import "MBProgressHUD+GXDevelop.h"
#import <UIKit/UIKit.h>

#ifdef MB_INSTANCETYPE

@implementation MBProgressHUD (GXDevelop)

+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font{


    if (!view) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    if (text.length > 0) {
        hud.detailsLabel.text = text;
        
    }
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        imageView.image = image;
        
        hud.customView = imageView;
    }
    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.88];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor clearColor];
    hud.bezelView.layer.cornerRadius = 8;
    hud.animationType  = MBProgressHUDAnimationFade;
    [view addSubview:hud];
    hud.detailsLabel.font = font;
//    hud.labelFont = [UIFont systemFontSize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:duration];
    });
}

+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font margin:(CGFloat)margin {
    
    if (!view) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    if (text.length > 0) {
        hud.detailsLabel.text = text;
        
    }
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        imageView.image = image;
        
        hud.customView = imageView;
    }    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.88];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor clearColor];
    
    hud.bezelView.layer.cornerRadius = 8;
    hud.animationType  = MBProgressHUDAnimationFade;
    [view addSubview:hud];
    hud.detailsLabel.font = font;

    hud.margin = margin;
    //    hud.labelFont = [UIFont systemFontSize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:duration];
    });
}


+ (void)gxShowNotiInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image attrText:(NSMutableAttributedString *)attrText
{
    if (!view) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    if (attrText.length > 0) {
        hud.detailsLabel.attributedText = attrText;
        
    }
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        imageView.image = image;
        
        hud.customView = imageView;
    }    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.];
    hud.customView.backgroundColor = [UIColor clearColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = GXColorFromRGBhueA(0x000000, 0.6);
    hud.userInteractionEnabled = NO;
    hud.animationType  = MBProgressHUDAnimationFade;
    hud.bezelView.layer.masksToBounds = YES;
    [view addSubview:hud];
    hud.bezelView.height = GXHeightFitCeil(60);
    hud.bezelView.layer.cornerRadius = hud.bezelView.height/2.;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];


        [hud hideAnimated:YES afterDelay:duration];
    });
}

+ (void)gxShowNotiInDebugInView:(UIView *)view duration:(CGFloat)duration image:(UIImage *)image text:(NSString *)text font:(UIFont *)font
{
#ifdef DEBUG
    [self gxShowNotiInView:view duration:duration image:image text:text font:font];
    
#endif
}
+ (void)gxShowWaitInView:(UIView *)view attrText:(NSMutableAttributedString *)attrText
{
    if (!view) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    if (attrText.length > 0) {
        hud.detailsLabel.attributedText = attrText;
    }
    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.88];
//    hud.dimBackground = NO;
    hud.bezelView.layer.cornerRadius = 8;
    hud.animationType  = MBProgressHUDAnimationFade;
    [view addSubview:hud];

    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
    });
}
+ (void)gxShowWaitInView:(UIView *)view text:(NSString *)text font:(UIFont *)font
{

    if (!view) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    if (text.length > 0) {
        hud.detailsLabel.text = text;
    }
    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.88];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor clearColor];
    hud.bezelView.layer.cornerRadius = 8;
    hud.animationType  = MBProgressHUDAnimationFade;
    [view addSubview:hud];
    hud.detailsLabel.font = font;
    //    hud.labelFont = [UIFont systemFontSize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
    });
}

+ (void)gxShowWaitInView:(UIView *)view text:(NSString *)text font:(UIFont *)font margin:(CGFloat)margin
{
    if (!view) {
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    if (text.length > 0) {
        hud.detailsLabel.text = text;
    }
    //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.88];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor clearColor];
    hud.bezelView.layer.cornerRadius = 8;
    hud.animationType  = MBProgressHUDAnimationFade;
    [view addSubview:hud];
    hud.detailsLabel.font = font;
    hud.margin = margin;
    //    hud.labelFont = [UIFont systemFontSize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
    });
}

+ (void)gxHideInView:(UIView *)view animated:(BOOL)animated
{
    if (!view) {
        return;
    }
//    dispatch_sync(dispatch_get_main_queue(), ^{

        [MBProgressHUD hideHUDForView:view animated:animated];
//    });
}


@end


#endif
