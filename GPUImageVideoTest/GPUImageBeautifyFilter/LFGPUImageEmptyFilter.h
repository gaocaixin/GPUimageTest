//
//  LFGPUImageEmptyFilter.h
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/28.
//  Copyright © 2016年 小新. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface LFGPUImageEmptyFilter : GPUImageFilter

@property (nonatomic, strong)NSArray  *faceInfos; // 人脸信息集 每个人脸的 rect 和特征点 信息
@property (nonatomic, strong)NSData  *imageData; // 目前单张贴图信息



@end
