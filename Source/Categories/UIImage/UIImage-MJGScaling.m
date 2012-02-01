//
//  UIImage-MJGScaling.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "UIImage-MJGScaling.h"

@implementation UIImage (MJGScaling)

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleImageToSize:(CGSize)newSize {
    return [UIImage imageWithImage:self scaledToSize:newSize];
}

- (UIImage*)imageWithContentMode:(UIViewContentMode)contentMode inBounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality {
    CGSize imageSize = self.size;
    CGFloat imageRatio = imageSize.width / imageSize.height;
    CGFloat boundsRatio = bounds.width / bounds.height;
    
    CGSize drawSize = CGSizeZero;
    CGPoint drawOffset = CGPointZero;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            if (boundsRatio > imageRatio) {
                drawSize.width = bounds.width;
                drawSize.height = bounds.width / imageRatio;
                drawOffset.x = 0.0f;
                drawOffset.y = (bounds.height - drawSize.height) / 2.0f;
            } else {
                drawSize.width = bounds.height * imageRatio;
                drawSize.height = bounds.height;
                drawOffset.x = (bounds.width - drawSize.width) / 2.0f;
                drawOffset.y = 0.0f;
            }
            break;
        case UIViewContentModeScaleAspectFit:
            if (boundsRatio < imageRatio) {
                drawSize.width = bounds.width;
                drawSize.height = bounds.width / imageRatio;
                drawOffset.x = 0.0f;
                drawOffset.y = (bounds.height - drawSize.height) / 2.0f;
            } else {
                drawSize.width = bounds.height * imageRatio;
                drawSize.height = bounds.height;
                drawOffset.x = (bounds.width - drawSize.width) / 2.0f;
                drawOffset.y = 0.0f;
            }
            break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
            drawSize = bounds;
            drawOffset = CGPointZero;
            break;
        case UIViewContentModeBottom:
            drawSize = imageSize;
            drawOffset.x = (bounds.width - drawSize.width) / 2.0f;
            drawOffset.y = -(drawSize.height - bounds.height);
            break;
        case UIViewContentModeBottomLeft:
            drawSize = imageSize;
            drawOffset.x = 0.0f;
            drawOffset.y = -(drawSize.height - bounds.height);
            break;
        case UIViewContentModeBottomRight:
            drawSize = imageSize;
            drawOffset.x = -(drawSize.width - bounds.width);
            drawOffset.y = -(drawSize.height - bounds.height);
            break;
        case UIViewContentModeCenter:
            drawSize = imageSize;
            drawOffset.x = (bounds.width - drawSize.width) / 2.0f;
            drawOffset.y = (bounds.height - drawSize.height) / 2.0f;
            break;
        case UIViewContentModeLeft:
            drawSize = imageSize;
            drawOffset.x = 0.0f;
            drawOffset.y = (bounds.height - drawSize.height) / 2.0f;
            break;
        case UIViewContentModeRight:
            drawSize = imageSize;
            drawOffset.x = -(drawSize.width - bounds.width);
            drawOffset.y = (bounds.height - drawSize.height) / 2.0f;
            break;
        case UIViewContentModeTop:
            drawSize = imageSize;
            drawOffset.x = (bounds.width - drawSize.width) / 2.0f;
            drawOffset.y = (drawSize.height - bounds.height);
            break;
        case UIViewContentModeTopLeft:
            drawSize = imageSize;
            drawOffset.x = 0.0f;
            drawOffset.y = -(drawSize.height - bounds.height);
            break;
        case UIViewContentModeTopRight:
            drawSize = imageSize;
            drawOffset.x = -(drawSize.width - bounds.width);
            drawOffset.y = -(drawSize.height - bounds.height);
            break;
    }
    
    CGImageRef imageRef = self.CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                bounds.width,
                                                bounds.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, quality);
    
    CGRect rect = CGRectIntegral(CGRectMake(drawOffset.x, drawOffset.y, drawSize.width, drawSize.height));
    CGRect transposedRect = CGRectMake(drawOffset.y, drawOffset.x, drawSize.height, drawSize.width);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect drawRect = rect;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, rect.size.width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformTranslate(transform, rect.size.width, rect.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, 0.0f, rect.size.height);
            transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
            break;
        case UIImageOrientationLeft:
            transform = CGAffineTransformTranslate(transform, rect.size.width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            drawRect = transposedRect;
            break;
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, rect.size.width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            transform = CGAffineTransformTranslate(transform, rect.size.height, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            drawRect = transposedRect;
            break;
        case UIImageOrientationRight:
            transform = CGAffineTransformTranslate(transform, 0.0f, rect.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            drawRect = transposedRect;
            break;
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            drawRect = transposedRect;
            break;
    }
    
    CGContextConcatCTM(bitmap, transform);
    CGContextDrawImage(bitmap, drawRect, imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
