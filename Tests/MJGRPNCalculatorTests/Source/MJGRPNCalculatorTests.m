//
//  MJGRPNCalculatorTests.m
//  MJGRPNCalculatorTests
//
//  Created by Matt Galloway on 07/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGRPNCalculatorTests.h"

@implementation MJGRPNCalculatorTests

@synthesize calculator = _calculator;

- (void)setUp {
    [super setUp];
    _calculator = [[MJGRPNCalculator alloc] init];
}

- (void)tearDown {
    [super tearDown];
    _calculator = nil;
}

- (void)testAdd {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"+"];
    NSNumber *result = [_calculator performInstructions];
    STAssertEquals([result intValue], 15, @"Result incorrect!");
}

- (void)testSubtract {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"-"];
    NSNumber *result = [_calculator performInstructions];
    STAssertEquals([result intValue], -5, @"Result incorrect!");
}

- (void)testMultiply {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"*"];
    NSNumber *result = [_calculator performInstructions];
    STAssertEquals([result intValue], 50, @"Result incorrect!");
}

- (void)testDivide {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"/"];
    NSNumber *result = [_calculator performInstructions];
    STAssertEquals([result doubleValue], 0.5, @"Result incorrect!");
}

- (void)testUnknownOperator {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"?"];
    STAssertThrowsSpecificNamed([_calculator performInstructions], 
                                NSException, MJGRPNCalculatorUnknownOperatorException, @"Should have thrown!");
}

- (void)testInvalidInstruction {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:[NSArray array]];
    STAssertThrowsSpecificNamed([_calculator performInstructions], 
                                NSException, MJGRPNCalculatorInvalidInstructionException, @"Should have thrown!");
}

- (void)testMalformedStack {
    [_calculator addInstruction:[NSNumber numberWithInt:5]];
    [_calculator addInstruction:[NSNumber numberWithInt:10]];
    [_calculator addInstruction:@"-"];
    [_calculator addInstruction:@"+"];
    STAssertThrowsSpecificNamed([_calculator performInstructions], 
                                NSException, MJGRPNCalculatorInstuctionUnderrunException, @"Should have thrown!");
}

@end
