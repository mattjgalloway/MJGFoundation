//
//  UIColor-MJGAdditions.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "UIColor-MJGAdditions.h"

@implementation UIColor (MJGAdditions)

+ (UIColor*)colorWithHexValue:(NSString*)hex {
    if (!hex) return nil;
    
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    NSString *rStr = nil, *gStr = nil, *bStr = nil, *aStr = nil;
    
    if (hex.length == 3) {
        rStr = [hex substringWithRange:NSMakeRange(0, 1)];
        rStr = [NSString stringWithFormat:@"%@%@", rStr, rStr];
        gStr = [hex substringWithRange:NSMakeRange(1, 1)];
        gStr = [NSString stringWithFormat:@"%@%@", gStr, gStr];
        bStr = [hex substringWithRange:NSMakeRange(2, 1)];
        bStr = [NSString stringWithFormat:@"%@%@", bStr, bStr];
        aStr = @"FF";
    } else if (hex.length == 4) {
        rStr = [hex substringWithRange:NSMakeRange(0, 1)];
        rStr = [NSString stringWithFormat:@"%@%@", rStr, rStr];
        gStr = [hex substringWithRange:NSMakeRange(1, 1)];
        gStr = [NSString stringWithFormat:@"%@%@", gStr, gStr];
        bStr = [hex substringWithRange:NSMakeRange(2, 1)];
        bStr = [NSString stringWithFormat:@"%@%@", bStr, bStr];
        aStr = [hex substringWithRange:NSMakeRange(3, 1)];
        aStr = [NSString stringWithFormat:@"%@%@", aStr, aStr];
    } else if (hex.length == 6) {
        rStr = [hex substringWithRange:NSMakeRange(0, 2)];
        gStr = [hex substringWithRange:NSMakeRange(2, 2)];
        bStr = [hex substringWithRange:NSMakeRange(4, 2)];
        aStr = @"FF";
    } else if (hex.length == 8) {
        rStr = [hex substringWithRange:NSMakeRange(0, 2)];
        gStr = [hex substringWithRange:NSMakeRange(2, 2)];
        bStr = [hex substringWithRange:NSMakeRange(4, 2)];
        aStr = [hex substringWithRange:NSMakeRange(6, 2)];
    } else {
        // Unknown encoding
        return nil;
    }
    
    unsigned r, g, b, a;
    [[NSScanner scannerWithString:rStr] scanHexInt:&r];
    [[NSScanner scannerWithString:gStr] scanHexInt:&g];
    [[NSScanner scannerWithString:bStr] scanHexInt:&b];
    [[NSScanner scannerWithString:aStr] scanHexInt:&a];
    
    if (r == g && g == b) {
        // Optimal case for grayscale
        return [UIColor colorWithWhite:(((CGFloat)r)/255.0f) alpha:(((CGFloat)a)/255.0f)];
    } else {
        return [UIColor colorWithRed:(((CGFloat)r)/255.0f) green:(((CGFloat)g)/255.0f) blue:(((CGFloat)b)/255.0f) alpha:(((CGFloat)a)/255.0f)];
    }
}

- (UIColor*)blackOrWhiteContrastingColor {
    UIColor *black = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    float blackDiff = [self luminosityDifference:black];
    float whiteDiff = [self luminosityDifference:white];
    
    return (blackDiff > whiteDiff) ? black : white;
}

- (CGFloat)luminosity {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;

    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];

    if (success)
        return 0.2126 * pow(red, 2.2f) + 0.7152 * pow(green, 2.2f) + 0.0722 * pow(blue, 2.2f);

    CGFloat white;

    success = [self getWhite:&white alpha:&alpha];
    if (success)
        return pow(white, 2.2f);

    return -1;
}

- (CGFloat)luminosityDifference:(UIColor*)otherColor {
    CGFloat l1 = [self luminosity];
    CGFloat l2 = [otherColor luminosity];

    if (l1 >= 0 && l2 >= 0) {
        if (l1 > l2) {
            return (l1+0.05f) / (l2+0.05f);
        } else {
            return (l2+0.05f) / (l1+0.05f);
        }
    }
    
    return 0.0f;
}

@end

