//
//  NSNumber-MJGRandom.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "NSNumber-MJGRandom.h"

#include <stdlib.h>

@implementation NSNumber (MJGRandom)

+ (NSNumber*)randomUnsignedInt {
    return [NSNumber numberWithUnsignedInt:arc4random()];
}

@end
