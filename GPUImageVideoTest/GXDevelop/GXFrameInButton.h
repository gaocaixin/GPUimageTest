//
//  GXFrameInButton.h
//  LOCO
//
//  Created by 高才新 on 16/2/26.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface GXFrameInButton : UIButton

/**  设定 button titlelabel 的 frame  */
@property (nonatomic, assign) CGRect gxTitleLabelFrame;
/**  设定 button ImageView 的 frame  */
@property (nonatomic, assign) CGRect gxImageViewFrame;

/**  互换 label 和 imageview 的位置  */
@property (nonatomic) BOOL gxIsExchangePosition;

/**  添加点击交互  */
@property (nonatomic) BOOL gxIsAnimationClick;


/**  改变border时的效果  */
@property (nonatomic,assign,getter=isBorderAnimate) BOOL gxBorderAnimate;

@end
