//
//  MJGSplashScreenView.m
//  MJGFoundation
//
//  Created by Matt Galloway on 28/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGSplashScreenView.h"

static const NSTimeInterval kDefaultDisplayTime = 1.0;
static const NSTimeInterval kDefaultFadeTime = 0.5;

@interface MJGSplashScreenView ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *splashImageView;
@property (nonatomic, strong) NSTimer *displayTimer;

- (void)displayTimerTimeout;
@end

@implementation MJGSplashScreenView

@synthesize displayTime = _displayTime;
@synthesize fadeTime = _fadeTime;

@synthesize window = _window;
@synthesize splashImageView = _splashImageView;
@synthesize displayTimer = _displayTimer;

#pragma mark -

- (void)show {
    self.frame = _window.bounds;
    [_window addSubview:self];
    [_window bringSubviewToFront:self];
    if (_displayTime > 0.) {
        _displayTimer = [NSTimer scheduledTimerWithTimeInterval:_displayTime target:self selector:@selector(displayTimerTimeout) userInfo:nil repeats:NO];
    }
}

- (void)hide {
    [_displayTimer invalidate];
    _displayTimer = nil;
    
    if (_fadeTime > 0.) {
        [UIView animateWithDuration:_fadeTime 
                              delay:0. 
                            options:0 
                         animations:^{
                             self.alpha = 0.0f;
                         } 
                         completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    } else {
        [self removeFromSuperview];
    }
}


#pragma mark -

- (void)displayTimerTimeout {
    [self hide];
}


#pragma mark - View lifecycle

- (id)initWithWindow:(UIWindow*)window {
    if ((self = [super initWithFrame:window.bounds])) {
        self.window = window;
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _displayTime = kDefaultDisplayTime;
        _fadeTime = kDefaultFadeTime;
        
        _splashImageView = [[UIImageView alloc] initWithImage:nil];
        _splashImageView.opaque = NO;
        _splashImageView.backgroundColor = [UIColor clearColor];
        _splashImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_splashImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGPoint offset = CGPointZero;
    UIImage *image = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        image = [UIImage imageNamed:@"Default.png"];
    } else {
        UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(ori)) {
            image = [UIImage imageNamed:@"Default-Portrait.png"];
        } else {
            image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
        
        switch (ori) {
            case UIInterfaceOrientationPortrait:
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                transform = CGAffineTransformMakeRotation(M_PI);
                offset = CGPointMake(0.0f, -20.0f);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                transform = CGAffineTransformMakeRotation(-M_PI_2);
                offset = CGPointMake(20.0f, 0.0f);
                break;
            case UIInterfaceOrientationLandscapeRight:
                transform = CGAffineTransformMakeRotation(M_PI_2);
                offset = CGPointMake(-20.0f, 0.0f);
                break;
        }
    }
    _splashImageView.image = image;
    _splashImageView.transform = transform;
    _splashImageView.bounds = self.bounds;
    _splashImageView.center = CGPointMake((self.bounds.size.width + offset.x) / 2.0f, (self.bounds.size.height + offset.y) / 2.0f);
}

@end
