//
//  MJGObjectCacheTests.m
//  MJGObjectCacheTests
//
//  Created by Matt Galloway on 05/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGObjectCacheTests.h"

#import "MJGObjectCache.h"

@implementation MJGObjectCacheTests

@synthesize objectCache = _objectCache;

- (void)setUp {
    [super setUp];
    _objectCache = [[MJGObjectCache alloc] initWithCacheFilename:@"cachetest.dat"];
}

- (void)tearDown {
    [super tearDown];
    _objectCache = nil;
}

- (void)testAddString {
    NSString *someString = @"A string";
    [_objectCache setObject:someString forKey:@"test" withExpiryDate:[NSDate distantFuture]];
    
    id cachedObject = [_objectCache objectForKey:@"test"];
    STAssertEquals(cachedObject, someString, @"Cached object was not equal to original object");
}

- (void)testAddNumber {
    NSNumber *someNumber = [NSNumber numberWithInt:1];
    [_objectCache setObject:someNumber forKey:@"test" withExpiryDate:[NSDate distantFuture]];
    
    id cachedObject = [_objectCache objectForKey:@"test"];
    STAssertEquals(cachedObject, someNumber, @"Cached object was not equal to original object");
}

- (void)testExpiredObject {
    NSString *someString = @"A string";
    [_objectCache setObject:someString forKey:@"test" withExpiryDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    sleep(2);
    
    id cachedObject = [_objectCache objectForKey:@"test"];
    STAssertNil(cachedObject, @"Cached object should have been nil");
}

@end
