//
//  UIImage-MJGScaling.h
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MJGScaling)

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage*)scaleImageToSize:(CGSize)newSize;
- (UIImage*)imageWithContentMode:(UIViewContentMode)contentMode inBounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;

@end
