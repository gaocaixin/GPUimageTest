//
//  GXDevelopKey.h
//  LOCO
//
//  Created by 高才新 on 16/1/28.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#ifndef GXDevelopKey_h
#define GXDevelopKey_h
#import "GXDevelopCustom.h"
#import "GXDevelopExtern.h"
// 系统单例
#define GXUserDefaults         [NSUserDefaults standardUserDefaults]
#define GXNotificationCenter [NSNotificationCenter defaultCenter]
#define GXFileManager          [NSFileManager defaultManager]
#define GXSharedAppKeyWindow  [UIApplication sharedApplication].keyWindow
#define GXSharedApp  [UIApplication sharedApplication]

// cgrect 获取
#define GXRectW(rect) rect.size.width
#define GXRectH(rect) rect.size.height
#define GXRectX(rect) rect.origin.x
#define GXRectY(rect) rect.origin.y

// 获取 CGRect 的拐点坐标
#define GXRectTopLeftPoint(rect)  CGPointMake(rect.origin.x + 0, rect.origin.y + 0)
#define GXRectTopRightPoint(rect)  CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + 0)
#define GXRectBottomLeftPoint(rect)  CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height)
#define GXRectBottomRightPoint(rect)  CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)

// 获取 CGRect 的四边的中心点坐标
#define GXRectTopCenterPoint(rect)  CGPointMake(rect.origin.x + rect.size.width/2., rect.origin.y + 0)
#define GXRectRightCenterPoint(rect)  CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.)
#define GXRectLeftCenterPoint(rect)  CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height/2.)
#define GXRectBottomCenterPoint(rect)  CGPointMake(rect.origin.x + rect.size.width/2., rect.origin.y + rect.size.height)

#define GXRectCenterPoint(rect)  CGPointMake(rect.origin.x + rect.size.width/2., rect.origin.y + rect.size.height/2.)

//屏幕宽高
#define GXScreenWidth [UIScreen mainScreen].bounds.size.width
#define GXScreenHeight  [UIScreen mainScreen].bounds.size.height


/**
 *适配相关
 */

// 宽度比例适配
#define  GXScreenWidthRatio            ([GXDevelopExtern sharedExtern].gxScreenWidthRatio)   // 当前屏宽/设计原稿的比例
#define  GXWidthFitFloat(value)  ((value)*GXScreenWidthRatio)  
#define  GXWidthFitCeil(value)   (ceil((value)*GXScreenWidthRatio))  // 宽度转化成适配后的ceil值(不小于float的最小整数)
#define  GXWidthFitFloor(value)  (floor((value)*GXScreenWidthRatio)) // 宽度转化成适配后的floor值(不大于float的最大整数)
#define  GXWidthFitRound(value) (round((value)*GXScreenWidthRatio))


// 高度比例适配
#define  GXScreenHeightRatio           ([GXDevelopExtern sharedExtern].gxScreenHeightRatio) // 当前屏高/设计原稿的比例
#define  GXHeightFitFloat(value) ((value)*GXScreenHeightRatio)       // 高度转化成适配后的float值
#define  GXHeightFitCeil(value)  (ceil((value)*GXScreenHeightRatio)) // 高度转化成适配后的ceil值(不小于float的最小整数)
#define  GXHeightFitFloor(value) (floor((value)*GXScreenHeightRatio))// 高度转化成适配后的floor值(不大于float的最大整数)
#define  GXHeightFitRound(value) (round((value)*GXScreenHeightRatio))

// 宽高比例最小值适配
#define  GXScreenMinRatio ([GXDevelopExtern sharedExtern].gxScreenWHminRatio)
#define  GXMinFitFloat(value) ((value)*GXScreenMinRatio)       // 转化成适配后的float值
#define  GXMinFitCeil(value) ((value)*GXScreenMinRatio)       // 转化成适配后的ceil值(不小于float的最小整数)
#define  GXMinFitFloor(value) ((value)*GXScreenMinRatio)       // 转化成适配后的floor值(不大于float的最大整数)

// 宽高比例最大值适配
#define  GXScreenMaxRatio ([GXDevelopExtern sharedExtern].gxScreenWHmaxRatio)
#define  GXMaxFitFloat(value) ((value)*GXScreenMaxRatio)       // 转化成适配后的float值
#define  GXMaxFitCeil(value) ((value)*GXScreenMaxRatio)       // 转化成适配后的ceil值(不小于float的最小整数)
#define  GXMaxFitFloor(value) ((value)*GXScreenMaxRatio)       // 转化成适配后的floor值(不大于float的最大整数)


#define  GXGetAdjacentvalue(value, min , max) ((fabs(value - (min)) <  fabs(value - (max)) ? (min) : (max)))       // 获取value邻近min/max值

/**
 *    颜色
 */
// 256颜色表示
#define GXColorFromRGBA(R,G,B,A) [UIColor colorWithRed:(R)/256.f green:(G)/256.f blue:(B)/256.f alpha:(A)]
// 16进制颜色表示
#define GXColorFromRGBhueA(RGBhue, A) [UIColor colorWithRed:((float)((RGBhue & 0xFF0000) >> 16))/255.0 green:((float)((RGBhue & 0x00FF00) >> 8))/255.0 blue:((float)(RGBhue & 0x0000FF))/255.0 alpha:A]
// 随机颜色
#define GXColorRandom [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

/**
 *自定义log (发布版本不打印任何信息)
 */
#ifdef DEBUG
#define GXLog(...) NSLog(__VA_ARGS__)
#else
#define GXLog(...)
#endif

//A better version of NSLog
//#ifdef DEBUG
//
//        #define GXLog(format, ...) do { \
//        fprintf(stderr, "<%s : %d> %s\n", \
//        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
//        __LINE__, __func__); \
//        (NSLog)((format), ##__VA_ARGS__); \
//        fprintf(stderr, "-------\n"); \
//        } while (0)
//
//#else
//        #define GXLog(format, ...)
//#endif

// 打印函数名及函数的调用者 (测试使用:如-[MyViewController dealloc])
#define GXLogFunc             GXLog(@"%s",__func__);
#define GXLogFuncId(id)         GXLog(@"%s__%@",__func__, id);
#define GXLogMsg(msgName,msg) GXLog(@"%@--%@",msgName,msg);
#define GXLogMsgFloat(msgName,msg) GXLog(@"%@--%lf",msgName,msg);

#define GXLogFuncMsg(msg) GXLog(@"%s-%@",__func__,msg);

/**
 *快速生成 weak指针 
 */
#define GXWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define GXWeakPoiner(weakPoiner, obj)  __weak __typeof(&*obj)weakPoiner = obj;

// 打开设置页面
#define GXAppOpenSetting if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; }

// 快速转化 int -> string
#define GXStringInt(int) [NSString stringWithFormat:@"%ld", int]

#endif /* GXDevelopKey_h */
