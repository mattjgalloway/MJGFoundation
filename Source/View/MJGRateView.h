//
//  MJGRateView.h
//  MJGFoundation
//
//  Created by Matt Galloway on 03/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGRateView;

@interface MJGRateView : UIControl

@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) BOOL allowHalf;

- (void)setOnImage:(UIImage*)onImage offImage:(UIImage*)offImage;
- (void)setOnImage:(UIImage*)onImage halfImage:(UIImage*)halfImage offImage:(UIImage*)offImage;

@end
