//
//  MJG2DPinchGestureRecognizer.h
//  MJGFoundation
//
//  Created by Matt Galloway on 01/02/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJG2DPinchGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign, readonly) CGFloat horizontalScale;
@property (nonatomic, assign, readonly) CGFloat verticalScale;
@property (nonatomic, assign, readonly) CGFloat scale;

@end
