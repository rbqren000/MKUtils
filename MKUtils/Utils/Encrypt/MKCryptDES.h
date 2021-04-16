//
//  MKCryptDES.h
//  Basic
//
//  Created by zhengMK on 2020/4/15.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 类名重定义（静态类名：MKCryptDataEncode），降低反编译代码的可读性 */
#ifndef MKCryptDES
#define MKCryptDES MKCryptDataEncode
#endif

#define MKCryptDecode(content) [MKCryptDES decryptWithContent:content]

#define kAppSaltKey ({ \
   uint8_t bytpes[] = {0x05, 0x44, 0x71, 0x51, 0x4a, 0x54, 0x77, 0x12, 0x56, 0x46, 0x52, 0x70, 0x75, 0x4f, 0x35, 0x35, 0x05, 0x44, 0x71, 0x51, 0x4a, 0x54, 0x77, 0x12, 0x56, 0x46, 0x52, 0x70, 0x75, 0x4f, 0x35, 0x35}; \
   NSString* keyStr = [[NSString alloc] initWithData:[NSData dataWithBytes:bytpes length:76] encoding:NSASCIIStringEncoding]; \
   MKCryptDecode(keyStr); \
}) \

@interface MKCryptDES : NSObject

+ (NSString *)encryptWithContent:(NSString *)content;
+ (NSString *)decryptWithContent:(NSString *)content;

+ (NSString *)encryptWithContent:(NSString *)content WithKey:(NSString *)key;
+ (NSString *)decryptWithContent:(NSString *)content WithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
