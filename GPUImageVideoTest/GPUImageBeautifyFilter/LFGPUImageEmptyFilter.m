//
//  LFGPUImageEmptyFilter.m
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/28.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "LFGPUImageEmptyFilter.h"

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

@end

