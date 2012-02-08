//
//  NSDate-MJGFormat.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "NSDate-MJGFormat.h"

#import <time.h>
#import <xlocale.h>

@implementation NSDate (MJGFormat)

+ (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format {
    if (!format || !string) {
        return nil;
    }
    
    const char *str = [string UTF8String];
    const char *fmt = [format UTF8String];
    struct tm timeinfo;
    memset(&timeinfo, 0, sizeof(timeinfo));
    char *ret = strptime_l(str, fmt, &timeinfo, NULL);
    
    if (!ret) {
        return nil;
    }
    
    time_t time = mktime(&timeinfo);
    
    NSDate *retDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return retDate;
}

- (NSString*)dateStringWithFormat:(NSString*)format {
    if (!format) {
        return nil;
    }
    
	time_t time = [self timeIntervalSince1970];
    struct tm timeinfo;
    localtime_r(&time, &timeinfo);
    
	char buffer[80];
	const char *fmt = [format UTF8String];
	strftime_l(buffer, 80, fmt, &timeinfo, NULL);
    
    NSString *retString = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
	return retString;
}

@end
