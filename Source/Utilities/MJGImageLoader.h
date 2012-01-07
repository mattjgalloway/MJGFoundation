//
//  MJGImageLoader.h
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MJGImageLoaderHandler)(UIImage *image, NSError *error);

@interface MJGImageLoader : NSObject

- (id)initWithURL:(NSURL*)url;

- (void)startWithHandler:(MJGImageLoaderHandler)handler;
- (void)cancel;

@end
