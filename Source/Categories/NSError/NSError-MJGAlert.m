//
//  NSError-MJGAlert.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "NSError-MJGAlert.h"

@implementation NSError (MJGAlert)

- (UIAlertView*)alertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self localizedFailureReason]
                                                    message:[self localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
    return alert;
}

@end
