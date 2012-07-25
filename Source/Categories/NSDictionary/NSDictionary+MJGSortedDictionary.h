//
//  NSDictionary+MJGSortedDictionary.h
//  MJGFoundation
//
//  Created by Matt Galloway on 25/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MJGSortedDictionary)

- (NSArray*)sortedKeysUsingComparator:(NSComparator)comparator;
- (NSArray*)sortedValuesUsingKeyComparator:(NSComparator)comparator;
- (void)enumerateSortedKeysAndObjectsUsingComparator:(NSComparator)comparator usingBlock:(void (^)(id key, id value, BOOL *stop))block;

@end
