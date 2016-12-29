//
//  GXDevelopExtern.m
//  GXDevelopDemo
//
//  Created by 高才新 on 16/3/29.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import "GXDevelopExtern.h"
#import "GXDevelopKey.h"

@implementation GXDevelopExtern


+ (instancetype)sharedExtern
{
    static GXDevelopExtern *sharedExtern = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedExtern = [[self alloc] init];
    });
    return sharedExtern;
}

- (CGFloat)gxScreenWidth
{
    [self refreshDataIfNeed];
    return _gxScreenWidth;
}
- (CGFloat)gxScreenHeight
{
    [self refreshDataIfNeed];
    return _gxScreenHeight;
}
- (CGFloat)gxScreenWidthRatio
{
    [self refreshDataIfNeed];
    return _gxScreenWidthRatio;
}
- (CGFloat)gxScreenHeightRatio
{
    [self refreshDataIfNeed];
    return _gxScreenHeightRatio;
}
- (CGFloat)gxScreenMinRatio
{
    [self refreshDataIfNeed];
    return _gxScreenWHminRatio;
}
- (CGFloat)gxScreenMaxRatio
{
    [self refreshDataIfNeed];
    return _gxScreenWHmaxRatio;
}

- (void)refreshDataIfNeed
{
    if (_gxScreenWidth != [UIScreen mainScreen].bounds.size.width) {
        [self refreshData];
    }
}

- (void)refreshData
{
    
    _gxScreenWidth = [UIScreen mainScreen].bounds.size.width;
    _gxScreenHeight = [UIScreen mainScreen].bounds.size.height;
    _gxScreenRatio = MIN((_gxScreenWidth/_gxScreenHeight), (_gxScreenHeight/_gxScreenWidth));
    if (_gxScreenHeight > _gxScreenWidth) { // 竖屏
        _gxScreenWidthRatio = _gxScreenWidth/GXDesignSize.width;
        _gxScreenHeightRatio = _gxScreenHeight/GXDesignSize.height;
    } else { // 横屏
        _gxScreenWidthRatio = _gxScreenWidth/GXDesignSize.width;
        _gxScreenHeightRatio = _gxScreenHeight/GXDesignSize.height;
    }
    _gxScreenWHminRatio = MIN(_gxScreenWidthRatio, _gxScreenHeightRatio);
    _gxScreenWHmaxRatio = MAX(_gxScreenWidthRatio, _gxScreenHeightRatio);
}

@end
