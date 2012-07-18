//
//  MJGSortedMutableArray.m
//  MJGFoundation
//
//  Created by Matt Galloway on 17/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGSortedMutableArray.h"

@interface MJGSortedMutableArray ()
@property (nonatomic, strong) NSMutableArray *backingArray;
@property (nonatomic, strong) NSComparator comparator;
@end

@implementation MJGSortedMutableArray

@synthesize backingArray = _backingArray;
@synthesize comparator = _comparator;

#pragma mark -

- (id)init {
    if ((self = [super init])) {
        self.backingArray = [NSMutableArray new];
    }
    return self;
}

- (id)initWithDescriptors:(NSArray*)descriptors {
    if ((self = [self init])) {
        self.comparator = ^NSComparisonResult(id obj1, id obj2) {
            for (NSSortDescriptor *descriptor in descriptors) {
                NSComparisonResult result = [descriptor compareObject:obj1 toObject:obj2];
                if (result != NSOrderedSame) {
                    return result;
                }
            }
            return NSOrderedSame;
        };
    }
    return self;
}

- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [self init])) {
        self.comparator = comparator;
    }
    return self;
}

- (id)initWithFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context {
    if ((self = [self init])) {
        self.comparator = ^NSComparisonResult(id obj1, id obj2) {
            return compare(obj1, obj2, context);
        };
    }
    return self;
}

- (id)initWithSelector:(SEL)selector {
    if ((self = [self init])) {
        self.comparator = ^NSComparisonResult(id obj1, id obj2) {
            return [obj1 performSelector:selector withObject:obj2];
        };
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", NSStringFromClass([self class]), self, _backingArray];
}


#pragma mark -

- (NSUInteger)addObject:(id)obj {
    __block NSUInteger addedIndex = NSNotFound;
    [_backingArray enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = _comparator(obj, obj2);
        if (result != NSOrderedDescending) {
            addedIndex = idx;
            [_backingArray insertObject:obj atIndex:addedIndex];
            *stop = YES;
        }
    }];
    
    if (addedIndex == NSNotFound) {
        [_backingArray addObject:obj];
        addedIndex = (_backingArray.count - 1);
    }
    return addedIndex;
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_backingArray removeObjectAtIndex:index];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_backingArray objectAtIndex:index];
}

- (NSArray*)allObjects {
    return [_backingArray copy];
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_backingArray countByEnumeratingWithState:state objects:buffer count:len];
}

@end
