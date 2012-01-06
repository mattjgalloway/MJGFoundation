//
//  MJGRateView.h
//  MJGFoundation
//
//  Created by Matt Galloway on 03/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGRateView;

@protocol MJGRateViewDelegate <NSObject>
@optional
- (void)rateView:(MJGRateView*)rateView changedValueTo:(CGFloat)newValue;
@end

@interface MJGRateView : UIView

@property (nonatomic, unsafe_unretained) NSInteger max;
@property (nonatomic, unsafe_unretained) CGFloat value;
@property (nonatomic, unsafe_unretained) BOOL allowEditing;

@property (nonatomic, unsafe_unretained) id <MJGRateViewDelegate> delegate;

- (void)setOnImage:(UIImage*)onImage offImage:(UIImage*)offImage;
- (void)setOnImage:(UIImage*)onImage halfImage:(UIImage*)halfImage offImage:(UIImage*)offImage;

@end
