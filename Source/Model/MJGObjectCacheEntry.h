//
//  MJGCacheEntry.h
//  MJGFoundation
//
//  Created by Matt Galloway on 03/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJGObjectCacheEntry : NSObject <NSCoding>

@property (nonatomic, strong) id object;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *expiryDate;

- (BOOL)hasExpired;

@end
