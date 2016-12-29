//
//  GXVideo.h
//  GIFY
//
//  Created by 小新 on 16/8/15.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GXVideo : NSObject

/*
 * 视频追加合成
 */
+ (void)gxCombVideosWith:(NSArray *)AVAssets needAudio:(BOOL)audio outPutPath:(NSString *)path complete:(void(^)(NSError *error))complete;



/**
 *返回视频时间点curTime(s)的图片
 */
+ (UIImage *)gxGetImageWithVideoAsset:(AVURLAsset *)asset curTime:(CGFloat)curTime;
/**
 *返回视频时间点curTime(s)的图片
 */
+ (UIImage *)gxGetImageWithVideoURL:(NSURL *)videoURL curTime:(CGFloat)curTime;
/**
 *返回视频时间点curTime(s)的图片 转换到目标尺寸
 */
+ (UIImage *)gxGetImageWithVideoAsset:(AVURLAsset *)asset curTime:(CGFloat)curTime targetSize:(CGSize)size;
/**
 *返回从 minTime到maxTime 的imageCount张视屏缩略图
 */
+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount;
/**
 *返回从 minTime到maxTime 的imageCount张视屏缩略图 (转换到目标尺寸)
 */
+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount targetSize:(CGSize)size;
/**
 *返回从 minTime到maxTime 的imageCount张视屏缩略图 (转换到目标尺寸) 带压缩比(0-1(原图))
 */
+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount targetSize:(CGSize)size compress:(CGFloat)compress;

@end
