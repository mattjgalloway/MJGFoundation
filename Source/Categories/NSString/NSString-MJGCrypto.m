//
//  NSString-MJGCrypto.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "NSString-MJGCrypto.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MJGCrypto)

- (NSString*)md5 {
    NSData *stringBytes = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    if (CC_MD5([stringBytes bytes], [stringBytes length], result)) {
        NSMutableString *returnString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
        for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
            [returnString appendFormat:@"%02x", result[i]];
        }
        return [NSString stringWithString:returnString];
    } else {
        return nil;
    }
}

- (NSString*)sha1 {
    NSData *stringBytes = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], result)) {
        NSMutableString *returnString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            [returnString appendFormat:@"%02x", result[i]];
        }
        return [NSString stringWithString:returnString];
    } else {
        return nil;
    }
}

@end

