//
//  UIImage+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 16/1/21.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import "UIImage+GXDevelop.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <float.h>
#include <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (GXDevelop)
+ (UIImage*)gxImageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    path.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    [path fill];
    [path stroke];
    [path addClip];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gxImageName:(NSString *)name tintColor:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:name];
    image = [image gxImageWithTintColor:color];
    return image;
}

- (UIImage *)gxImageWithTintColor:(UIColor *)tintColor {
    return [self gxImageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)gxImageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}




//   other code
- (UIImage *)gxStretch{
    return [self stretchableImageWithLeftCapWidth:self.size.width/2 topCapHeight:self.size.height/2];
}
-(UIImage*)gxScaleToSize:(NSInteger)size {
    NSInteger kMaxResolution = size; // Or whatever
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



- (UIImage *) gxImageWithGradientTintColor:(UIColor *)tintColor {
    return [self gxImageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}


- (UIImage *) gxImageWithBorderColor:(UIColor *)borderColor width:(CGFloat) width{
    CGSize size = [self size];
    //UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    //    ASSERT([borderColor getRed:&red green:&green blue:&blue alpha:&alpha]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, width);
    CGContextStrokeRect(context, rect);
    UIImage *returnImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)gxImageWithScaledToSize:(CGSize)newSize {
    if (CGSizeEqualToSize(self.size, newSize))
        return self;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}
- (UIImage *)gxClipImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}

/*
 * @brief rotate image 90 with Clockwise
 */
- (UIImage*)gxRotate90Clockwise {
    UIImage *image = nil;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRight];
            break;
        case UIImageOrientationDown:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeft];
            break;
        case UIImageOrientationLeft:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationRight:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationUpMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored];
            break;
        case UIImageOrientationDownMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRightMirrored];
            break;
        case UIImageOrientationLeftMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDownMirrored];
            break;
        case UIImageOrientationRightMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
            break;
        default:
            break;
    }
    
    return image;
}

/*
 * @brief flip horizontal
 */
- (UIImage*)gxFlipHorizontal {
    UIImage *image = nil;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
            break;
        case UIImageOrientationDown:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDownMirrored];
            break;
        case UIImageOrientationLeft:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRightMirrored];
            break;
        case UIImageOrientationRight:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored];
            break;
        case UIImageOrientationUpMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationDownMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationLeftMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRight];
            break;
        case UIImageOrientationRightMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeft];
            break;
        default:
            break;
    }
    
    return image;
}

- (UIImage *)gxFixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage*) gxImageDeepCopy: (UIImage *)imageToCopy {
    UIGraphicsBeginImageContextWithOptions(imageToCopy.size, YES, [imageToCopy scale]);
    [imageToCopy drawInRect:CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
    UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copiedImage;
}

- (CGFloat)gxWidth{
    return self.size.width;
}
- (CGFloat)gxHeight{
    return self.size.height;
}
- (UIImage *)gxMirrorVertical{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contex, 0, self.height);
    CGContextScaleCTM(contex, 1.0, -1.0);
    [self drawInRect:CGRectMake(0, 0, self.width, self.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)gxMirrorHorizon{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contex, self.width, 0);
    CGContextScaleCTM(contex, -1.0, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.width, self.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}



- (UIImage *)gxApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    return [self gxApplyBlurWithRadius:blurRadius tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage alpha:NO];
}
- (UIImage *)gxApplyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage alpha:(BOOL)isAlpah
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * self.scale;
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, !isAlpah, self.scale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


+ (UIImage *) gxImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

+ (CGSize) gxGetAspectFillSize:(CGSize) size targetSize:(CGSize)dest {
    CGFloat scale = MAX(dest.width*1.f/size.width, dest.height*1.f/size.height);
    return CGSizeMake((size.width*scale),(size.height*scale));
}

+ (UIImage *) gxGetAspectFillImage:(UIImage *)imageToCopy targetSize:(CGSize)size isOpaque:(BOOL)isOpaque {
    CGSize image_size = imageToCopy.size;
    
    CGSize draw_size = [UIImage gxGetAspectFillSize:image_size targetSize:size];
    CGRect rect = CGRectMake((size.width-draw_size.width)/2.f, (size.height-draw_size.height)/2.f, draw_size.width, draw_size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, isOpaque, [[UIScreen mainScreen] scale]);
    
    CGContextRef _cgctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(_cgctx);
    CGContextSetInterpolationQuality(_cgctx, kCGInterpolationHigh);
    CGContextSetAllowsAntialiasing(_cgctx, YES);
    CGContextSetShouldAntialias(_cgctx, YES);
    [imageToCopy drawInRect:rect];
    CGContextRestoreGState(_cgctx);
    UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copiedImage;
}

// aspect fit for dest ( but the size can cover the dest) aka: the smallest size for performance with kept ratio
+ (UIImage*) gxGetScaleFitImage:(UIImage *) imageToCopy  targetSize:(CGSize)size {
    CGSize image_size = imageToCopy.size;
    
    CGSize draw_size = [UIImage gxGetAspectFillSize:image_size targetSize:size];
    
    CGRect rect = CGRectMake(0, 0, draw_size.width, draw_size.height);
    
    UIGraphicsBeginImageContextWithOptions(draw_size, YES, [[UIScreen mainScreen] scale]);
    
    CGContextRef _cgctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(_cgctx);
    CGContextSetInterpolationQuality(_cgctx, kCGInterpolationHigh);
    CGContextSetAllowsAntialiasing(_cgctx, YES);
    CGContextSetShouldAntialias(_cgctx, YES);
    [imageToCopy drawInRect:rect];
    CGContextRestoreGState(_cgctx);
    UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copiedImage;
}


+ (UIImage*)gxImageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));
    
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
                                        roundf((newImageSize.height-firstImage.size.height)/2))];
    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
                                         roundf((newImageSize.height-secondImage.size.height)/2))];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)gxBlurryImageWithBlurLevel:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"gxBlurryImage-No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"gxBlurryImage-error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
//    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)gximageGaussianBlur:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage = [CIImage imageWithCGImage:self.CGImage];
 
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];

    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[inputImage extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}


- (UIImage *)gxApplySubtleEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self gxApplyBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)gxApplyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self gxApplyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)gxApplyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self gxApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)gxApplyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self gxApplyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)gxApplyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self gxApplyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}



- (UIImage *)gxApplyGaussianBlur:(CGFloat)blurLevel{
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blurLevel),
                        nil];
    
    CIImage *outputImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage
                                        fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return image;
}
- (UIImage *)gxApplyBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    outBuffer.data     = CGBitmapContextGetData(effectOutContext);
    outBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    outBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    outBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    UIImage *effectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CFRelease(inBitmapData);
    return effectImage;
}


- (CGRect)gxFrameFitTo:(CGRect)frame{
    if (frame.size.width <=0.1 || frame.size.height<=0)
        return frame;
    
    CGFloat scale = MAX(self.width/frame.size.width, self.height/frame.size.height);
    CGSize size = CGSizeMake(self.width/scale, self.height/scale);
    return CGRectMake(frame.origin.x + (frame.size.width-size.width)/2,
                      frame.origin.y + (frame.size.height-size.height)/2,
                      size.width, size.height);
}
- (CGRect)gxFrameFillTo:(CGRect)frame{
    if (frame.size.width <=0.1 || frame.size.height<=0)
        return frame;
    
    CGFloat scale = MIN(self.width/frame.size.width, self.height/frame.size.height);
    CGSize size = CGSizeMake(self.width/scale, self.height/scale);
    return CGRectMake(frame.origin.x + (frame.size.width-size.width)/2,
                      frame.origin.y + (frame.size.height-size.height)/2,
                      size.width, size.height);
}
- (CGSize)gxSizeFitTo:(CGSize)size{
    return [self gxFrameFitTo:CGRectMake(0, 0, size.width, size.height)].size;
}
- (CGSize)gxSizeFillTo:(CGSize)size{
    return [self gxFrameFillTo:CGRectMake(0, 0, size.width, size.height)].size;
}


- (UIImage *)gxFitToSize:(CGSize)size{
    CGFloat scale = MIN(size.width/self.width, size.height/self.height);
    if (scale>1.0)
        return self;
    
    CGSize draw_size = CGSizeMake((int)(self.width*scale), (int)(self.height*scale));
    
    CGRect rect = CGRectMake(0, 0, draw_size.width, draw_size.height);
    
    UIGraphicsBeginImageContextWithOptions(draw_size, YES, self.scale);
    
    CGContextRef _cgctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(_cgctx);
    CGContextSetInterpolationQuality(_cgctx, kCGInterpolationHigh);
    CGContextSetAllowsAntialiasing(_cgctx, YES);
    CGContextSetShouldAntialias(_cgctx, YES);
    [self drawInRect:rect];
    CGContextRestoreGState(_cgctx);
    UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copiedImage;
}

- (UIImage *)gxCoverToSize:(CGSize)size{
    CGFloat scale = MAX(size.width/self.width, size.height/self.height);
    CGSize draw_size = CGSizeMake((int)(self.width*scale), (int)(self.height*scale));
    
    CGRect rect = CGRectMake(0, 0, draw_size.width, draw_size.height);
    
    UIGraphicsBeginImageContextWithOptions(draw_size, YES, self.scale);
    
    CGContextRef _cgctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(_cgctx);
    CGContextSetInterpolationQuality(_cgctx, kCGInterpolationHigh);
    CGContextSetAllowsAntialiasing(_cgctx, YES);
    CGContextSetShouldAntialias(_cgctx, YES);
    [self drawInRect:rect];
    CGContextRestoreGState(_cgctx);
    UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copiedImage;
}
-(UIImage*)scaleToSize:(NSInteger)size{
    NSInteger kMaxResolution = size; // Or whatever
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//+ (UIImage *)gxImageWithFileName:(NSString *)fileName{
//    
//    if (fileName.length <= 0)
//        return nil;
//    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *file = fileName;
//    NSString *type = nil;
//    if ([fileName rangeOfString:@"."].location != NSNotFound) {
//        NSArray *arr = [fileName componentsSeparatedByString:@"."];
//        type = [arr lastObject];
//        file = [file substringToIndex:fileName.length-type.length-1];
//    }
//    
//    NSString *path = [bundle pathForResource:file ofType:type];
//    return [UIImage imageWithPath:path];
//}

+ (UIImage *)gxImageNamedFromUIFrame:(NSString *)name{
    return [UIImage gxImageNamedFromBundle:name bundleName:@"uiframe"];
}
+ (UIImage *)gxImageNamedFromUICommon:(NSString *)name{
    return [UIImage gxImageNamedFromBundle:name bundleName:@"common"];
}
+ (UIImage *)gxImageNamedFromBundle:(NSString *)fileName bundleName:(NSString *)bundleName {
    
    NSString *bundlePath = [bundleName stringByAppendingString:@".bundle"];
    bundlePath = [bundlePath stringByAppendingPathComponent:fileName];
    return [UIImage imageNamed:bundlePath];
}

+ (UIImage *)gxImageWithColor:(UIColor *)color andSize:(CGSize)size{
    if (!color)
        color = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *returnImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}




- (UIImage *) imageWithBorderColor:(UIColor *)borderColor width:(CGFloat) width{
    CGSize size = [self size];
    //UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGFloat red, green, blue, alpha;
    NSAssert([borderColor getRed:&red green:&green blue:&blue alpha:&alpha], nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, width);
    CGContextStrokeRect(context, rect);
    UIImage *returnImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)imageWithScaledToSize:(CGSize)newSize {
    if (CGSizeEqualToSize(self.size, newSize))
        return self;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

/*
 * @brief rotate image 90 with Clockwise
 */
- (UIImage*)rotate90Clockwise {
    UIImage *image = nil;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRight];
            break;
        case UIImageOrientationDown:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeft];
            break;
        case UIImageOrientationLeft:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationRight:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationUpMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored];
            break;
        case UIImageOrientationDownMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRightMirrored];
            break;
        case UIImageOrientationLeftMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDownMirrored];
            break;
        case UIImageOrientationRightMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
            break;
        default:
            break;
    }
    
    return image;
}

/*
 * @brief flip horizontal
 */
- (UIImage*)flipHorizontal {
    UIImage *image = nil;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
            break;
        case UIImageOrientationDown:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDownMirrored];
            break;
        case UIImageOrientationLeft:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRightMirrored];
            break;
        case UIImageOrientationRight:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored];
            break;
        case UIImageOrientationUpMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationDownMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationLeftMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationRight];
            break;
        case UIImageOrientationRightMirrored:
            image = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeft];
            break;
        default:
            break;
    }
    
    return image;
}
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



- (CGFloat)width{
    return self.size.width;
}
- (CGFloat)height{
    return self.size.height;
}
- (UIImage *)mirrorVertical{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contex, 0, self.height);
    CGContextScaleCTM(contex, 1.0, -1.0);
    [self drawInRect:CGRectMake(0, 0, self.width, self.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)mirrorHorizon{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contex, self.width, 0);
    CGContextScaleCTM(contex, -1.0, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.width, self.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

//static char info;
//- (void)setInfo:(NSString *)i{
//    [self willChangeValueForKey:@"info"];
//    objc_setAssociatedObject(self, &info,
//                             i,
//                             OBJC_ASSOCIATION_ASSIGN);
//    [self didChangeValueForKey:@"info"];
//}
//- (NSString *)info{
//    return objc_getAssociatedObject(self, &info);
//}

- (void)gxBlurredImageAsyncWithRadius:(CGFloat)radius saturationDeltaFactor:(CGFloat)factor tintColor:(UIColor *)tintColor onComplete:(void(^)(UIImage *img))complete{
    if (!complete)
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        CGSize size = CGSizeMake(self.width*self.scale, self.height*self.scale);
        UIImage *old = self;
        
        CGSize screensize = [UIScreen mainScreen].bounds.size;
        CGFloat facter = MAX(1.0 ,MIN(size.width*2.0/screensize.width, size.height*2.0/screensize.height));
        if (facter>1.1)
            old = [old gxCoverToSize:CGSizeMake(size.width/facter, size.height/facter)];
        
        UIImage *img = [old gxApplyBlurWithRadius:radius tintColor:tintColor saturationDeltaFactor:factor maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(img);
            }
        });
    });
    
}

#pragma mark -
#pragma mark - 马赛克处理

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    size_t bitmapByteCount;
    size_t bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow    = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}

static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

- (UIImage *)gxMosaicImagewithLevel:(int)level
{
    UIImage *image = self;
    unsigned char *imgPixel = RequestImagePixelData(image);
    CGImageRef inImageRef = [image CGImage];
    GLuint width = (GLuint)CGImageGetWidth(inImageRef);
    GLuint height = (GLuint)CGImageGetHeight(inImageRef);
    unsigned char prev[4] = {0};
    int bytewidth = width*4;
    int i,j;
    int val = level;
    for(i=0;i<height;i++) {
        if (((i+1)%val) == 0) {
            memcpy(imgPixel+bytewidth*i, imgPixel+bytewidth*(i-1), bytewidth);
            continue;
        }
        for(j=0;j<width;j++) {
            if (((j+1)%val) == 1) {
                memcpy(prev, imgPixel+bytewidth*i+j*4, 4);
                continue;
            }
            memcpy(imgPixel+bytewidth*i+j*4, prev, 4);
        }
    }
    NSInteger dataLength = width*height* 4;
    
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(width, height,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytewidth,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
    UIImage *mosaicImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return mosaicImage;
}

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

/*
 *转换成马赛克,level代表一个点转为多少level*level的正方形
 */
- (UIImage *)gxTransToMosaicImageblockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  kBitsPerComponent,        //每个颜色值8bit
                                                  width*kPixelChannelCount, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[kPixelChannelCount] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                }else{
                    memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width*height* kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    //创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              kBitsPerComponent,
                                              kBitsPerPixel,
                                              width*kPixelChannelCount ,
                                              colorSpace,
                                              (CGBitmapInfo)kCGImageAlphaPremultipliedLast,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        //        float scale = [[UIScreen mainScreen] scale];
        //        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:self.scale orientation:self.imageOrientation];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    //    return [[resultImage retain] autorelease];
    return resultImage;
    
}

+ (UIImage *)gxDecodedImageWithImage:(UIImage *)image {
    // while downloading huge amount of images
    // autorelease the bitmap context
    // and all vars to help system to free memory
    // when there are memory warning.
    // on iOS7, do not forget to call
    // [[SDImageCache sharedImageCache] clearMemory];
    
    if (image == nil) { // Prevent "CGBitmapContextCreateImage: invalid context 0x0" error
        return nil;
    }
    
    @autoreleasepool{
        // do not decode animated images
        if (image.images != nil) {
            return image;
        }
        
        CGImageRef imageRef = image.CGImage;
        
        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
        BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                         alpha == kCGImageAlphaLast ||
                         alpha == kCGImageAlphaPremultipliedFirst ||
                         alpha == kCGImageAlphaPremultipliedLast);
        if (anyAlpha) {
            return image;
        }
        
        // current
        CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
        CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
        
        BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                      imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                      imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                      imageColorSpaceModel == kCGColorSpaceModelIndexed);
        if (unsupportedColorSpace) {
            colorspaceRef = CGColorSpaceCreateDeviceRGB();
        }
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        
        
        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        
        // Draw the image into the context and retrieve the new bitmap image without alpha
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];
        
        if (unsupportedColorSpace) {
            CGColorSpaceRelease(colorspaceRef);
        }
        
        CGContextRelease(context);
        CGImageRelease(imageRefWithoutAlpha);
        
        return imageWithoutAlpha;
    }
}

@end
