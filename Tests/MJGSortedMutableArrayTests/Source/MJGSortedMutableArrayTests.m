//
//  MJGSortedMutableArrayTests.m
//  MJGSortedMutableArrayTests
//
//  Created by Matt Galloway on 17/07/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "MJGSortedMutableArrayTests.h"

@implementation MJGSortedMutableArrayTests

@synthesize array = _array;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDescriptors {
    NSArray *descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]];
    self.array = [[MJGSortedMutableArray alloc] initWithDescriptors:descriptors];
    STAssertEquals([_array addObject:[NSNumber numberWithInt:0]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:2]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:4]], (NSUInteger)2, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:1]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:3]], (NSUInteger)3, @"Inserted at incorrect location");
}

- (void)testDescriptors2 {
    NSArray *descriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:NO]];
    self.array = [[MJGSortedMutableArray alloc] initWithDescriptors:descriptors];
    STAssertEquals([_array addObject:[NSNumber numberWithInt:0]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:2]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:4]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:1]], (NSUInteger)2, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:3]], (NSUInteger)1, @"Inserted at incorrect location");
}

- (void)testComparator {
    self.array = [[MJGSortedMutableArray alloc] initWithComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj1 compare:obj2];
    }];
    STAssertEquals([_array addObject:[NSNumber numberWithInt:0]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:2]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:4]], (NSUInteger)2, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:1]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:3]], (NSUInteger)3, @"Inserted at incorrect location");
}

NSComparisonResult compareNumbers(NSNumber *obj1, NSNumber *obj2, void *context);
NSComparisonResult compareNumbers(NSNumber *obj1, NSNumber *obj2, void *context) {
    return [obj1 compare:obj2];
}

- (void)testFunction {
    self.array = [[MJGSortedMutableArray alloc] initWithFunction:compareNumbers context:NULL];
    STAssertEquals([_array addObject:[NSNumber numberWithInt:0]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:2]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:4]], (NSUInteger)2, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:1]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:3]], (NSUInteger)3, @"Inserted at incorrect location");
}

- (void)testSelector {
    self.array = [[MJGSortedMutableArray alloc] initWithSelector:@selector(compare:)];
    STAssertEquals([_array addObject:[NSNumber numberWithInt:0]], (NSUInteger)0, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:2]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:4]], (NSUInteger)2, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:1]], (NSUInteger)1, @"Inserted at incorrect location");
    STAssertEquals([_array addObject:[NSNumber numberWithInt:3]], (NSUInteger)3, @"Inserted at incorrect location");
}

@end
