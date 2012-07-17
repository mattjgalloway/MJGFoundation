//
//  MJGSortedMutableArray.h
//  MJGFoundation
//
//  Created by Matt Galloway on 17/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

/**
 * This class is designed to be an array that keeps itself sorted as you add objects to it. 
 * When you add an object, you get the index where it was added returned.
 */

#import <Foundation/Foundation.h>

@interface MJGSortedMutableArray : NSObject

- (id)initWithDescriptors:(NSArray*)descriptors;
- (id)initWithComparator:(NSComparator)comparator;
- (id)initWithFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
- (id)initWithSelector:(SEL)selector;

- (NSUInteger)addObject:(id)obj;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (id)objectAtIndex:(NSUInteger)index;
- (NSArray*)allObjects;

@end
