//
//  NSURL+GXDevelop.h
//  GXDevelopDemo
//
//  Created by 高才新 on 16/4/1.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (GXDevelop)


/*
 * 使用传入的baseURL地址和参数集合构造含参数的请求URL的工具方法。
 */
+ (NSURL*)gxGenerateURL:(NSString*)baseURL params:(NSDictionary*)params;

@end
