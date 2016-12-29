//
//  UIDevice+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 16/3/2.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (GXDevelop)

/**
 *获取设备可用内存 (MB)
 */
+ (double)gxGetAvailableMemory;


/**
 *获取设备当前任务所占用的内存（单位：MB）
 */
+ (double)gxGetUsedMemory;
/**
 *强制旋转设备方向  (审he 能 通guo)
 */
+ (void)gxSetDeviceOrientation:(UIInterfaceOrientation)orientation;

+ (BOOL)gxCanAuthenticateTouchIdWithError:(NSError *)error;
+ (void)gxAuthenticateTouchIdWithLocalizedReason:(NSString *)localizedReason completion:(void (^)(BOOL success, NSError * authenticationError))authenticateCompletion;



+ (BOOL) gxIsRunningOn3GS;
+ (BOOL) gxIsRunningOn4S;
+ (BOOL) gxIsRunningOn_3_5_Inch; //iPhone 4
+ (BOOL) gxIsRunningOn_4_0_Inch; //iPhone 5
+ (BOOL) gxIsRunningOn_4_7_Inch; //iPhone 6
+ (BOOL) gxIsRunningOn_5_5_Inch; //iPhone 6 Plus
+ (BOOL) gxIsRunningOniPad;      //iPad
+ (BOOL) gxIsRunningOniPod;      //iPod
+ (CGFloat)gxGetSystemVersion;

// AppItunesURL 
+ (NSURL *)gxGetAppItunesURL:(NSString *)appid;
// AppItunesURLstr
+ (NSString *)gxGetAppItunesURLString:(NSString *)appid;

// 打印系统支持的字体
+ (void)gxLogDeviceFont;
//打印系统支持的滤镜
+(void)gxShowAllFilters;

// 多点 open Url
+ (void)gxOpenURL:(NSString*)url fromViewController:(UIViewController *)vc;

// 跳转到 app 设置页面
+ (NSURL *)gxGetAppSettingsURLString;

// 设置各种 url
+ (NSURL *)gxGetSettingsWith:(NSInteger)idx;

+ (void)gxShareItems:(NSArray *)items controller:(UIViewController *)controller;
@end
