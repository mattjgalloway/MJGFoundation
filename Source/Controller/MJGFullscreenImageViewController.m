//
//  MJGFullscreenImageViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGFullscreenImageViewController.h"

#import "MJGImageLoader.h"

@interface MJGFullscreenImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) MJGImageLoader *imageLoader;
@end

@implementation MJGFullscreenImageViewController

@synthesize imageView = _imageView, activityView = _activityView;
@synthesize url = _url, image = _image;
@synthesize imageLoader = _imageLoader;

#pragma mark -

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithURL:(NSURL*)inUrl {
    if ((self = [self init])) {
        _url = inUrl;
    }
    return self;
}

- (id)initWithImage:(UIImage*)inImage {
    if ((self = [self init])) {
        _image = inImage;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height)];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_imageView];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _activityView.hidesWhenStopped = YES;
    [_activityView stopAnimating];
    [self.view addSubview:_activityView];
    _activityView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo";
    
    if (_image) {
        _imageView.image = _image;
        [_activityView stopAnimating];
    } else if (_url) {
        [_activityView startAnimating];
        _imageLoader = [[MJGImageLoader alloc] initWithURL:_url];
        [_imageLoader startWithHandler:^(UIImage *image, NSError *error){
            if (image) {
                _image = image;
                _imageView.image = _image;
            }
            
            [_activityView stopAnimating];
            
            _imageLoader = nil;
        }];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    _imageView = nil;
    _activityView = nil;
    
    [_imageLoader cancel];
    _imageLoader = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
