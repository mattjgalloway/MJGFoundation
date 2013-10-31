//
//  MJGAlertView.h
//  MJGFoundation
//
//  Created by Matt Galloway on 31/10/2013.
//  Copyright (c) 2013 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGAlertView;

typedef void(^MJGAlertViewActionBlock)(MJGAlertView *alertView, NSInteger idx);

@interface MJGAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message;

- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(MJGAlertViewActionBlock)actionBlock;

@end
