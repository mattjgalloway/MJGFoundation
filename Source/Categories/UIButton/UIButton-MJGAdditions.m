//
//  UIButton-MJGAdditions.m
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import "UIButton-MJGAdditions.h"

@implementation UIButton (MJGAdditions)

- (void)setTitle:(NSString*)newTitle {
    [self setTitle:newTitle forState:UIControlStateNormal];
    [self setTitle:newTitle forState:UIControlStateHighlighted];
    [self setTitle:newTitle forState:UIControlStateDisabled];
    [self setTitle:newTitle forState:UIControlStateSelected];
}

@end
