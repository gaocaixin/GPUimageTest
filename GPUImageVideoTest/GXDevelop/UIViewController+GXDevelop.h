//
//  UIViewController+GXDevelop.h
//  GIFY
//
//  Created by 高才新 on 16/5/23.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GXDevelop)

/**推出控制器*/
- (void)gxPushViewController:(UIViewController *)vc animationed:(BOOL)animationed completion:(void (^)(void))complete;
/**控制器消失*/
- (void)gxDismissViewController:(BOOL)animationed completion:(void (^)(void))complete;

@end
