//
//  MJGLoadableImageView.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGLoadableImageView.h"

#import "MJGImageLoader.h"

@interface MJGLoadableImageView ()
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) MJGImageLoader *imageLoader;
@property (nonatomic, strong, readwrite) UIImage *loadedImage;
@end

@implementation MJGLoadableImageView

@synthesize placeholderImage = _placeholderImage;
@synthesize url = _url;
@synthesize activityView = _activityView, imageView = _imageView;
@synthesize imageLoader = _imageLoader, loadedImage = _loadedImage;

#pragma mark -

- (void)startLoading {
    if (_url) {
        if (!_imageLoader) {
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _imageLoader = [[MJGImageLoader alloc] initWithURL:_url];
            [_imageLoader startWithHandler:^(UIImage *image, NSError *error){
                if (image) {
                    self.loadedImage = image;
                    [self setNeedsLayout];
                }
                
                _activityView.hidden = YES;
                [_activityView stopAnimating];
                
                _imageLoader = nil;
            }];
        }
    }
}

- (void)cancelLoading {
    [_imageLoader cancel];
}


#pragma mark - Custom accessors

- (void)setPlaceholderImage:(UIImage *)inPlaceholderImage {
    _placeholderImage = inPlaceholderImage;
    [self setNeedsLayout];
}


#pragma mark -

- (id)init {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.activityView];
    }
    return self;
}

- (id)initWithURL:(NSURL*)inUrl {
    if ((self = [self init])) {
        _url = inUrl;
    }
    return self;
}

- (void)dealloc {
    [_imageLoader cancel];
}


#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_loadedImage) {
        _imageView.hidden = NO;
        _imageView.alpha = 1.0f;
        _imageView.image = _loadedImage;
    } else if (self.placeholderImage) {
        _imageView.hidden = NO;
        _imageView.alpha = 0.5f;
        _imageView.image = _placeholderImage;
    } else {
        _imageView.hidden = YES;
    }
    
    CGRect bounds = self.bounds;
    _imageView.frame = bounds;
    _activityView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}


@end
