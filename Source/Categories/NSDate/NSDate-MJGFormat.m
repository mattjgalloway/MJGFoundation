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
