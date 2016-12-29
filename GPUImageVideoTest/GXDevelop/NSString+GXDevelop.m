//
//  NSString+GXString.m
//  LOCO
//
//  Created by 高才新 on 15/12/16.
//  Copyright © 2015年 IU-Apps. All rights reserved.
//

#import "NSString+GXDevelop.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+GXDevelop.h"

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation NSString (GXDevelop)

- (BOOL)gxValidateWithRegexStr:(NSString *)regexStr {
    NSString *emailRegex = regexStr;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
    
}
- (CGSize )gxSizeWithLimitSize:(CGSize )limitSize  font:(UIFont *)font {
    CGSize size;
    if([[UIDevice currentDevice].systemVersion doubleValue] >=7.0)
    {
        NSDictionary * attributes = @{NSFontAttributeName:font};
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:self attributes:attributes];
        return [attributedText gxSizeWithLimitSize:limitSize];
    }
    else
    {
        CGRect rect = [self boundingRectWithSize: limitSize
                                         options: (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes: @{NSFontAttributeName:font}
                                         context: nil];
        size = rect.size;
    }
    return size;
}
- (NSString *)gxMd5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)gxLocalizedString:(NSString *)key {
    NSString* s = [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"Localizable2"];
    if ([s isEqualToString:key])
        s = [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil];
    // We look recursively for ${...}
    //ASSERT(s);
    
    while (s && [s rangeOfString:@"${"].location != NSNotFound) {
        NSRange r1, t, s2r;
        r1 = [s rangeOfString:@"${"];
        NSUInteger i1 = r1.location;
        t.location = r1.location;
        t.length = [s length] - r1.location;
        NSUInteger i2 = [s rangeOfString:@"}" options:NSLiteralSearch range:t].location;
        // We now replace the string between i1 and i2
        // Make s2r range from ${ to },
        s2r.location = i1+2;
        s2r.length = i2 - i1 - 2;
        // s2 is the localized with replacement
        NSString *subkey = [s substringWithRange:s2r];
        NSString *s2 = [[NSBundle mainBundle] localizedStringForKey:(subkey) value:@"" table:@"Localizable2"];
        if ([s2 isEqualToString:subkey])
            s2 = [[NSBundle mainBundle] localizedStringForKey:(subkey) value:@"" table:nil];
        // Make s2r range from ${ to }
        s2r.location = i1;
        s2r.length = i2 - i1 + 1;
        s = [s stringByReplacingCharactersInRange:s2r withString:s2];
    }
    return s;
}

/**
 * 添加文字间距
 */
- (NSMutableAttributedString *) gxAttributeStringWithFont:(UIFont *)font color:(UIColor *)fontColor spacing:(long)spacing
{
    NSMutableAttributedString *strAttri = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (self.length > 0) {
        
        [strAttri addAttribute:NSFontAttributeName
                         value:font
                         range:NSMakeRange(0, [strAttri length])];
        
        [strAttri addAttribute:NSForegroundColorAttributeName
                         value:fontColor
                         range:NSMakeRange(0, [strAttri length])];
        
        union{
            long l_number;
            int8_t i8_number;
        } number;
        
        number.l_number = spacing;
        
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number.i8_number);
        [strAttri addAttribute:(id)kCTKernAttributeName
                         value:(__bridge id)num
                         range:NSMakeRange(0, [strAttri length]-1)];
        CFRelease(num);
        
    }
    return strAttri;
}
/**
 * 添加文字间距 行间距
 */
- (NSMutableAttributedString *)gxAttributeStringWithFont:(UIFont *)font  color:(UIColor *)fontColor spacing:(long)spacing lineSpacing:(CGFloat)linespacing alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString *attr = [self gxAttributeStringWithFont:font color:fontColor spacing:spacing];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = linespacing;
    paragraphStyle.alignment = alignment;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attr length])];
    return attr;
}

- (UIColor *) gxHexStringTransformUIColorWithAlpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

// ios 获得mac地址


/**
 *Return the local MAC addy 01
 */
+ (NSString *)gxGetLocalMacAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    NSLog(@"Mac Address: %@", outstring);
    free(buf);
    return [outstring uppercaseString];
}

/**
 *Return the local MAC addy 02
 */
+ (NSString *)gxGetLocalMacAddressOther
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
//    NSLog(@"Mac Address: %@", macAddressString);
    // Release the buffer memory
    free(msgBuffer);
    return macAddressString;
}

- (void)gxGetSuggestionsStringsWithCompletion:(void(^)(NSArray *))completion
{
    NSString *prefix = [self substringToIndex:self.length - 1];
    // Won't get suggestions for correct words, so we are scrambling the words
    NSString *scrambledWord = [NSString stringWithFormat:@"%@%@",self, [self getRandomCharAsNSString]];
    UITextChecker *checker = [[UITextChecker alloc] init];
    NSRange checkRange = NSMakeRange(0, scrambledWord.length);
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:scrambledWord range:checkRange startingAt:checkRange.location wrap:YES  language:@"en_US"];
    
    NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:scrambledWord language:@"en_US"];
    // NSLog(@"Arr ===== %@",arrGuessed);
    // Filter the result based on the word
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",self];
    NSArray *arrayfiltered = [arrGuessed filteredArrayUsingPredicate:predicate];
    if(arrayfiltered.count == 0)
    {
        // Filter the result based on the prefix
        NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",prefix];
        arrayfiltered = [arrGuessed filteredArrayUsingPredicate:newPredicate];
    }
    completion(arrayfiltered);
}

- (NSString *)getRandomCharAsNSString {
    return [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
}


/**
 *  添加文字间距 行间距
 *
 *  @返回 attributedString 和 size
 */
- (NSDictionary *)gxAttributeStringWithLimitSize:(CGSize)limitSize font:(UIFont *)font color:(UIColor *)fontColor spacing:(long)spacing lineSpacing:(CGFloat)linespacing alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString *attr = [self gxAttributeStringWithFont:font color:fontColor spacing:spacing];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = linespacing;
    paragraphStyle.alignment = alignment;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attr length])];
    
    CGSize size = [attr gxSizeWithLimitSize:limitSize];
    
    return @{@"attr":attr,@"size":NSStringFromCGSize(size)};
}


//- (CGSize)gxPrefersizeWith:(CGSize)size{
//    CGFloat width = size.width;
//    CGFloat height = size.height;
//    if (width == 0)
//        width = CGFLOAT_MAX;
//    
//    if (height == 0)
//        height = CGFLOAT_MAX;
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
//    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, height), NULL);
//    CFRelease(framesetter);
//    return textSize;
//}
+ (NSString *)gxRandString{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}



@end
