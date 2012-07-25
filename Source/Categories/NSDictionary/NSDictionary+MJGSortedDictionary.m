//
//  NSDictionary+MJGSortedDictionary.m
//  MJGFoundation
//
//  Created by Matt Galloway on 25/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "NSDictionary+MJGSortedDictionary.h"

@implementation NSDictionary (MJGSortedDictionary)

- (NSArray*)sortedKeysUsingComparator:(NSComparator)comparator {
    return [self.allKeys sortedArrayUsingComparator:comparator];
}

- (NSArray*)sortedValuesUsingKeyComparator:(NSComparator)comparator {
    NSMutableArray *returnValues = [NSMutableArray new];
    [self enumerateSortedKeysAndObjectsUsingComparator:comparator usingBlock:^(id key, id value, BOOL *stop) {
        [returnValues addObject:value];
    }];
    return [returnValues copy];
}

- (void)enumerateSortedKeysAndObjectsUsingComparator:(NSComparator)comparator usingBlock:(void (^)(id key, id value, BOOL *stop))block {
    NSArray *sortedKeys = [self sortedKeysUsingComparator:comparator];
    [sortedKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        id value = [self objectForKey:key];
        block(key, value, stop);
    }];
}

@end
