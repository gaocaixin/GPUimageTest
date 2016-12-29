//
//  CaptureSessionManager.h
//  IFlyMFVDemo
//
//  Created by 张剑 on 15/5/7.
//
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, CaptureSessionContextType){
    CaptureSessionContextTypeRunningAndDeviceAuthorized,
    CaptureSessionContextTypeCameraFrontOrBackToggle
};

@protocol CaptureSessionManagerDelegate <NSObject>

@optional

-(void)onOutputImage:(UIImage*)img;

-(void)observerContext:(CaptureSessionContextType)type Changed:(BOOL)boolValue;

@end

/**
 *  一个简单的拍照管理类用于自定义拍照界面。
 */
@interface CaptureSessionManager : NSObject

// functions
- (void)changeCamera;
- (AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation ;

// init CaptureSessionManager functions
- (void)setupAVCapture;
- (void)addObserver;
- (void)removeObserver;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

// delegate
@property (nonatomic) id<CaptureSessionManagerDelegate> delegate;
// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;

@end
