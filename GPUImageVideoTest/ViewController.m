
//
//  ViewController.m
//  GPUImageVideoTest
//
//  Created by 小新 on 16/12/26.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "UIImageView+PlayGIF.h"
#import "GXDevelop.h"
#import "MovieViewController.h"
#import "LFGPUImageBeautyFilter.h"

#import "TencentBeautyFilter.h"
#import "LFGPUImageEmptyFilter.h"
#import "IFlyFaceImage.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "UIImage+Extensions.h"
#import "UIImage+compress.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "CaptureManager.h"
#import "CanvasView.h"
#import "CalculatorTools.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"

#define useFilter 1
#define useFace 1

@interface ViewController ()<GPUImageVideoCameraDelegate>

@property(strong, nonatomic) GPUImageVideoCamera *videoCamera;
@property(strong, nonatomic) GPUImageFilter *filter;
@property(strong, nonatomic) GPUImageView *filterView;
@property(strong, nonatomic) GPUImageUIElement *uiElementInput;
@property(strong, nonatomic) CIDetector *faceDetector;
@property(assign, nonatomic) CGRect faceBounds;

@property(strong, nonatomic) NSArray *faceBoundArr;

@property(strong, nonatomic) GPUImageMovieWriter *movieWriter;


@property(copy, nonatomic) NSString * pathToMovie;

@property(strong, nonatomic) GPUImageAlphaBlendFilter *blendFilter;

@property(strong, nonatomic)NSMutableArray *imagearr;

@property(assign, nonatomic)CGFloat  beauty;
@property(assign, nonatomic)CGFloat  tone;

@property (nonatomic, strong ) IFlyFaceDetector           *iflyfaceDetector;
@property (nonatomic, strong ) CanvasView                 *viewCanvas;

@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
@property (strong,nonatomic) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beauty = 0.5;
    self.tone = 0.5;
    
    // 这里使用CoreMotion来获取设备方向以兼容iOS7.0设备
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 if (!error) {
                                                     [self updateAccelertionData:accelerometerData.acceleration];
                                                 }
                                                 else{
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view, typically from a nib.
    // 特征检测
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    _iflyfaceDetector = [IFlyFaceDetector sharedInstance];
    [_iflyfaceDetector setParameter:@"1"  forKey:@"detect"];
    [_iflyfaceDetector setParameter:@"1" forKey:@"align"];


    // 摄像头
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.delegate = self;
    [_videoCamera addAudioInputsAndOutputs];
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;

    // 显示层
    _filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.gxWidth, self.view.gxWidth * 640./480)];
    _filterView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.view addSubview:_filterView];
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:_filterView.frame] ;
    [self.filterView addSubview:self.viewCanvas] ;
//    self.viewCanvas.center=self.captureManager.previewLayer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor] ;
    // 滤镜
    _filter = [[TencentBeautyFilter alloc] init];
    // 响应链
    
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1.0;
    UIView *temp = [[UIView alloc] initWithFrame:self.view.frame];
    
    
    // 时间 label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 100.0, 240.0f, 40.0f)];
    timeLabel.font = [UIFont systemFontOfSize:17.0f];
    timeLabel.text = @"Time: 0.0 s";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    [temp addSubview:timeLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 00.0, 375.0f, 80.0f)];
    descLabel.font = [UIFont systemFontOfSize:17.0f];
    descLabel.text = @"美颜滤镜+人脸识别+动态gif图+动态UI视图+视频录制";
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textColor = [UIColor yellowColor];
    descLabel.numberOfLines = 0;
    [temp addSubview:descLabel];



    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 500, 100, 100)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.gifPath = [[NSBundle mainBundle] pathForResource:@"tumblr_ngukgdu1FA1s7ldogo1_500.gif" ofType:nil];
    [temp addSubview:imageView];
    [imageView startGIF];

    // 人脸识别的图片
    _imagearr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.image = [UIImage imageNamed:@"tumblr_ngukgdu1FA1s7ldogo1_500"];
        imageView.gifPath = [[NSBundle mainBundle] pathForResource:@"tumblr_ngukgdu1FA1s7ldogo1_500.gif" ofType:nil];
        [temp addSubview:imageView];
        imageView.hidden = YES;
        [_imagearr addObject:imageView];
    }

    // 滤镜与上面的 View 融合
    //    NSDate *startTime = [NSDate date];

    _uiElementInput = [[GPUImageUIElement alloc] initWithView:temp];

#pragma mark  是否打开滤镜及动画
    if (useFilter ) { // 打开滤镜及动画
            [_videoCamera addTarget:_filter];
//            [_filter addTarget:blendFilter];
//            [_uiElementInput addTarget:blendFilter];
//            [blendFilter addTarget:_filterView];
            [_filter addTarget:_filterView];
    } else { // 关闭滤镜动画
            [_videoCamera addTarget:_filterView];
    }
    self.blendFilter = blendFilter;
    
    // 实时调用
//    CGRect frame = timeLabel.frame;
//    GXWeakSelf(weakSelf)
//
//    __unsafe_unretained GPUImageUIElement *weakUIElementInput = _uiElementInput;
//    [_filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
//        // 控件移动
//        CGFloat time = [startTime timeIntervalSinceNow];
//        timeLabel.text = [NSString stringWithFormat:@"Time: %f s", -time];
//        NSUInteger move = -time*10;
//        if (move > 50) {
//            move = move %50;
//        }
//        timeLabel.frame = CGRectMake(frame.origin.x + move, frame.origin.y + move, frame.size.width, frame.size.height);
////        layer.frame = CGRectMake(frame.origin.x + move, frame.origin.y + move + 100, frame.size.width - move, frame.size.height + move);
//
//        // 显示人脸位置
//        [weakSelf.imagearr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            UIImageView *imageView = obj;
//            if (weakSelf.faceDetector && idx < self.faceBoundArr.count) {
//                imageView.frame = [(NSValue *)weakSelf.faceBoundArr[idx] CGRectValue] ;
//                imageView .hidden = NO;
//                [imageView startGIF];
//            } else {
//                imageView.hidden = YES;
//                [imageView stopGIF];
//            }
//
//        }];
//        [weakUIElementInput update];
//    }];
    
    [_videoCamera startCameraCapture];
    

    // 长按录制
    UIView *moverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 60)];
    moverView.layer.cornerRadius = moverView.frame.size.height/2.;
    [self.view addSubview:moverView];
    moverView.backgroundColor = [UIColor redColor];
    moverView.gxMaxX = self.view.gxWidth;
    moverView.gxY = _filterView.gxMaxY + 10;
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longG:)];
    [moverView addGestureRecognizer:longG];
    
    UILabel *moverLabel = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(moverView.frame, UIEdgeInsetsMake(0, 10, 0, 10))];
    [self.view addSubview:moverLabel];
    moverLabel.text = @"长按此控件录制以上视频,松手结束录制,到系统相册内查看视频";
    moverLabel. textColor = [UIColor whiteColor];
    moverLabel.numberOfLines = 0;
    moverLabel.font = [UIFont systemFontOfSize:12];
    moverLabel.textAlignment = NSTextAlignmentCenter;
    
    NSArray *titles = @[@"切换摄像头"];
    [self createswitch:titles];
    
    NSArray * arr = @[@"滤镜beauty", @"滤镜tone"];
    [self createsfilterwitch:arr];
    
    
}

- (void)createsfilterwitch:(NSArray *)titles
{
    CGFloat height = 40;
    //    CGFloat padding = 5;
    CGFloat width = self.view.gxWidth / 4;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UISlider *swi = [[UISlider alloc] initWithFrame:CGRectMake(0, _filterView.gxMaxY+height*idx, width, height)];
        swi.value = 0.5;
        swi.tag = idx;
        [swi addTarget:self action:@selector(filtervalueChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:swi];
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(swi.gxMaxX, swi.gxY, swi.gxWidth, swi.gxHeight)];
        label.text = obj;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self.view addSubview:label];

    }];
}
- (void)filtervalueChange:(UISlider *)sw
{
    switch (sw.tag) {
        case 0:
        {
            [self beauty:sw.value];
        }
            break;
        case 1:
        {
            [self tone:sw.value];
        }
            break;

            
        default:
            break;
    }
}

- (void)beauty:(CGFloat)value
{
    if ([_filter isKindOfClass:[TencentBeautyFilter class]]) {
        self.beauty = value;
        [( TencentBeautyFilter *)_filter setBeauty:self.beauty];
    }
}
- (void)tone:(CGFloat)value
{
    if ([_filter isKindOfClass:[TencentBeautyFilter class]]) {
        self.tone = value;
        [( TencentBeautyFilter *)_filter setTone:_tone];
    }
}

- (void)createswitch:(NSArray *)titles
{
    CGFloat height = 40;
//    CGFloat padding = 5;
    CGFloat width = self.view.gxWidth / titles.count;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectMake(width * idx, self.view.gxHeight-height, width, height)];
        swi.tag = idx;
        swi.on = YES;
        [swi addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:swi];
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(swi.gxX, swi.gxY - height, swi.gxWidth, swi.gxHeight)];
        label.text = obj;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self.view addSubview:label];
        
        if (idx == 1) {
            swi.enabled = NO;
        }
    }];
}

- (void)valueChange:(UISwitch *)sw
{
    switch (sw.tag) {
        case 0:
        {
            [self Switchingcamera:sw.on];
        }
            break;
            
        default:
            break;
    }
}

- (void)Facerecognition:(BOOL)on
{
    if (on) {
        // 特征检测
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    } else {
        _faceDetector = nil;

    }
}
- (void)BeautyFilter:(BOOL)on
{
//    [_videoCamera stopCameraCapture ];
//    
//    if (on) {
//        _filter = [[TencentBeautyFilter alloc] init];
//
//    } else {
//        _filter = [[LFGPUImageEmptyFilter alloc] init];
//    }
//    
//    [_videoCamera removeAllTargets];
//    
//    [_videoCamera addTarget:_filter];
//    [_filter addTarget:_blendFilter];
//    [_blendFilter addTarget:_filterView];
//    
//    [_videoCamera startCameraCapture];

}
- (void)Switchingcamera:(BOOL)on
{
    [self.videoCamera rotateCamera];
}

- (void)longG:(UIGestureRecognizer *)longG
{
    switch (longG.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self startmovie:longG];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self endmovie:longG];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self endmovie:longG];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)startmovie:(UIGestureRecognizer *)longG
{
    longG.view.backgroundColor = [UIColor greenColor];
    
    NSString *str = [[[[NSDate date] description] gxMd5] stringByAppendingString:@".mp4"];
    NSString * pathToMovie = [GXFileManager.gxDocumentsPath stringByAppendingPathComponent:str];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
//    unlink([pathToMovie UTF8String]); // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    _movieWriter.encodingLiveVideo = YES;
    [self.blendFilter addTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = _movieWriter;
    [_movieWriter startRecording];
    
    self.pathToMovie = pathToMovie;
}
- (void)endmovie:(UIGestureRecognizer *)longG
{
    
    longG.view.backgroundColor = [UIColor redColor];
//    [_videoCamera removeAudioInputsAndOutputs];

    [self.blendFilter removeTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = nil;
    [_movieWriter finishRecording];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.pathToMovie)) {
           UISaveVideoAtPathToSavedPhotosAlbum(self.pathToMovie, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        GXLogMsg(@"pathToMovie-Compatible-", self.pathToMovie);
    } else {
        GXLogMsg(@"pathToMovie-NO-Compatible-", self.pathToMovie);
    }

}
// 视频保存回调

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo{
    
    NSLog(@"%@",videoPath);
    
    NSLog(@"%@",error);
    
}

#pragma mark GPUimage 输出视频原始 buf
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if (!useFace) { return ;};
    // 使用科大讯飞人脸识别
    IFlyFaceImage* faceImage=[self faceImageFromSampleBuffer:sampleBuffer];
    [self onOutputFaceImage:faceImage];
    faceImage = nil;
    return;
    
    if (!_faceDetector) {
        return;
    }

        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        CIImage *convertedImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];

    NSInteger exifOrientation = [self getExifOrientationValue];
    NSDictionary *imageOptions = @{CIDetectorImageOrientation : @(exifOrientation),
                                   CIDetectorSmile : @(YES)};
        NSArray *featureArray = [self.faceDetector featuresInImage:convertedImage options:imageOptions];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{smu
    NSMutableArray *arr= [NSMutableArray array];
        for ( CIFaceFeature *faceFeature in featureArray) {
            // find the correct position for the square layer within the previewLayer
            // the feature box originates in the bottom left of the video frame.
            // (Bottom right if mirroring is turned on)
            //Update face bounds for iOS Coordinate System
            CGRect faceRect = [faceFeature bounds];
            
            // flip preview width and height
                    CGFloat temp = faceRect.size.width;
                    faceRect.size.width = faceRect.size.height;
                    faceRect.size.height = temp;
                    temp = faceRect.origin.x;
                    faceRect.origin.x = faceRect.origin.y;
                    faceRect.origin.y = temp;
            // scale coordinates so they fit in the preview box, which may be scaled
            //        CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
            //        CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
            //        faceRect.size.width *= widthScaleBy;
            //        faceRect.size.height *= heightScaleBy;
            //        faceRect.origin.x *= widthScaleBy;
            //        faceRect.origin.y *= heightScaleBy;
            //
            //        faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
            
            //mirror
            //        CGRect rect = CGRectMake(previewBox.size.width - faceRect.origin.x - faceRect.size.width, faceRect.origin.y, faceRect.size.width, faceRect.size.height);
            //        if (fabs(rect.origin.x - self.faceBounds.origin.x) > 5.0) {
            //            
            //        }
            self.faceBounds = faceRect;
            NSLog(@"%@", NSStringFromCGRect(faceRect));
            [arr addObject:[NSValue valueWithCGRect:faceRect]];
        }
    self.faceBoundArr = [NSArray arrayWithArray:arr];
//    });
}

- (NSInteger)getExifOrientationValue
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    NSInteger exifOrientation;
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT          = 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT         = 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    
    BOOL isUsingFrontFacingCamera = FALSE;
    AVCaptureDevicePosition currentCameraPosition = [self cameraPosition];
    
    if (currentCameraPosition != AVCaptureDevicePositionBack) {
        isUsingFrontFacingCamera = TRUE;
    }
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
            
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera) {
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            } else {
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            }
            break;
            
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera) {
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            } else {
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            }
            break;
            
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    return exifOrientation;
}

- (AVCaptureDevicePosition)cameraPosition
{
    return AVCaptureDevicePositionBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IFlyFaceImage *) faceImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    
    //获取灰度图像数据
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    uint8_t *lumaBuffer  = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
    size_t width  = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context=CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace,0);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    IFlyFaceDirectionType faceOrientation=[self faceImageOrientation];
    
    IFlyFaceImage* faceImage=[[IFlyFaceImage alloc] init];
    if(!faceImage){
        return nil;
    }
    
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    
    faceImage.data= (__bridge_transfer NSData*)CGDataProviderCopyData(provider);
    faceImage.width=width;
    faceImage.height=height;
    faceImage.direction=faceOrientation;
    
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
    
    
    
    return faceImage;
    
}

- (void)updateAccelertionData:(CMAcceleration)acceleration{
    UIInterfaceOrientation orientationNew;
    
    if (acceleration.x >= 0.75) {
        orientationNew = UIInterfaceOrientationLandscapeLeft;
    }
    else if (acceleration.x <= -0.75) {
        orientationNew = UIInterfaceOrientationLandscapeRight;
    }
    else if (acceleration.y <= -0.75) {
        orientationNew = UIInterfaceOrientationPortrait;
    }
    else if (acceleration.y >= 0.75) {
        orientationNew = UIInterfaceOrientationPortraitUpsideDown;
    }
    else {
        // Consider same as last time
        return;
    }
    
    if (orientationNew == self.interfaceOrientation)
        return;
    
    self.interfaceOrientation = orientationNew;
}

-(IFlyFaceDirectionType)faceImageOrientation{
    
    IFlyFaceDirectionType faceOrientation=IFlyFaceDirectionTypeLeft;
    BOOL isFrontCamera=self.videoCamera.inputCamera.position==AVCaptureDevicePositionFront;
    switch (self.interfaceOrientation) {
        case UIDeviceOrientationPortrait:{//
            faceOrientation=IFlyFaceDirectionTypeLeft;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:{
            faceOrientation=IFlyFaceDirectionTypeRight;
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            faceOrientation=isFrontCamera?IFlyFaceDirectionTypeUp:IFlyFaceDirectionTypeDown;
        }
            break;
        default:{//
            faceOrientation=isFrontCamera?IFlyFaceDirectionTypeDown:IFlyFaceDirectionTypeUp;
        }
            
            break;
    }
    
    return faceOrientation;
}
-(void)onOutputFaceImage:(IFlyFaceImage*)faceImg{
    
    NSString* strResult=[self.iflyfaceDetector trackFrame:faceImg.data withWidth:faceImg.width height:faceImg.height direction:(int)faceImg.direction];
    NSLog(@"result:%@",strResult);
    
    //此处清理图片数据，以防止因为不必要的图片数据的反复传递造成的内存卷积占用。
    faceImg.data=nil;
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(praseTrackResult:OrignImage:)];
    if (!sig) return;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(praseTrackResult:OrignImage:)];
    [invocation setArgument:&strResult atIndex:2];
    [invocation setArgument:&faceImg atIndex:3];
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil  waitUntilDone:NO];
    faceImg=nil;
}
-(void)praseTrackResult:(NSString*)result OrignImage:(IFlyFaceImage*)faceImg{
    
    if(!result){
        return;
    }
    
    @try {
        NSError* error;
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* faceDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        resultData=nil;
        if(!faceDic){
            return;
        }
        
        NSString* faceRet=[faceDic objectForKey:KCIFlyFaceResultRet];
        NSArray* faceArray=[faceDic objectForKey:KCIFlyFaceResultFace];
        faceDic=nil;
        
        int ret=0;
        if(faceRet){
            ret=[faceRet intValue];
        }
        //没有检测到人脸或发生错误
        if (ret || !faceArray || [faceArray count]<1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideFace];
            } ) ;
            return;
        }
        
        //检测到人脸
        
        NSMutableArray *arrPersons = [NSMutableArray array] ;
        
        for(id faceInArr in faceArray){
            
            if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                
                NSDictionary* positionDic=[faceInArr objectForKey:KCIFlyFaceResultPosition];
                NSString* rectString=[self praseDetect:positionDic OrignImage: faceImg];
                positionDic=nil;
                
                NSDictionary* landmarkDic=[faceInArr objectForKey:KCIFlyFaceResultLandmark];
                NSMutableArray* strPoints=[self praseAlign:landmarkDic OrignImage:faceImg];
                landmarkDic=nil;
                
                
                NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary] ;
                if(rectString){
                    [dicPerson setObject:rectString forKey:RECT_KEY];
                }
                if(strPoints){
                    [dicPerson setObject:strPoints forKey:POINTS_KEY];
                }
                
                strPoints=nil;
                
                [dicPerson setObject:@"0" forKey:RECT_ORI];
                [arrPersons addObject:dicPerson] ;
                
                dicPerson=nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
                } ) ;
            }
        }
        faceArray=nil;
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {
    }
    
}
-(NSString*)praseDetect:(NSDictionary* )positionDic OrignImage:(IFlyFaceImage*)faceImg{
    
    if(!positionDic){
        return nil;
    }
    
    
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.videoCamera.inputCamera.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.filterView.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.filterView.frame.size.height / faceImg.width;
    
    CGFloat bottom =[[positionDic objectForKey:KCIFlyFaceResultBottom] floatValue];
    CGFloat top=[[positionDic objectForKey:KCIFlyFaceResultTop] floatValue];
    CGFloat left=[[positionDic objectForKey:KCIFlyFaceResultLeft] floatValue];
    CGFloat right=[[positionDic objectForKey:KCIFlyFaceResultRight] floatValue];
    
    
    float cx = (left+right)/2;
    float cy = (top + bottom)/2;
    float w = right - left;
    float h = bottom - top;
    
    float ncx = cy ;
    float ncy = cx ;
    
    CGRect rectFace = CGRectMake(ncx-w/2 ,ncy-w/2 , w, h);
    
    if(!isFrontCamera){
        rectFace=rSwap(rectFace);
        rectFace=rRotate90(rectFace, faceImg.height, faceImg.width);
    }
    
    rectFace=rScale(rectFace, widthScaleBy, heightScaleBy);
    
    return NSStringFromCGRect(rectFace);
    
}

-(NSMutableArray*)praseAlign:(NSDictionary* )landmarkDic OrignImage:(IFlyFaceImage*)faceImg{
    if(!landmarkDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera=self.videoCamera.inputCamera.position==AVCaptureDevicePositionFront;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.filterView.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.filterView.frame.size.height / faceImg.width;
    
    NSMutableArray *arrStrPoints = [NSMutableArray array] ;
    NSEnumerator* keys=[landmarkDic keyEnumerator];
    for(id key in keys){
        id attr=[landmarkDic objectForKey:key];
        if(attr && [attr isKindOfClass:[NSDictionary class]]){
            
            id attr=[landmarkDic objectForKey:key];
            CGFloat x=[[attr objectForKey:KCIFlyFaceResultPointX] floatValue];
            CGFloat y=[[attr objectForKey:KCIFlyFaceResultPointY] floatValue];
            
            CGPoint p = CGPointMake(y,x);
            
            if(!isFrontCamera){
                p=pSwap(p);
                p=pRotate90(p, faceImg.height, faceImg.width);
            }
            
            p=pScale(p, widthScaleBy, heightScaleBy);
            
            [arrStrPoints addObject:NSStringFromCGPoint(p)];
            
        }
    }
    return arrStrPoints;
    
}

- (void) hideFace {
    if (!self.viewCanvas.hidden) {
        self.viewCanvas.hidden = YES ;
    }
//    [self.blendFilter disableSecondFrameCheck];
}
- (void) showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons{
    if (self.viewCanvas.hidden) {
        self.viewCanvas.hidden = NO ;
    }
    self.viewCanvas.arrPersons = arrPersons ;
    [self.viewCanvas setNeedsDisplay] ;
//    [self.blendFilter ];

}

@end
