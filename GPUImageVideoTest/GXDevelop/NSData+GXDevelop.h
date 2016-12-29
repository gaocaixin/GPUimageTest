//
//  NSData+GXDevelop.h
//  LOCO
//
//  Created by 高才新 on 16/3/21.
//  Copyright © 2016年 IU-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GXDevelop)

/**
 *AES 解密
 */
- (nullable NSData *)gxAES256DecryptWithKey:(nullable NSString *)key;
/**
 *AES 加密 
 */
- (nullable NSData *)gxAES256EncryptWithKey:(nullable NSString *)key;

//- (nullable id)jsonObject;
//- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level;
//- (nullable NSData *)gzippedData;
//- (nullable NSData *)gunzippedData;
//- (BOOL)isGzippedData;

- (nullable id)gxJsonObject;
- (nullable NSData *)gxGzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)gxGzippedData;
- (nullable NSData *)gxGunzippedData;
- (BOOL)gxIsGzippedData;

@end
