//
//  UIApplication+GXDevelop.m
//  GIFY
//
//  Created by 小新 on 16/7/12.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "UIApplication+GXDevelop.h"

@implementation UIApplication (GXDevelop)

- (NSString *)gxAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)gxAppVersionBuild
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end


//{
//    
//    CFBundleDevelopmentRegion= en;
//    
//    CFBundleDisplayName ="";
//    
//    CFBundleExecutable ="";
//    
//    CFBundleExecutablePath ="";
//    
//    CFBundleIdentifier ="";
//    
//    CFBundleInfoDictionaryVersion = "6.0";
//    
//    CFBundleInfoPlistURL ="";
//    
//    CFBundleName = "";
//    
//    CFBundlePackageType =APPL;
//    
//    CFBundleShortVersionString= "1.0";
//    
//    CFBundleSignature ="????";
//    
//    CFBundleSupportedPlatforms=     (
//                                     
//                                     iPhoneSimulator
//                                     
//                                     );
//    
//    CFBundleVersion ="1.0";
//    
//    DTPlatformName =iphonesimulator;
//    
//    DTSDKName ="iphonesimulator6.1";
//    
//    LSRequiresIPhoneOS =1;
//    
//    NSBundleInitialPath ="";
//    
//    NSBundleResolvedPath ="";
//    
//    UIDeviceFamily =    (
//                         
//                         1,
//                         
//                         2
//                         
//                         );
//    
//    UIRequiredDeviceCapabilities =    (
//                                       
//                                       armv7
//                                       
//                                       );
//    
//    UISupportedInterfaceOrientations =    (
//                                           
//                                           UIInterfaceOrientationPortrait,
//                                           
//                                           UIInterfaceOrientationLandscapeLeft,
//                                           
//                                           UIInterfaceOrientationLandscapeRight
//                                           
//                                           );
//    
//    
//    
//}

