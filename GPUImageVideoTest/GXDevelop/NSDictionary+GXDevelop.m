//
//  NSDictionary+GXDevelop.m
//  GIFY
//
//  Created by 小新 on 16/7/8.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "NSDictionary+GXDevelop.h"

@implementation NSDictionary (GXDevelop)


- (id)gxObjectForKey:(NSString *)key defalutObj:(id)defaultObj {
    id obj = [self objectForKey:key];
    return obj ? obj : defaultObj;
}

- (id)gxObjectForKey:(id)aKey ofClass:(Class)cls defaultObj:(id)defaultObj {
    id obj = [self objectForKey:aKey];
    return (obj && [obj isKindOfClass:cls]) ? obj : defaultObj;
}

- (NSInteger)gxIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value integerValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    return defaultValue;
}

- (CGFloat)gxFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value floatValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return defaultValue;
}

- (long)gxLongValueForKey:(NSString *)key defaultValue:(long)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return (long)[(NSString *)value longLongValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value longValue];
    }
    return defaultValue;
}

- (long long)gxLonglongValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value longLongValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return defaultValue;
}
- (BOOL)gxBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue{
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value boolValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return defaultValue;
}

- (CGSize)gxSizeValueForKey:(NSString *)key defaultValue:(CGSize)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value CGSizeValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    return defaultValue;
}

- (UIEdgeInsets)gxEdgeinsetsValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value UIEdgeInsetsValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return UIEdgeInsetsFromString(value);
    }
    return defaultValue;
}

- (UIOffset)gxOffsetValueForKey:(NSString *)key defaultValue:(UIOffset)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value UIOffsetValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return UIOffsetFromString(value);
    }
    return defaultValue;
}

- (NSString *)gxStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

- (NSArray *)gxArrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    id value = [self objectForKey:key];
    return (value && [value isKindOfClass:[NSArray class]]) ? value : defaultValue;
}

- (NSDictionary *)gxDictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    id value = [self objectForKey:key];
    return (value && [value isKindOfClass:[NSDictionary class]]) ? value : defaultValue;
}

- (id)objectForKey:(NSString *)key defalutObj:(id)defaultObj {
    id obj = [self objectForKey:key];
    return obj ? obj : defaultObj;
}

- (id)objectForKey:(id)aKey ofClass:(Class)cls defaultObj:(id)defaultObj {
    id obj = [self objectForKey:aKey];
    return (obj && [obj isKindOfClass:cls]) ? obj : defaultObj;
}

- (NSInteger)intValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value integerValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    return defaultValue;
}

- (CGFloat)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value floatValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return defaultValue;
}

- (long)longValueForKey:(NSString *)key defaultValue:(long)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return (long)[(NSString *)value longLongValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value longValue];
    }
    return defaultValue;
}

- (long long)longlongValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value longLongValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return defaultValue;
}
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue{
    id value = [self objectForKey:key];
    if (!value)
        return defaultValue;
    
    if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *)value boolValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return defaultValue;
}

- (CGSize)sizeValueForKey:(NSString *)key defaultValue:(CGSize)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value CGSizeValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    return defaultValue;
}

- (UIEdgeInsets)edgeinsetsValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value UIEdgeInsetsValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return UIEdgeInsetsFromString(value);
    }
    return defaultValue;
}

- (UIOffset)offsetValueForKey:(NSString *)key defaultValue:(UIOffset)defaultValue{
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value UIOffsetValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return UIOffsetFromString(value);
    }
    return defaultValue;
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    } else {
        return defaultValue;
    }
}

- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    id value = [self objectForKey:key];
    return (value && [value isKindOfClass:[NSArray class]]) ? value : defaultValue;
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    id value = [self objectForKey:key];
    return (value && [value isKindOfClass:[NSDictionary class]]) ? value : defaultValue;
}
@end
