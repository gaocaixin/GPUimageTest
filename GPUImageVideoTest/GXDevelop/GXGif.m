//
//  GXGif.m
//  LiPix
//
//  Created by 小新 on 16/9/6.
//  Copyright © 2016年 IU. All rights reserved.
//

#import "GXGif.h"
#include <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation GXGif

+ (NSMutableArray *)gxParseGifDataToImageArray:(NSData *)data ;
{
    return  [self gxParseGifDataToImageArray:data targetSize:CGSizeZero];
}

+ (NSMutableArray *)gxParseGifDataToImageArray:(NSData *)data targetSize:(CGSize)size
{
    
    //通过data获取image的数据源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //获取帧数
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    for (size_t i = 0; i < count; i++)
    {
        //获取图像
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        if (imageRef) {
            
            //生成image
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
            if (image) {
                if (!CGSizeEqualToSize(size, CGSizeZero)) {
                    image = [UIImage gxGetAspectFillImage:image targetSize:size isOpaque:YES];
                }
                
                if (image) {
                    [tmpArray addObject:image];
                }
            }
            
            CGImageRelease(imageRef);
            
            //            // 每张图片的显示时间
            //            NSDictionary *frameProperties = (NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, (size_t) i, NULL);
            //            if (frameProperties)
            //            {
            //                //由每一帧的图片信息获取gif信息
            //                NSDictionary *frameDictionary = [frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
            //                //取出每一帧的delaytime
            //                CGFloat delayTime = [[frameDictionary objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
            //            }
            //             CFRelease(frameProperties);
        }
        
        
    }
    CFRelease(source);
    
    return tmpArray;
}

+ (void)gxImgsToGifWithImgs:(NSArray *)imgs path:(NSString *)path intervalTime:(CGFloat)time;
{
    //    NSMutableArray *imgs = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"], nil];
    
    //图像目标
    CGImageDestinationRef destination;
    
    //创建输出路径
    //    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentStr = [document objectAtIndex:0];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    //    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    //    NSString *path = [textDirectory stringByAppendingPathComponent:@"test101.gif"];
    //    NSLog(@"%@",path);
    
    //创建CFURL对象
    /*
     CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
     
     allocator : 分配器,通常使用kCFAllocatorDefault
     filePath : 路径
     pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
     isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
     */
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)path,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:time], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in imgs)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(url);
    CFRelease(destination);
    
}


@end
