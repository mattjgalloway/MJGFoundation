//
//  MJGLoadableImageView.h
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJGLoadableImageView : UIView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong, readonly) UIImage *loadedImage;

- (id)initWithURL:(NSURL*)url;

- (void)startLoading;
- (void)cancelLoading;

@end
