//
//  GXGif.h
//  LiPix
//
//  Created by 小新 on 16/9/6.
//  Copyright © 2016年 IU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXGif : NSObject


/**
 *分解 gif 成image 数组
 */
+ (NSMutableArray *)gxParseGifDataToImageArray:(NSData *)data;
/**
 *分解 gif 成image 数组 大小 size
 */
+ (NSMutableArray *)gxParseGifDataToImageArray:(NSData *)data targetSize:(CGSize)size;
/**
 *image数组 合成 gif
 */
+ (void)gxImgsToGifWithImgs:(NSArray *)imgs path:(NSString *)path intervalTime:(CGFloat)time;

@end
