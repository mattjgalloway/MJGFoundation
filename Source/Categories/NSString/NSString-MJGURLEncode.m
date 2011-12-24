//
//  NSString-MJGURLEncode.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "NSString-MJGURLEncode.h"

@implementation NSString (MJGURLEncode)

- (NSString*)urlEncodedString {
    NSString *encoded = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (__bridge CFStringRef)self,
                                                                                             NULL,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                             kCFStringEncodingUTF8);
    return encoded;
}

- (NSDictionary*)dictionaryFromQueryString {
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [(NSString*)[kv objectAtIndex:0] urlEncodedString];
            NSString *value = [(NSString*)[kv objectAtIndex:1] urlEncodedString];
            [mutableDict setValue:value forKey:key];
        }
    }
    
    return [[NSDictionary alloc] initWithDictionary:mutableDict];
}

@end
