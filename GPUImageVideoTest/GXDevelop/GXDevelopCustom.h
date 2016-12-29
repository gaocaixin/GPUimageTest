//
//  GXDevelopCustom.h
//  LiPix
//
//  Created by 小新 on 16/9/6.
//  Copyright © 2016年 IU. All rights reserved.
//

#ifndef GXDevelopCustom_h
#define GXDevelopCustom_h


//#define MB_INSTANCETYPE // 项目没引用 mb 的话 就注释此行
/**
 *如果需要适配 frame 将用到以下宏  需要将GXDesignSize的值改成设计原稿机型的尺寸. CGSizeMake(375.f, 667.f) 是 iphone6的尺寸.
 */
#define GXDesignSize                  CGSizeMake(375.f,667.f)              //设计原稿竖屏机型的尺寸




#endif /* GXDevelopCustom_h */


/**
 *  for 项目:
 1.安装:插件管理工具Alcatraz
 rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
 find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID
 sudo xcode-select --reset
 curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
 推荐插件:http://www.jianshu.com/p/00410d75b83f
(BBUDebuggerTuckAway-自动隐藏控制台
 ClangFormat-格式化代码
 deriveddata-exterminator清除Xcode缓存目录
 FuzzyAutocompletePlugin-代码自动补全插件
 HOStringSense-大段文本利器
 KSImageNamed-图片插件
 OMColorSense-颜色显示插件
 Peckham-自动补全功能补充
 SCXcodeSwitchExpander-补全枚举类型的每种可能取值
 VVDocumenter-规范注释生成器
 XAlign-一个用来对齐常规代码的Xcode插件
 XcodeBoost-辅助小功能插件
 XToDo-Xcode注释辅助插件)
 */
