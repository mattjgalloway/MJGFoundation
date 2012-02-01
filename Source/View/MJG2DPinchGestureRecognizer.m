//
//  MJG2DPinchGestureRecognizer.m
//  MJGFoundation
//
//  Created by Matt Galloway on 01/02/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import "MJG2DPinchGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

// XXX: Not particularly finished - needs some work to make it suck a bit less.

@interface MJG2DPinchGestureRecognizer ()
@property (nonatomic, unsafe_unretained) UITouch *touch1;
@property (nonatomic, assign) CGPoint initialTouch1Point;
@property (nonatomic, assign) CGPoint currentTouch1Point;
@property (nonatomic, unsafe_unretained) UITouch *touch2;
@property (nonatomic, assign) CGPoint initialTouch2Point;
@property (nonatomic, assign) CGPoint currentTouch2Point;
@end

@implementation MJG2DPinchGestureRecognizer

@synthesize touch1 = _touch1;
@synthesize initialTouch1Point = _initialTouch1Point;
@synthesize currentTouch1Point = _currentTouch1Point;
@synthesize touch2 = _touch2;
@synthesize initialTouch2Point = _initialTouch2Point;
@synthesize currentTouch2Point = _currentTouch2Point;

#pragma mark - Custom accessors

- (CGFloat)horizontalScale {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        CGFloat initialDistance = fabs(_initialTouch1Point.x - _initialTouch2Point.x);
        CGFloat currentDistance = fabs(_currentTouch1Point.x - _currentTouch2Point.x);
        return (currentDistance / initialDistance);
    }
    return 1.0f;
}

- (CGFloat)verticalScale {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        CGFloat initialDistance = fabs(_initialTouch1Point.y - _initialTouch2Point.y);
        CGFloat currentDistance = fabs(_currentTouch1Point.y - _currentTouch2Point.y);
        return (currentDistance / initialDistance);
    }
    return 1.0f;
}

- (CGFloat)scale {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        CGFloat initialDiffX = fabs(_initialTouch1Point.x - _initialTouch2Point.x);
        CGFloat initialDiffY = fabs(_initialTouch1Point.y - _initialTouch2Point.y);
        CGFloat initialDistance = sqrtf((initialDiffX * initialDiffX) + (initialDiffY * initialDiffY));
        
        CGFloat currentDiffX = fabs(_currentTouch1Point.x - _currentTouch2Point.x);
        CGFloat currentDiffY = fabs(_currentTouch1Point.y - _currentTouch2Point.y);
        CGFloat currentDistance = sqrtf((currentDiffX * currentDiffX) + (currentDiffY * currentDiffY));
        
        return (currentDistance / initialDistance);
    }
    return 1.0f;
}


#pragma mark - UIGestureRecognizer methods

- (void)reset {
    [super reset];
    _touch1 = nil;
    _initialTouch1Point = CGPointZero;
    _currentTouch1Point = CGPointZero;
    _touch2 = nil;
    _initialTouch2Point = CGPointZero;
    _currentTouch2Point = CGPointZero;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count != 2) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    for (UITouch *touch in touches) {
        if (touch.tapCount > 1) {
            self.state = UIGestureRecognizerStateFailed;
            return;
        }
    }
    
    NSArray *arrayTouches = [touches allObjects];
    _touch1 = [arrayTouches objectAtIndex:0];
    _initialTouch1Point = _currentTouch1Point = [_touch1 locationInView:self.view];
    _touch2 = [arrayTouches objectAtIndex:1];
    _initialTouch2Point = _currentTouch2Point = [_touch2 locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    for (UITouch *touch in touches) {
        if (touch == _touch1) {
            _currentTouch1Point = [_touch1 locationInView:self.view];
        } else if (touch == _touch2) {
            _currentTouch2Point = [_touch2 locationInView:self.view];
        }
    }
    self.state = UIGestureRecognizerStateChanged;
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _touch1 = nil;
    _initialTouch1Point = CGPointZero;
    _currentTouch1Point = CGPointZero;
    _touch2 = nil;
    _initialTouch2Point = CGPointZero;
    _currentTouch2Point = CGPointZero;
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _touch1 = nil;
    _initialTouch1Point = CGPointZero;
    _currentTouch1Point = CGPointZero;
    _touch2 = nil;
    _initialTouch2Point = CGPointZero;
    _currentTouch2Point = CGPointZero;
    self.state = UIGestureRecognizerStateFailed;
}

@end
