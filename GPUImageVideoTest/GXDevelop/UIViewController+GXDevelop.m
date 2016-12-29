//
//  UIViewController+GXDevelop.m
//  GIFY
//
//  Created by 高才新 on 16/5/23.
//  Copyright © 2016年 Steven.C. All rights reserved.
//

#import "UIViewController+GXDevelop.h"

@implementation UIViewController (GXDevelop)

- (void)gxDismissViewController:(BOOL)animationed completion:(void (^)(void))complete
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:animationed];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (complete) {
                    complete();
                }
            });
        } else {
            [self.navigationController dismissViewControllerAnimated:animationed completion:complete];
        }
    } else {
        [self dismissViewControllerAnimated:animationed completion:complete];
    }
}

- (void)gxPushViewController:(UIViewController *)vc animationed:(BOOL)animationed completion:(void (^)(void))complete
{
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:animationed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    } else {
        [self presentViewController:vc animated:YES completion:^{
            if (complete) {
                complete();
            }
        }];
    }
}

@end
