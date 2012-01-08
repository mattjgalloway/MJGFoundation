//
//  MJGRPNCalculator.m
//  MJGFoundation
//
//  Created by Matt Galloway on 07/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGRPNCalculator.h"

#import "MJGStack.h"

NSString *const MJGRPNCalculatorUnknownOperatorException = @"MJGRPNCalculatorUnknownOperatorException";
NSString *const MJGRPNCalculatorInvalidInstructionException = @"MJGRPNCalculatorInvalidInstructionException";
NSString *const MJGRPNCalculatorInstuctionUnderrunException = @"MJGRPNCalculatorInstuctionUnderrunException";

@interface MJGRPNCalculator ()
@property (nonatomic, strong) MJGStack *instructions;

- (NSNumber*)_handleNextInstruction;
@end

@implementation MJGRPNCalculator

@synthesize instructions = _instructions;

#pragma mark -

- (id)init {
    if ((self = [self initWithInstructions:nil])) {
    }
    return self;
}

- (id)initWithInstructions:(NSArray *)instructions {
    if ((self = [super init])) {
        _instructions = [[MJGStack alloc] initWithArray:instructions];
    }
    return self;
}


#pragma mark - Custom accessors

- (NSNumber*)currentResult {
    if (_instructions.count > 0) {
        id result = [_instructions peekObject];
        if ([result isKindOfClass:[NSNumber class]]) {
            return (NSNumber*)result;
        } else {
            return nil;
        }
    }
    return nil;
}


#pragma mark -

- (void)addInstruction:(id)instruction {
    [_instructions pushObject:instruction];
}

- (void)addInstructions:(NSArray*)instructions {
    [_instructions pushObjects:instructions];
}

- (NSNumber*)performInstructions {
    NSNumber *result = [self _handleNextInstruction];
    [_instructions pushObject:result];
    return result;
}


#pragma mark -

- (NSNumber*)_handleNextInstruction {
    if (_instructions.count == 0) {
        @throw [NSException exceptionWithName:MJGRPNCalculatorInstuctionUnderrunException 
                                       reason:@"Ran out of instuctions." 
                                     userInfo:nil];
    }
    
    id nextInstruction = [_instructions popObject];
    if ([nextInstruction isKindOfClass:[NSString class]]) {
        NSString *operator = (NSString*)nextInstruction;
        
        NSNumber *operandA = [self _handleNextInstruction];
        NSNumber *operandB = [self _handleNextInstruction];
        
        if ([operator isEqualToString:@"+"]) {
            return [NSNumber numberWithDouble:([operandB doubleValue] + [operandA doubleValue])];
        } else if ([operator isEqualToString:@"-"]) {
            return [NSNumber numberWithDouble:([operandB doubleValue] - [operandA doubleValue])];
        } else if ([operator isEqualToString:@"*"]) {
            return [NSNumber numberWithDouble:([operandB doubleValue] * [operandA doubleValue])];
        } else if ([operator isEqualToString:@"/"]) {
            return [NSNumber numberWithDouble:([operandB doubleValue] / [operandA doubleValue])];
        } else {
            @throw [NSException exceptionWithName:MJGRPNCalculatorUnknownOperatorException 
                                           reason:[NSString stringWithFormat:@"\"%@\" is an unknown operator.", operator] 
                                         userInfo:nil];
        }
    } else if ([nextInstruction isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)nextInstruction;
    } else {
        @throw [NSException exceptionWithName:MJGRPNCalculatorInvalidInstructionException 
                                       reason:[NSString stringWithFormat:@"\"%@\" is an invalid instruction.", nextInstruction] 
                                                                userInfo:nil];
    }
    
    return nil;
}

@end
