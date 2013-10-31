//
//  MJGActionSheet.h
//  MJGFoundation
//
//  Created by Matt Galloway on 31/10/2013.
//  Copyright (c) 2013 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGActionSheet;

typedef void(^MJGActionSheetActionBlock)(MJGActionSheet *actionSheet, NSInteger idx);

@interface MJGActionSheet : UIActionSheet

- (instancetype)initWithTitle:(NSString*)title;

- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(MJGActionSheetActionBlock)actionBlock;

@end
