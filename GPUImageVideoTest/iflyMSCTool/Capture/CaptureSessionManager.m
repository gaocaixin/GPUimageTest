//
//  CaptureSessionManager.m
//  IFlyMFVDemo
//
//  Created by 张剑 on 15/5/7.
//
//

#import "CaptureSessionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <OpenGLES/EAGL.h>
#import "UIImage+Extensions.h"

static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface CaptureSessionManager ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation CaptureSessionManager

@synthesize session;
@synthesize previewLayer;

#pragma mark Capture Session Configuration

- (id)init {
    if ((self = [super init])) {
        self.session=[[AVCaptureSession alloc] init];
        self.lockInterfaceRotation=NO;
        self.previewLayer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self session]];
        self.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.anchorPoint=CGPointZero;
    }
    return self;
}

- (void)dealloc {
    [[self session] stopRunning];
    self.session=nil;
    self.previewLayer=nil;
}

#pragma mark -
- (void)setupAVCapture{
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        [self.session beginConfiguration];
        
        
        if([session canSetSessionPreset:AVCaptureSessionPreset640x480]){
            [session setSessionPreset:AVCaptureSessionPreset640x480];
        }
        
//        if([session canSetSessionPreset:AVCaptureSessionPresetHigh]){
//            [session setSessionPreset:AVCaptureSessionPresetHigh];
//        }
        
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [CaptureSessionManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error){
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput]){
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];

            dispatch_async(dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                [self.previewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
            });
        }
        
        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        if ([session canAddOutput:videoDataOutput]){
            [session addOutput:videoDataOutput];
            AVCaptureConnection *connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported]){
                [connection setEnablesVideoStabilizationWhenAvailable:YES];
            }
            // Configure your output.
            
            dispatch_queue_t queue = dispatch_queue_create("videoDataOutput", NULL);
            [videoDataOutput setSampleBufferDelegate:self queue:queue];
            // Specify the pixel format
            
            videoDataOutput.videoSettings =[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                       forKey:(id)kCVPixelBufferPixelFormatTypeKey];
            [self setVideoDataOutput:videoDataOutput];
        }
        
        
        [self.session commitConfiguration];
  
    });

}

- (void)addObserver{
    
        dispatch_async([self sessionQueue], ^{
            [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
    
            __weak CaptureSessionManager *weakSelf = self;
            [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
                CaptureSessionManager *strongSelf = weakSelf;
                dispatch_async([strongSelf sessionQueue], ^{
                    // Manually restarting the session since it must have been stopped due to an error.
                    [[strongSelf session] startRunning];
                });
            }]];
            [[self session] startRunning];
        });
}

- (void)removeObserver{
        dispatch_async([self sessionQueue], ^{
            [[self session] stopRunning];
    
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
            [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
    
            [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        });
}

#pragma mark -
-(BOOL)isSessionRunningAndDeviceAuthorized{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if (context == SessionRunningAndDeviceAuthorizedContext){
        BOOL boolValue = [change[NSKeyValueChangeNewKey] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            CaptureSessionContextType type=CaptureSessionContextTypeRunningAndDeviceAuthorized;
            if([self delegate] && [self.delegate respondsToSelector:@selector(observerContext:Changed:)]){
                [self.delegate observerContext:type Changed:boolValue];
            }
        });
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);

    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace){
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);

    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    
//    CIImage* outputImage = [CIImage imageWithCVPixelBuffer:imageBuffer];

    BOOL isFrontCamera=[[self videoDeviceInput] device].position==AVCaptureDevicePositionFront;
    UIDeviceOrientation orientation =[[UIDevice currentDevice] orientation];
    UIImageOrientation imageOrientation=UIImageOrientationUp;
//    CGAffineTransform t;
//    CGFloat rotationDeg=0;

    switch (orientation) {
        case UIDeviceOrientationPortrait:{//
            imageOrientation=isFrontCamera?UIImageOrientationLeftMirrored:UIImageOrientationRight;
//            rotationDeg=CGFloat(-M_PI_2);
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:{
            imageOrientation=isFrontCamera?UIImageOrientationRightMirrored:UIImageOrientationLeft;
//            rotationDeg=CGFloat(M_PI_2);
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            imageOrientation=isFrontCamera?UIImageOrientationUpMirrored:UIImageOrientationDown;
//            rotationDeg=CGFloat(M_PI);
        }
            break;
        default:{//
            imageOrientation=isFrontCamera?UIImageOrientationDownMirrored:UIImageOrientationUp;
//            rotationDeg=CGFloat(0);
        }
            
            break;
    }
//    t = CGAffineTransformMakeRotation(rotationDeg);
//    outputImage = [outputImage imageByApplyingTransform:t];
    
//    EAGLContext * eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    NSDictionary * options = @{kCIContextWorkingColorSpace:[NSNull null]};
//    CIContext* context=[CIContext contextWithEAGLContext:eaglContext options:options];
//    CGImageRef cgImage= [context createCGImage:outputImage fromRect:[outputImage extent] ];
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:imageOrientation];
    CGImageRelease(cgImage);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
    
}

- (AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        default:
            break;
    }
    NSLog(@"Warning - Didn't recognise interface orientation (%ld)",(long)orientation);
    return AVCaptureVideoOrientationPortrait;
}

#pragma mark Actions

- (IBAction)changeCamera{

    dispatch_async(dispatch_get_main_queue(), ^{
        CaptureSessionContextType type=CaptureSessionContextTypeCameraFrontOrBackToggle;
        if([self delegate] && [self.delegate respondsToSelector:@selector(observerContext:Changed:)]){
            [self.delegate observerContext:type Changed:NO];
        }
    });
    
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
        
        switch (currentPosition){
            case AVCaptureDevicePositionUnspecified:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDevice *videoDevice = [CaptureSessionManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        
        [[self session] beginConfiguration];
        
        [[self session] removeInput:[self videoDeviceInput]];
        if ([[self session] canAddInput:videoDeviceInput]){
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [CaptureSessionManager setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [[self session] addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
        }
        else{
            [[self session] addInput:[self videoDeviceInput]];
        }
        
        if([session canSetSessionPreset:AVAssetExportPreset640x480]){
            [session setSessionPreset:AVAssetExportPreset640x480];
        }
        
        [[self session] commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CaptureSessionContextType type=CaptureSessionContextTypeCameraFrontOrBackToggle;
            if([self delegate] && [self.delegate respondsToSelector:@selector(observerContext:Changed:)]){
                [self.delegate observerContext:type Changed:YES];
            }
        });
    });
}

- (void)subjectAreaDidChange:(NSNotification *)notification{
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark VideoData OutputSampleBuffer Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onOutputImage:)]){
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        [self.delegate onOutputImage:image];
    }
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode
       exposeWithMode:(AVCaptureExposureMode)exposureMode
        atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange{
    
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]){
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]){
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]){
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else{
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device{
    
    if ([device hasFlash] && [device isFlashModeSupported:flashMode]){
        NSError *error = nil;
        if ([device lockForConfiguration:&error]){
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else{
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark UI

- (void)checkDeviceAuthorizationStatus{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted){
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else{
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Warning!"
                                            message:@"App doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

@end
