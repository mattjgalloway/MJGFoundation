//
//  MJGImageGalleryViewController.h
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGImageGalleryViewController;

@interface MJGImageGalleryViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) NSInteger startingPage;

- (id)initWithImages:(NSArray*)images;

@end
