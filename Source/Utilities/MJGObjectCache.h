//
//  MJGObjectCache.h
//  MJGFoundation
//
//  Created by Matt Galloway on 03/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJGObjectCacheEntry;

@interface MJGObjectCache : NSObject

+ (id)sharedInstance;

- (id)initWithCacheFilename:(NSString*)cacheFilename;

- (void)setObject:(id)object forKey:(NSString*)key withExpiryDate:(NSDate*)expiry;
- (id)objectForKey:(NSString*)key;
- (void)clearCacheForKey:(NSString*)key;

@end
