//
//  MJGRPNCalculator.h
//  MJGFoundation
//
//  Created by Matt Galloway on 07/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MJGRPNCalculatorUnknownOperatorException;
extern NSString *const MJGRPNCalculatorInvalidInstructionException;
extern NSString *const MJGRPNCalculatorInstuctionUnderrunException;

@interface MJGRPNCalculator : NSObject

@property (nonatomic, strong, readonly) NSNumber *currentResult;

- (id)init;
- (id)initWithInstructions:(NSArray*)instructions;

- (void)addInstruction:(id)instruction;
- (void)addInstructions:(NSArray*)instructions;
- (NSNumber*)performInstructions;

@end
