//
//  MJGSplashScreenView.h
//  MJGFoundation
//
//  Created by Matt Galloway on 28/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJGSplashScreenView : UIView

@property (nonatomic, assign) NSTimeInterval displayTime;
@property (nonatomic, assign) NSTimeInterval fadeTime;

- (id)initWithWindow:(UIWindow*)window;

- (void)show;
- (void)hide;

@end
