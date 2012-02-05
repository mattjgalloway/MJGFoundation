//
//  MJGRateView.m
//  MJGFoundation
//
//  Created by Matt Galloway on 03/01/2012
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGRateView.h"

@interface MJGRateView ()
@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *halfImage;
@property (nonatomic, strong) UIImage *offImage;

- (void)setupInstance;

- (UIImage*)createMaskForRect:(CGRect)rect cutLeftSide:(BOOL)cutLeftSide;
- (void)drawHalfImage:(UIImage*)lhs otherImage:(UIImage*)rhs atRect:(CGRect)drawRect;

- (CGFloat)getTappedBucket:(CGPoint)touchPoint;
- (void)handleTapEventAtLocation:(CGPoint)location;
@end

@implementation MJGRateView

@synthesize max, value, allowHalf;
@synthesize onImage, halfImage, offImage;

#pragma mark - Custom Accessors

- (void)setMax:(NSInteger)inMax {
    if (inMax != max) {
        max = inMax;
        value = MIN(value, (CGFloat)max);
        [self setNeedsDisplay];
    }
}

- (void)setValue:(CGFloat)inValue {
    value = inValue;
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setOnImage:(UIImage*)inOnImage offImage:(UIImage*)inOffImage {
    self.onImage = inOnImage;
    self.offImage = inOffImage;
    [self setNeedsDisplay];
}

- (void)setOnImage:(UIImage*)inOnImage halfImage:(UIImage*)inHalfImage offImage:(UIImage*)inOffImage {
    self.onImage = inOnImage;
    self.halfImage = inHalfImage;
    self.offImage = inOffImage;
    [self setNeedsDisplay];
}


#pragma mark -

- (void)setupInstance {
    onImage = [UIImage imageNamed:@"star_on.png"];
    halfImage = nil;
    offImage = [UIImage imageNamed:@"star_off.png"];
    
    max = 5;
    value = 1.0;
    allowHalf = YES;
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupInstance];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupInstance];
    }
    return self;
}


#pragma mark - Drawing Code

- (UIImage*)createMaskForRect:(CGRect)rect cutLeftSide:(BOOL)cutLeftSide {
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(NULL, 
                                                 w, 
                                                 h, 
                                                 8, 
                                                 0, 
                                                 colorSpace, 
                                                 kCGImageAlphaNone);
	
	if (cutLeftSide) {
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    } else {
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    }
	CGContextFillRect(context, CGRectMake(0.0f, 0.0f, w/2.0f, h));
	
	if (cutLeftSide) {
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    } else {
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    }
	CGContextFillRect(context, CGRectMake(w/2.0f, 0.0f, w/2.0f, h));
	
	CGImageRef theCGImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
    UIImage *retImage = [UIImage imageWithCGImage:theCGImage];
    CFRelease(theCGImage);
    
	return retImage;
}

- (void)drawHalfImage:(UIImage*)lhs otherImage:(UIImage*)rhs atRect:(CGRect)drawRect {
	UIImage *rightSideMask = [self createMaskForRect:drawRect cutLeftSide:YES];
	UIImage *leftSideMask  = [self createMaskForRect:drawRect cutLeftSide:NO];
	
	CGImageRef cuttedLeftImage  = CGImageCreateWithMask(lhs.CGImage, leftSideMask.CGImage);
	CGImageRef cuttedRightImage = CGImageCreateWithMask(rhs.CGImage, rightSideMask.CGImage);
	
	[[UIImage imageWithCGImage:cuttedLeftImage] drawInRect:drawRect];
	[[UIImage imageWithCGImage:cuttedRightImage] drawInRect:drawRect];
    
    CFRelease(cuttedLeftImage);
    CFRelease(cuttedRightImage);
}

- (void)drawRect:(CGRect)rect {
    CGSize imageSize = onImage.size;
    CGFloat cellWidth = rect.size.width / (CGFloat)max;
    CGFloat cellHeight = rect.size.height;
    CGFloat cellAspect = imageSize.width / imageSize.height;
    
    CGFloat cellWidthFromAspect = cellHeight * cellAspect;
    CGFloat cellHeightFromAspect = cellWidth / cellAspect;
    
    CGFloat imgWidth, imgHeight;
    if (cellWidth <= cellWidthFromAspect) {
        imgWidth = cellWidth;
        imgHeight = cellHeightFromAspect;
    } else {
        imgWidth = cellWidthFromAspect;
        imgHeight = cellHeight;
    }
    
    for (int i=0; i<max; i++) {
        int x = (int)( floorf((cellWidth * (CGFloat)i) + ((cellWidth - imgWidth) / 2.0f)) );
        int y = (int)( floorf((cellHeight - imgHeight) / 2.0f) );
        
        CGRect starRect = CGRectMake(x, y, imgWidth, imgHeight);
        if (CGRectIntersectsRect(starRect, rect)) {
            if (value >= (i+1)) {
                [onImage drawInRect:starRect];
            } else if (allowHalf && ((value+0.5) >= (i+1))) {
                if (halfImage) {
                    [halfImage drawInRect:starRect];
                } else {
                    [self drawHalfImage:onImage otherImage:offImage atRect:starRect];
                }
            } else {
                [offImage drawInRect:starRect];
            }
        }
    }
}


#pragma mark - Touch Handling

- (CGFloat)getTappedBucket:(CGPoint)touchPoint {
    CGFloat fraction = (touchPoint.x / self.frame.size.width);
    CGFloat bucket = floorf((fraction * max * 2.0f) + 1.0f) / 2.0f;
    bucket = MIN(bucket, (CGFloat)max);
    bucket = MAX(bucket, 0.0f);
    return bucket;
}

- (void)handleTapEventAtLocation:(CGPoint)location {
    CGFloat newValue = [self getTappedBucket:location];
    if (value == newValue) {
        return;
    }
    self.value = newValue;
}

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    [self handleTapEventAtLocation:[touch locationInView:self]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    [self handleTapEventAtLocation:[touch locationInView:self]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    [self handleTapEventAtLocation:[touch locationInView:self]];
}

- (void)cancelTrackingWithEvent:(UIEvent*)event {
}

@end
