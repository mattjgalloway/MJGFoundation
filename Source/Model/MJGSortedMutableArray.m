//
//  MJGSortedMutableArray.m
//  MJGFoundation
//
//  Created by Matt Galloway on 17/07/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

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
        NSMethodSignature *methodSignature = [NSNumber instanceMethodSignatureForSelector:@selector(compare:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:selector];
        self.comparator = ^NSComparisonResult(id obj1, id obj2) {
            [invocation setTarget:obj1];
            [invocation setArgument:&obj2 atIndex:2];
            [invocation invoke];
            
            NSComparisonResult returnValue;
            [invocation getReturnValue:&returnValue];
            
            return returnValue;
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

- (NSIndexSet*)addObjectsFromArray:(NSArray *)otherArray {
    NSUInteger *indices = malloc(sizeof(NSUInteger) * otherArray.count);
    [self addObjects:otherArray addedIndices:indices];
    
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    for (NSUInteger i = 0; i < otherArray.count; i++) {
        [result addIndex:indices[i]];
    }
    
    if (indices) {
        free(indices);
    }
    
    return result;
}

- (void)addObjects:(NSArray*)objects addedIndices:(NSUInteger*)indices {
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger index = [self addObject:obj];
        if (indices) {
            indices[idx] = index;
            for (NSUInteger i = 0; i < idx; i++) {
                if (indices[i] >= index) {
                    indices[i] = indices[i] + 1;
                }
            }
        }
    }];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_backingArray removeObjectAtIndex:index];
}

- (void)removeObjectsInRange:(NSRange)range {
    [_backingArray removeObjectsInRange:range];
}

- (void)removeAllObjects {
    [_backingArray removeAllObjects];
}

- (void)removeLastObject {
    [_backingArray removeLastObject];
}

#pragma mark - NSArray Primitives

- (id)objectAtIndex:(NSUInteger)index {
    return [_backingArray objectAtIndex:index];
}

- (NSUInteger)count {
    return _backingArray.count;
}


#pragma mark - Block methods

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_backingArray enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2) {
        block(obj2, idx2, stop2);
    }];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_backingArray enumerateObjectsWithOptions:opts
                                    usingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2) {
                                        block(obj2, idx2, stop2);
                                    }];
}

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [_backingArray enumerateObjectsAtIndexes:s
                                     options:opts
                                  usingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2) {
                                      block(obj2, idx2, stop2);
                                  }];
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_backingArray countByEnumeratingWithState:state objects:buffer count:len];
}

@end
