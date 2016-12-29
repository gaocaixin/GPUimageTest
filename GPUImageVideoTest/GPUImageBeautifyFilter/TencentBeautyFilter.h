//
//  TencentBeautyFilter.h
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/28.
//  Copyright © 2016年 小新. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface TencentBeautyFilter : GPUImageFilter

@property (assign , nonatomic) CGFloat beauty; // 美颜程度
@property (assign , nonatomic) CGFloat tone; // 亮度

@end
