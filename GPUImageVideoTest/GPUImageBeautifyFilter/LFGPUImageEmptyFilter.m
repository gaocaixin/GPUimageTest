//
//  LFGPUImageEmptyFilter.m
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/28.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "LFGPUImageEmptyFilter.h"
#import <GLKit/GLKit.h>
//#import <GLKit/GLKMath.h>
#define POINTS_KEY @"POINTS_KEY"
#define RECT_KEY   @"RECT_KEY"
#define RECT_ORI   @"RECT_ORI"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUImageEmptyFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4((textureColor.rgb), textureColor.w);
 }
 );
#else
NSString *const kGPUImageInvertFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4((textureColor.rgb), textureColor.w);
 }
 );
#endif

@implementation LFGPUImageEmptyFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUImageEmptyFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}
- (void)setImageData:(NSData *)imageData
{
    _imageData = imageData;
    // do something
}
- (void)setFaceInfos:(NSArray *)faceInfos
{
    _faceInfos = faceInfos;
    
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates
{
    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    
    // 绘制
    [_faceInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *facedict = obj;
        NSString *faceRectStr = [facedict objectForKey:RECT_KEY];
        NSArray *facePointStrArr = [facedict objectForKey:POINTS_KEY];
        
        CGRect faceRect = CGRectFromString(faceRectStr);
        
    }];
    
}

@end

