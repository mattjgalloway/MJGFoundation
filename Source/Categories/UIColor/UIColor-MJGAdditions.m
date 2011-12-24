//
//  UIColor-MJGAdditions.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "UIColor-MJGAdditions.h"

@implementation UIColor (MJGAdditions)

- (UIColor*)blackOrWhiteContrastingColor {
    UIColor *black = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    float blackDiff = [self luminosityDifference:black];
    float whiteDiff = [self luminosityDifference:white];
    
    return (blackDiff > whiteDiff) ? black : white;
}

- (float)luminosityDifference:(UIColor*)otherColor {
    int numComponentsA = CGColorGetNumberOfComponents(self.CGColor);
    int numComponentsB = CGColorGetNumberOfComponents(otherColor.CGColor);
    
    if (numComponentsA == numComponentsB && numComponentsA == 4) {
        const float *rgbA = CGColorGetComponents(self.CGColor);
        const float *rgbB = CGColorGetComponents(otherColor.CGColor);
        
        float l1 = 0.2126 * pow(rgbA[0], 2.2f) + 
                   0.7152 * pow(rgbA[1], 2.2f) + 
                   0.0722 * pow(rgbA[2], 2.2f);
        float l2 = 0.2126 * pow(rgbB[0], 2.2f) + 
                   0.7152 * pow(rgbB[1], 2.2f) + 
                   0.0722 * pow(rgbB[2], 2.2f);
        
        if (l1 > l2) {
            return (l1+0.05f) / (l2/0.05f);
        } else {
            return (l2+0.05f) / (l1/0.05f);
        }
    }
    
    return 0.0f;
}

@end

