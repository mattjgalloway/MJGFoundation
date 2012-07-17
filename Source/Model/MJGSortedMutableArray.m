//
//  MJGSortedMutableArray.m
//  MJGFoundation
//
//  Created by Matt Galloway on 17/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGSortedMutableArray.h"

@interface MJGSortedMutableArrayHelper : NSObject {
}
- (id)init;
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2;
@end

@interface MJGSortedMutableArrayHelperDescriptors : MJGSortedMutableArrayHelper {
    NSArray *_descriptors;
}
- (id)initWithDescriptors:(NSArray*)descriptors;
@end

@interface MJGSortedMutableArrayHelperComparator : MJGSortedMutableArrayHelper {
    NSComparator _comparator;
}
- (id)initWithComparator:(NSComparator)comparator;
@end

@interface MJGSortedMutableArrayHelperFunction : MJGSortedMutableArrayHelper {
    NSInteger (*_compare)(id, id, void *);
    void *_context;
}
- (id)initWithFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
@end

@interface MJGSortedMutableArrayHelperSelector : MJGSortedMutableArrayHelper {
    SEL _selector;
}
- (id)initWithSelector:(SEL)selector;
@end

@interface MJGSortedMutableArray ()
@property (nonatomic, strong) NSMutableArray *backingArray;
@property (nonatomic, strong) MJGSortedMutableArrayHelper *helper;
@end

@implementation MJGSortedMutableArray

@synthesize backingArray = _backingArray;
@synthesize helper = _helper;

#pragma mark -

- (id)init {
    if ((self = [super init])) {
        self.backingArray = [NSMutableArray new];
    }
    return self;
}

- (id)initWithDescriptors:(NSArray*)descriptors {
    if ((self = [self init])) {
        self.helper = [[MJGSortedMutableArrayHelperDescriptors alloc] initWithDescriptors:descriptors];
    }
    return self;
}

- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [self init])) {
        self.helper = [[MJGSortedMutableArrayHelperComparator alloc] initWithComparator:comparator];
    }
    return self;
}

- (id)initWithFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context {
    if ((self = [self init])) {
        self.helper = [[MJGSortedMutableArrayHelperFunction alloc] initWithFunction:compare context:context];
    }
    return self;
}

- (id)initWithSelector:(SEL)selector {
    if ((self = [self init])) {
        self.helper = [[MJGSortedMutableArrayHelperSelector alloc] initWithSelector:selector];
    }
    return self;
}


#pragma mark -

- (NSUInteger)addObject:(id)obj {
    __block NSUInteger addedIndex = NSNotFound;
    [_backingArray enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
        NSComparisonResult result = [_helper compareObject:obj toObject:obj2];
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

@end

@implementation MJGSortedMutableArrayHelper
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2 {
    return NSOrderedSame;
}
@end

@implementation MJGSortedMutableArrayHelperDescriptors
- (id)initWithDescriptors:(NSArray *)descriptors {
    if ((self = [super init])) {
        _descriptors = descriptors;
    }
    return self;
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2 {
    NSComparisonResult result = NSOrderedSame;
    for (NSSortDescriptor *descriptor in _descriptors) {
        result = [descriptor compareObject:object1 toObject:object2];
        if (result != NSOrderedSame) {
            return result;
        }
    }
    return result;
}
@end

@implementation MJGSortedMutableArrayHelperComparator
- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [super init])) {
        _comparator = [comparator copy];
    }
    return self;
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2 {
    return _comparator(object1, object2);
}
@end

@implementation MJGSortedMutableArrayHelperFunction
- (id)initWithFunction:(NSInteger (*)(__strong id, __strong id, void *))compare context:(void *)context {
    if ((self = [super init])) {
        _compare = compare;
        _context = context;
    }
    return self;
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2 {
    return _compare(object1, object2, _context);
}
@end

@implementation MJGSortedMutableArrayHelperSelector
- (id)initWithSelector:(SEL)selector {
    if ((self = [super init])) {
        _selector = selector;
    }
    return self;
}
- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2 {
    return [object1 performSelector:_selector withObject:object2];
}
@end
