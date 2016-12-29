//
//  UIPageControl+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 15/12/18.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import "UIPageControl+GXDevelop.h"

@implementation UIPageControl (GXDevelop)

- (void)gxSetWithFrame:(CGRect)frame totalPages:(NSUInteger)totalPages curPage:(NSUInteger)curPage pageColor:(UIColor *)pageColor curPageColor:(UIColor *)curPageColor bgColor:(UIColor *)bgColor {
    self.numberOfPages = totalPages;
    self.currentPage = curPage;
    self.backgroundColor = bgColor;
    self.pageIndicatorTintColor = pageColor;
    self.currentPageIndicatorTintColor = curPageColor;
    self.frame = frame;
}


- (void)gxSetWithTotalPages:(NSUInteger)totalPages curPage:(NSUInteger)curPage pageColor:(UIColor *)pageColor curPageColor:(UIColor *)curPageColor bgColor:(UIColor *)bgColor
{
    self.numberOfPages = totalPages;
    self.currentPage = curPage;
    self.backgroundColor = bgColor;
    self.pageIndicatorTintColor = pageColor;
    self.currentPageIndicatorTintColor = curPageColor;
}
+ (UIPageControl *)gxPagetWithTotalPages:(NSUInteger)totalPages curPage:(NSUInteger)curPage pageColor:(UIColor *)pageColor curPageColor:(UIColor *)curPageColor bgColor:(UIColor *)bgColor
{
    UIPageControl *page = [[UIPageControl alloc] init];
    [page gxSetWithTotalPages:totalPages curPage:curPage pageColor:pageColor curPageColor:curPageColor bgColor:bgColor];
    return page;
}

+ (UIPageControl *)gxPagetWithFrame:(CGRect)frame totalPages:(NSUInteger)totalPages curPage:(NSUInteger)curPage pageColor:(UIColor *)pageColor curPageColor:(UIColor *)curPageColor bgColor:(UIColor *)bgColor {
    UIPageControl *page = [[UIPageControl alloc] init];
    [page gxSetWithFrame:frame totalPages:totalPages curPage:curPage pageColor:pageColor curPageColor:curPageColor bgColor:bgColor];
    return page;
}

@end
