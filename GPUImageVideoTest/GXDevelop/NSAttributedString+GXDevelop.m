//
//  NSAttributedString+GXDevelop.m
//  LOCO
//
//  Created by 高才新 on 16/1/19.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import "NSAttributedString+GXDevelop.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (GXDevelop)
- (CGSize )gxSizeWithLimitSize:(CGSize )limitSize
{
    CGSize size = limitSize;
    if (CGSizeEqualToSize(CGSizeZero, limitSize)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    CGRect rect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}

- (CGSize)gxBoundingRectWithSize:(CGSize)size
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [self boundingRectWithSize:size options:options context:nil];
    if (self.length == 0) {
        return rect.size;
    }

    NSRange range = NSMakeRange(0, self.length);
    NSDictionary * attris = [self attributesAtIndex:0 effectiveRange:&range];
    UIFont *font = attris[NSFontAttributeName];
    NSParagraphStyle * paragraphStyle = attris[NSParagraphStyleAttributeName];
    
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self gxContainChinese]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}
- (BOOL)gxContainChinese{
    for(int i=0; i< [self length];i++){ int a = [[self string] characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (CGSize)gxPrefersizeWith:(CGSize)size{
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (width == 0)
        width = CGFLOAT_MAX;
    
    if (height == 0)
        height = CGFLOAT_MAX;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, height), NULL);
    CFRelease(framesetter);
    return textSize;
}

- (CGSize)gxPrefersizeWith:(CGSize)size withLastLine:(CGRect *)rect{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 , size.width , size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //得到frame中的行数组
    CFArrayRef rows = CTFrameGetLines(frame);
    int rowcount = (int)CFArrayGetCount(rows);
    if (rowcount == 0){
        CFRelease(framesetter);
        CFRelease(Path);
        CFRelease(frame);
        if (rect)
            *rect = CGRectZero;
        return CGSizeZero;
    }
    
    NSParagraphStyle *stype = [self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    UIFont *font = [self attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    
    CTLineRef line = CFArrayGetValueAtIndex(rows, rowcount-1);
    float flush;
    switch (stype.alignment) {
        case NSTextAlignmentCenter: flush = 0.5;    break; //1
        case NSTextAlignmentRight:  flush = 1;      break; //2
        case NSTextAlignmentLeft:  //0
        default:                    flush = 0;      break;
    }
    // x
    CGFloat penOffsetx = CTLineGetPenOffsetForFlush(line, flush, size.width);
    // y
    CGFloat penOffsety = (stype.lineSpacing + font.lineHeight)*(rowcount-1);
    // w
    CGRect bounds = CTLineGetBoundsWithOptions(line, 0);
    CGFloat w = bounds.size.width;
    CGFloat h = (font?font.lineHeight:bounds.size.height);
    
    CFRelease(framesetter);
    CFRelease(Path);
    CFRelease(frame);
    
    if ([self.string hasSuffix:@"\n"]) {
        penOffsetx = size.width*flush;
        penOffsety += h+stype.lineSpacing;
        w = 0;
    }
    
    if (rect) {
        rect->origin.x = penOffsetx;
        rect->origin.y = penOffsety;
        rect->size.width = w;
        rect->size.height = h;
    }
    return CGSizeMake(size.width, penOffsety+h);
    
}

@end
