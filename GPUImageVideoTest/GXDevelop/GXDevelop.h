//
//  GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

//#import "GXDevelop.h"

/**
 *助手类信息: 所有方法为了调用简单大部分使用分类.防止与其他文件方法冲突,文件均使用GX开头,方法和属性均使用gx开头.
*/

#ifndef GXDevelop_h
#define GXDevelop_h

/**
 *自定义宏
 */
#import "GXDevelopCustom.h" // 如果第一次使用此库 请配置里面的数据


/**
 *辅助宏
 */
#import "GXDevelopExtern.h" // 全局记录信息,方便快速调用.
#import "GXDevelopKey.h" // 添加各种常用宏(如果用到适配的宏,需要配置好GXDevelopCustom.h)

/**
 * 辅助类方法
 */
// 非 UI
#import "NSString+GXDevelop.h" // 正则 本地化等等
#import "UIDevice+GXDevelop.h" // 强制转屏 获取设备信息等等
#import "NSFileManager+GXDevelop.h"// 文件路径
#import "UIImage+GXDevelop.h" // uiimge 的各类方法 渐变,拉伸,旋转,合成,组合,转gif, 从视频中获取 image
#import "NSAttributedString+GXDevelop.h"
#import "NSDictionary+GXDevelop.h"
#import "UIApplication+GXDevelop.h"
#import "GXVideo.h" // 视频的相关操作
#import "GXGif.h" // gif 的相关操作
#import "NSData+GXDevelop.h"

// UI -view //快速创建方法

#import "UIButton+GXDevelop.h"
#import "UIImageView+GXDevelop.h"
#import "UILabel+GXDevelop.h"
#import "UIPageControl+GXDevelop.h"
#import "UIView+GXDevelopAnimation.h"
#import "MBProgressHUD+GXDevelop.h"
#import "UIView+GXDevelop.h"
#import "GXFrameInButton.h" // 继承 uibutton 可随意定义内部 title 和 image 位置
#import "UINavigationBar+GXDevelop.h"// 全透明及半透明设置
#import "UIViewController+GXDevelop.h"
#import "UIColor+GXDevelop.h"
#import "UIScrollView+GXDevelop.h"

// UI - layer
#import "CAGradientLayer+GXDevelop.h"
#import "CALayer+GXDevelop.h"

// path
#import "UIBezierPath+GXDevelop.h"



#endif /* GXDevelop_h */
