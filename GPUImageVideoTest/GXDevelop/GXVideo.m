//
//  GXVideo.m
//  GIFY
//
//  Created by 小新 on 16/8/15.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "GXVideo.h"
#import "UIImage+GXDevelop.h"

@implementation GXVideo

+ (void)gxCombVideosWith:(NSArray *)AVAssets needAudio:(BOOL)audio outPutPath:(NSString *)path complete:(void(^)(NSError *error))complete
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    // 视频
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

    [AVAssets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AVAsset *avasset = obj;
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, avasset.duration);
        [compositionTrack insertTimeRange:timeRange ofTrack:[avasset tracksWithMediaType:AVMediaTypeVideo][0] atTime:kCMTimeZero error:nil];

    }];
    
    if (audio) {
        // 声音
        AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [AVAssets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            AVAsset *avasset = obj;
            CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, avasset.duration);
            [audioTrack insertTimeRange:timeRange ofTrack:[avasset tracksWithMediaType:AVMediaTypeAudio][0] atTime:kCMTimeZero error:nil];
            
        }];
    }
    
    AVAssetExportSession *exporterSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exporterSession.outputFileType = AVFileTypeMPEG4;
    exporterSession.outputURL = [NSURL fileURLWithPath:path]; //如果文件已存在，将造成导出失败
    exporterSession.shouldOptimizeForNetworkUse = YES; //用于互联网传输
    [exporterSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exporterSession.status) {
            case AVAssetExportSessionStatusUnknown:
//                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
//                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
            {
//                NSLog(@"exporter Failed");
                if (complete) {
                    complete(exporterSession.error);
                }
            }
                break;
            case AVAssetExportSessionStatusWaiting:
//                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
//                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
//                NSLog(@"exporter Completed");
            {
                if (complete) {
                    complete(nil);
                }
            }
                break;
        }
    }];
}


+ (UIImage *)gxGetImageWithVideoURL:(NSURL *)videoURL curTime:(CGFloat)curTime

{
    
    // 根据视频的URL创建AVURLAsset
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    return  [self gxGetImageWithVideoAsset:asset curTime:curTime];
}

+ (UIImage *)gxGetImageWithVideoAsset:(AVURLAsset *)asset curTime:(CGFloat)curTime

{
    return [self gxGetImageWithVideoAsset:asset curTime:curTime targetSize:CGSizeZero compress:1];
}

+ (UIImage *)gxGetImageWithVideoAsset:(AVURLAsset *)asset curTime:(CGFloat)curTime targetSize:(CGSize)size

{
    return [self gxGetImageWithVideoAsset:asset curTime:curTime targetSize:size compress:1];
}
+ (UIImage *)gxGetImageWithVideoAsset:(AVURLAsset *)asset curTime:(CGFloat)curTime targetSize:(CGSize)size compress:(CGFloat)compress

{
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: asset];
    // 精确定位时间 否则系统优化会选择临近的时间点返回图片
    gen.requestedTimeToleranceBefore= kCMTimeZero;
    gen.requestedTimeToleranceAfter= kCMTimeZero;
    
    gen.appliesPreferredTrackTransform = YES;
    
    // 定义获取0帧处的视频截图
    
    CMTime time = CMTimeMakeWithSeconds(curTime, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    // 获取time处的视频截图
    
    CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
    
    // 将CGImageRef转换为UIImage
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage: image];
    thumb = [UIImage imageWithData:UIImageJPEGRepresentation(thumb, compress)];
    
    if (size.width != 0) {
        thumb = [UIImage gxGetAspectFillImage:thumb targetSize:size isOpaque:NO];
    }
    
    CGImageRelease(image);
    
    return  thumb;
}

+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount
{
    return [self gxGetImagesWithAsset:asset minTime:minTime maxTime:maxTime imageCount:imageCount targetSize:CGSizeZero compress:1];
    
}
+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount targetSize:(CGSize)size
{
    return [self gxGetImagesWithAsset:asset minTime:minTime maxTime:maxTime imageCount:imageCount targetSize:size compress:1];
}
+ (NSMutableArray *)gxGetImagesWithAsset:(AVURLAsset *)asset minTime:(CGFloat)minTime maxTime:(CGFloat)maxTime imageCount:(NSInteger )imageCount targetSize:(CGSize)size compress:(CGFloat)compress
{
    CGFloat timePadding = (maxTime - minTime)/imageCount;
    UIImage *image = nil;
    NSMutableArray *imageArr = [NSMutableArray array];
    for (CGFloat time = minTime+timePadding/2.; time < maxTime; time+=timePadding) {
        @autoreleasepool {
            image = [self gxGetImageWithVideoAsset:asset curTime:time targetSize:size compress:compress];
            [imageArr addObject:[image copy]];
            image = nil;
        }
    }
    return imageArr;
}


@end
