//
//  MJGFullscreenWebViewController.h
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGFullscreenWebViewController;

@protocol MJGFullscreenWebViewControllerDelegate <NSObject>
- (void)fullscreenWebViewControllerDidFinish:(MJGFullscreenWebViewController*)viewController;
@end

@interface MJGFullscreenWebViewController : UIViewController <UIWebViewDelegate> {
}

@property (nonatomic, unsafe_unretained) id <MJGFullscreenWebViewControllerDelegate> delegate;

- (id)initWithURL:(NSURL*)url;

- (void)setToolbarTintColor:(UIColor*)color;

@end
