//
//  TencentBeautyFilter.m
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/28.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "TencentBeautyFilter.h"

NSString *const kTencentBeautyFilterFragmentShaderString = SHADER_STRING(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform vec2 singleStepOffset;
 uniform highp vec4 params;
 
 varying highp vec2 textureCoordinate;
 
 const highp vec3 W = vec3(0.299,0.587,0.114);
 const mat3 saturateMatrix = mat3(
                                  1.1102,-0.0598,-0.061,
                                  -0.0774,1.0826,-0.1186,
                                  -0.0228,-0.0228,1.1772);
 
 float hardlight(float color)
{
    if(color <= 0.5)
    {
        color = color * color * 2.0;
    }
    else
    {
        color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);
    }
    return color;
}
 
 void main()
 {
     if (params.r == 1.0) {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     } else {
         vec2 blurCoordinates[24];
         
         blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -10.0);
         blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 10.0);
         blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-10.0, 0.0);
         blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(10.0, 0.0);
         
         blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(5.0, -8.0);
         blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(5.0, 8.0);
         blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, 8.0);
         blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-5.0, -8.0);
         
         blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(8.0, -5.0);
         blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(8.0, 5.0);
         blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, 5.0);
         blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(-8.0, -5.0);
         
         blurCoordinates[12] = textureCoordinate.xy + singleStepOffset * vec2(0.0, -6.0);
         blurCoordinates[13] = textureCoordinate.xy + singleStepOffset * vec2(0.0, 6.0);
         blurCoordinates[14] = textureCoordinate.xy + singleStepOffset * vec2(6.0, 0.0);
         blurCoordinates[15] = textureCoordinate.xy + singleStepOffset * vec2(-6.0, 0.0);
         
         blurCoordinates[16] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, -4.0);
         blurCoordinates[17] = textureCoordinate.xy + singleStepOffset * vec2(-4.0, 4.0);
         blurCoordinates[18] = textureCoordinate.xy + singleStepOffset * vec2(4.0, -4.0);
         blurCoordinates[19] = textureCoordinate.xy + singleStepOffset * vec2(4.0, 4.0);
         
         blurCoordinates[20] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, -2.0);
         blurCoordinates[21] = textureCoordinate.xy + singleStepOffset * vec2(-2.0, 2.0);
         blurCoordinates[22] = textureCoordinate.xy + singleStepOffset * vec2(2.0, -2.0);
         blurCoordinates[23] = textureCoordinate.xy + singleStepOffset * vec2(2.0, 2.0);
         
         
         float sampleColor = texture2D(inputImageTexture, textureCoordinate).g * 22.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[0]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[1]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[2]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[3]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[4]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[5]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[6]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[7]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[8]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[9]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[10]).g;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[11]).g;
         
         sampleColor += texture2D(inputImageTexture, blurCoordinates[12]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[13]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[14]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[15]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[16]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[17]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[18]).g * 2.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[19]).g * 2.0;
         
         sampleColor += texture2D(inputImageTexture, blurCoordinates[20]).g * 3.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[21]).g * 3.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[22]).g * 3.0;
         sampleColor += texture2D(inputImageTexture, blurCoordinates[23]).g * 3.0;
         
         sampleColor = sampleColor / 62.0;
         
         vec3 centralColor = texture2D(inputImageTexture, textureCoordinate).rgb;
         
         float highpass = centralColor.g - sampleColor + 0.5;
         
         for(int i = 0; i < 5;i++)
         {
             highpass = hardlight(highpass);
         }
         float lumance = dot(centralColor, W);
         
         float alpha = pow(lumance, params.r);
         
         vec3 smoothColor = centralColor + (centralColor-vec3(highpass))*alpha*0.1;
         
         smoothColor.r = clamp(pow(smoothColor.r, params.g),0.0,1.0);
         smoothColor.g = clamp(pow(smoothColor.g, params.g),0.0,1.0);
         smoothColor.b = clamp(pow(smoothColor.b, params.g),0.0,1.0);
         
         vec3 lvse = vec3(1.0)-(vec3(1.0)-smoothColor)*(vec3(1.0)-centralColor);
         vec3 bianliang = max(smoothColor, centralColor);
         vec3 rouguang = 2.0*centralColor*smoothColor + centralColor*centralColor - 2.0*centralColor*centralColor*smoothColor;
         
         gl_FragColor = vec4(mix(centralColor, lvse, alpha), 1.0);
         gl_FragColor.rgb = mix(gl_FragColor.rgb, bianliang, alpha);
         gl_FragColor.rgb = mix(gl_FragColor.rgb, rouguang, params.b);
         
         vec3 satcolor = gl_FragColor.rgb * saturateMatrix;
         gl_FragColor.rgb = mix(gl_FragColor.rgb, satcolor, params.a);
     }
 }
 
 );

@implementation TencentBeautyFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kTencentBeautyFilterFragmentShaderString]))
    {
        return nil;
    }
    
//    self.beautyLevel = 2
//    ;
    _beauty = 0.5;
    _tone = 0.5;
    [self setbeauty:_beauty tone:_tone];
    return self;
}
- (void)setBeauty:(CGFloat)beauty
{
    _beauty = beauty;
    [self setbeauty:_beauty tone:_tone];
}
- (void)setTone:(CGFloat)tone
{
    _tone = tone;
    [self setbeauty:_beauty tone:_tone];
}
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex
{
//    CGSize oldInputSize = inputTextureSize;
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    CGPoint offset = CGPointMake(2.0f / inputTextureSize.width, 2.0 / inputTextureSize.height);
    [self setPoint:offset forUniformName:@"singleStepOffset"];
}

- (void)setbeauty:(CGFloat)beauty tone:(CGFloat)tone
{
//    float[] p = new float[] {1.0f - 0.6f * beauty, 1.0f - 0.3f * beauty, 0.1f + 0.3f * tone, 0.1f + 0.3f * tone};
    GPUVector4 vect4 = (GPUVector4){1.0f - 0.6f * beauty, 1.0f - 0.3f * beauty, 0.1f + 0.3f * tone, 0.1f + 0.3f * tone};
    GLint uniformIndex = [filterProgram uniformIndex:@"params"];
    [self setVec4:vect4 forUniform:uniformIndex program:filterProgram];
}


@end
