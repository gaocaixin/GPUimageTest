//
//  NSDictionary+GXDevelop.h
//  GIFY
//
//  Created by 小新 on 16/7/8.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (GXDevelop)

- (id)objectForKey:(NSString *)key defalutObj:(id)defaultObj;
- (id)objectForKey:(id)aKey ofClass:(Class)cls defaultObj:(id)defaultObj;
- (NSInteger)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (CGFloat)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (long)longValueForKey:(NSString *)key defaultValue:(long)defaultValue;
- (long long)longlongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (CGSize)sizeValueForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
- (UIEdgeInsets)edgeinsetsValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue;
- (UIOffset)offsetValueForKey:(NSString *)key defaultValue:(UIOffset)defaultValue;
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

- (id)gxObjectForKey:(NSString *)key defalutObj:(id)defaultObj;
- (id)gxObjectForKey:(id)aKey ofClass:(Class)cls defaultObj:(id)defaultObj;
- (NSInteger)gxIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (CGFloat)gxFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (long)gxLongValueForKey:(NSString *)key defaultValue:(long)defaultValue;
- (long long)gxLonglongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (BOOL)gxBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (CGSize)gxSizeValueForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
- (UIEdgeInsets)gxEdgeinsetsValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue;
- (UIOffset)gxOffsetValueForKey:(NSString *)key defaultValue:(UIOffset)defaultValue;
- (NSString *)gxStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSArray *)gxArrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)gxDictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

@end
