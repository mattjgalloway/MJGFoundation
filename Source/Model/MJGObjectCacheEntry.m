//
//  MJGCacheEntry.m
//  MJGFoundation
//
//  Created by Matt Galloway on 03/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGObjectCacheEntry.h"

@interface MJGObjectCacheEntry ()
@end

@implementation MJGObjectCacheEntry

@synthesize object = _object;
@synthesize key = _key;
@synthesize expiryDate = _expiryDate;

#pragma mark -

- (BOOL)hasExpired {
    return ([self.expiryDate timeIntervalSinceNow] <= 0.0);
}


#pragma mark -

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}


#pragma mark -

- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super init])) {
        self.object = [coder decodeObjectForKey:@"object"];
        self.key = [coder decodeObjectForKey:@"key"];
        self.expiryDate = [coder decodeObjectForKey:@"expiryDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:self.object forKey:@"object"];
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.expiryDate forKey:@"expiryDate"];
}

@end
