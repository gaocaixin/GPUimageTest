//
//  NSString+GXString.h
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
// 常用验证宏
// email
#define kGXValidateEmali @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
// n - m 位字符
#define kGXValidateCharsBetween(n, m) [NSString stringWithFormat:@"^[A-Za-z0-9]{%d,%d}$",(n), (m)]
// n位数字
#define kGXValidateNum(n) [NSString stringWithFormat:@"^\\d{%d}$",(n)]

// 字母数字下划线
#define kGXValidUserName @"^[0-9a-zA-Z_]{2,20}$"

#define GXLocalized(Key) [NSString gxLocalizedString:Key]



@interface NSString (GXDevelop)

/**
 *正则判断
 */
- (BOOL)gxValidateWithRegexStr:(NSString *)regexStr;
/**
 *计算size
 */
- (CGSize )gxSizeWithLimitSize:(CGSize )limitSize  font:(UIFont *)font;
/**
 *md5
 */
- (NSString *)gxMd5;
/**
 * 添加文字间距
 */
- (NSMutableAttributedString *) gxAttributeStringWithFont:(UIFont *)font color:(UIColor *)fontColor spacing:(long)spacing;
/**
 * 添加文字间距 行间距
 */
- (NSMutableAttributedString *)gxAttributeStringWithFont:(UIFont *)font  color:(UIColor *)fontColor spacing:(long)spacing lineSpacing:(CGFloat)linespacing alignment:(NSTextAlignment)alignment;
/**
 *将16进制转成 color
 */
- (UIColor *) gxHexStringTransformUIColorWithAlpha:(CGFloat)alpha;

/**
 *本地化
 */
+(NSString*)gxLocalizedString:(NSString *)key;

/**
 *获取推荐
 */
- (void)gxGetSuggestionsStringsWithCompletion:(void(^)(NSArray *))completion;


/**
 *  添加文字间距 行间距
 *
 *  @返回 attributedString 和 size
 */
- (NSDictionary *)gxAttributeStringWithLimitSize:(CGSize )limitSize  font:(UIFont *)font  color:(UIColor *)fontColor spacing:(long)spacing lineSpacing:(CGFloat)linespacing alignment:(NSTextAlignment)alignment;


+ (NSString *)gxRandString;

//- (CGSize)gxPrefersizeWith:(CGSize)size;

@end

//验证只有空格: ^[\s]*$
//验证数字：^[0-9]*$
//验证n位的数字：^\d{n}$
//验证至少n位数字：^\d{n,}$
//验证m-n位的数字：^\d{m,n}$
//验证数字和小数点:^[0-9]+([.]{0}|[.]{1}[0-9]+)$
//验证零和非零开头的数字：^(0|[1-9][0-9]*)$
//验证有两位小数的正实数：^[0-9]+(.[0-9]{2})?$
//验证有1-3位小数的正实数：^[0-9]+(.[0-9]{1,3})?$
//验证非零的正整数：^\+?[1-9][0-9]*$
//验证非零的负整数：^\-[1-9][0-9]*$
//验证非负整数（正整数 + 0）  ^\d+$
//验证非正整数（负整数 + 0）  ^((-\d+)|(0+))$
//验证长度为3的字符：^.{3}$
//验证由26个英文字母组成的字符串：^[A-Za-z]+$
//验证由26个大写英文字母组成的字符串：^[A-Z]+$
//验证由26个小写英文字母组成的字符串：^[a-z]+$
//验证由数字和26个英文字母组成的字符串：^[A-Za-z0-9]+$
//验证由数字、26个英文字母或者下划线组成的字符串：^\w+$
//验证用户密码:^[a-zA-Z]\w{5,17}$ 正确格式为：以字母开头，长度在6-18之间，只能包含字符、数字和下划线。
//验证是否含有 ^%&',;=?$\" 等字符：[^%&',;=?$\x22]+
//验证汉字：^[\u4e00-\u9fa5],{0,}$
//验证Email地址：^\w+[-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
//验证InternetURL：^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$
//验证电话号码：^(\(\d{3,4}\)|\d{3,4}-)?\d{7,8}$：--正确格式为：XXXX-XXXXXXX，XXXX-XXXXXXXX，XXX-XXXXXXX，XXX-XXXXXXXX，XXXXXXX，XXXXXXXX。
//验证电话号码及手机:（\d{3}-\d{8}|\d{4}-\d{7}）｜（^((\(\d{3}\))|(\d{3}\-))?13\d{9}|15[89]\d{8}$）
//验证身份证号（15位或18位数字）：^\d{15}|\d{}18$
//验证一年的12个月：^(0?[1-9]|1[0-2])$ 正确格式为：“01”-“09”和“1”“12”
//验证一个月的31天：^((0?[1-9])|((1|2)[0-9])|30|  )$    正确格式为：01、09和1、31。
//整数：^-?\d+$
//非负浮点数（正浮点数 + 0）：^\d+(\.\d+)?$
//正浮点数   ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
//非正浮点数（负浮点数 + 0） ^((-\d+(\.\d+)?)|(0+(\.0+)?))$
//负浮点数  ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$
//浮点数  ^(-?\d+)(\.\d+)?$
