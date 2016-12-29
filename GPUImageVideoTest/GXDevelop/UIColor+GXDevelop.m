//
//  UIColor+GXDevelop.m
//  GIFY
//
//  Created by 小新 on 16/7/8.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "UIColor+GXDevelop.h"

@implementation UIColor (GXDevelop)

- (NSUInteger)gxRGBAValue{
    CGFloat red, green, blue, alpha;
    NSInteger r,g,b,a;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    r = red*255;
    g = green*255;
    b = blue*255;
    a = alpha*255;
    
    NSUInteger value =  ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | ((a & 0xFF) << 0);
    return value;
}

+ (UIColor *)gxColorWithRGBAValue:(NSUInteger)rgbaValue{
    
    CGFloat red, green, blue, alpha;
    NSInteger r,g,b,a;
    r = (rgbaValue & 0xFF000000) >> 24;
    g = (rgbaValue & 0xFF0000) >> 16;
    b = (rgbaValue & 0xFF00) >> 8;
    a = (rgbaValue & 0xFF) >> 0;
    
    red = r / 255.0;
    green = g / 255.0;
    blue = b / 255.0;
    alpha = a / 255.0;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}


- (NSString *)gxRGBHexString{
    CGFloat red, green, blue, alpha;
    unsigned int r,g,b,a;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    r = red*255;
    g = green*255;
    b = blue*255;
    a = alpha*255;
    
    unsigned int value =  ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0) | ((a & 0xFF) << 24);
    
    NSString *str = [NSString stringWithFormat:@"#%08X", value];
    return str;
}
+ (UIColor *)gxColorWithString:(NSString *)str{
    if ([str hasPrefix:@"#"]) { // AARRGGBB or RRGGBB
        str = [str substringFromIndex:1];
        
        if (!str || [str isEqualToString:@"none"] || !(str.length == 3 || str.length == 4 || str.length == 6 || str.length == 8))
            return nil;
        
        if (str.length == 3) {
            str = [NSString stringWithFormat:@"FF%@%@%@%@%@%@", [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]]];
        }
        else if (str.length == 4) {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:3]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:3]]];
        }else if (str.length == 6)
            str = [NSString stringWithFormat:@"FF%@", str];
        
        
        unsigned int rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner scanHexInt:&rgbValue];
        
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                               green:((rgbValue & 0xFF00) >> 8)/255.0
                                blue:(rgbValue & 0xFF)/255.0
                               alpha:((rgbValue & 0xFF000000) >> 24)/255.0];
        
    }else{
        NSArray *arr = [str componentsSeparatedByString:@","];
        if (arr.count == 3){
            NSInteger red = [arr[0] integerValue];
            NSInteger green = [arr[1] integerValue];
            NSInteger blue = [arr[2] integerValue];
            return GXColorFromRGBA(red, green, blue,1);
        }else if (arr.count == 4){
            CGFloat alpha = MAX(MIN([arr[0] floatValue], 1.0), 0.0);
            NSInteger red = [arr[1] integerValue];
            NSInteger green = [arr[2] integerValue];
            NSInteger blue = [arr[3] integerValue];
            return GXColorFromRGBA(red, green, blue, alpha);
        }
        return nil;
    }
}

+ (UIColor *)colorWithString:(NSString *)str{
    if ([str hasPrefix:@"#"]) { // AARRGGBB or RRGGBB
        str = [str substringFromIndex:1];
        
        if (!str || [str isEqualToString:@"none"] || !(str.length == 3 || str.length == 4 || str.length == 6 || str.length == 8))
            return nil;
        
        if (str.length == 3) {
            str = [NSString stringWithFormat:@"FF%@%@%@%@%@%@", [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]]];
        }
        else if (str.length == 4) {
            str = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:0]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:1]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:2]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:3]],
                   [NSString stringWithFormat:@"%C", [str characterAtIndex:3]]];
        }else if (str.length == 6)
            str = [NSString stringWithFormat:@"FF%@", str];
        
        
        unsigned int rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner scanHexInt:&rgbValue];
        
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                               green:((rgbValue & 0xFF00) >> 8)/255.0
                                blue:(rgbValue & 0xFF)/255.0
                               alpha:((rgbValue & 0xFF000000) >> 24)/255.0];
        
    }else{
        NSArray *arr = [str componentsSeparatedByString:@","];
        if (arr.count == 3){
            NSInteger red = [arr[0] integerValue];
            NSInteger green = [arr[1] integerValue];
            NSInteger blue = [arr[2] integerValue];
            return GXColorFromRGBA(red, green, blue,1);
        }else if (arr.count == 4){
            CGFloat alpha = MAX(MIN([arr[0] floatValue], 1.0), 0.0);
            NSInteger red = [arr[1] integerValue];
            NSInteger green = [arr[2] integerValue];
            NSInteger blue = [arr[3] integerValue];
            return GXColorFromRGBA(red, green, blue, alpha);
        }
        return nil;
    }
}

+ (UIColor *)colorWithRGBAValue:(NSUInteger)rgbaValue{
    
    CGFloat red, green, blue, alpha;
    NSInteger r,g,b,a;
    r = (rgbaValue & 0xFF000000) >> 24;
    g = (rgbaValue & 0xFF0000) >> 16;
    b = (rgbaValue & 0xFF00) >> 8;
    a = (rgbaValue & 0xFF) >> 0;
    
    red = r / 255.0;
    green = g / 255.0;
    blue = b / 255.0;
    alpha = a / 255.0;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}
- (NSUInteger)RGBAValue{
    CGFloat red, green, blue, alpha;
    NSInteger r,g,b,a;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    r = red*255;
    g = green*255;
    b = blue*255;
    a = alpha*255;
    
    NSUInteger value =  ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | ((a & 0xFF) << 0);
    return value;
}

- (NSString *)RGBHexString{
    CGFloat red, green, blue, alpha;
    unsigned int r,g,b,a;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    r = red*255;
    g = green*255;
    b = blue*255;
    a = alpha*255;
    
    unsigned int value =  ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0) | ((a & 0xFF) << 24);
    
    NSString *str = [NSString stringWithFormat:@"#%08X", value];
    return str;
}


@end
