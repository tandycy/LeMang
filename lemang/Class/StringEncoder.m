//
//  StringEncoder.m
//  LeMang
//
//  Created by LZ on 9/2/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "StringEncoder.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Encryption)

+ (NSData*)AES256Encode:(NSString *)inputString
{
    NSData* inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* outputData = [inputData AES256EncryptWithKey:@"waaagh"];
 
    //NSString *result = [[NSString alloc] initWithData:outputData  encoding:NSUTF8StringEncoding];
    
    return outputData;
}

+ (NSString*)AES256Decode:(NSData *)inputData
{
    //NSData* inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSData* outputData = [inputData AES256DecryptWithKey:@"waaagh"];
    
    NSString *result = [[NSString alloc] initWithData:outputData  encoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSData *)AES256EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
