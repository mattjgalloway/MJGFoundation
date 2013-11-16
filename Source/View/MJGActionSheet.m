//
//  MJGActionSheet.m
//  MJGFoundation
//
//  Created by Matt Galloway on 31/10/2013.
//  Copyright (c) 2013 Swipe Stack Ltd. All rights reserved.
//

#import "MJGActionSheet.h"

@interface MJGActionSheet () <UIActionSheetDelegate>

@property (nonatomic, weak) id <UIActionSheetDelegate> forwardDelegate;

@property (nonatomic, strong) NSMutableArray *actionBlocks;

@end

@implementation MJGActionSheet

#pragma mark -

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if ((self = [self initWithTitle:title])) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg actionBlock:nil];
        }
        va_end(args);
        
        if (destructiveButtonTitle) {
            NSInteger idx = [self addButtonWithTitle:destructiveButtonTitle actionBlock:nil];
            self.destructiveButtonIndex = idx;
        }
        
        if (cancelButtonTitle) {
            NSInteger idx = [self addButtonWithTitle:cancelButtonTitle actionBlock:nil];
            self.cancelButtonIndex = idx;
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title {
    if ((self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil])) {
        _actionBlocks = [NSMutableArray new];
    }
    return self;
}


#pragma mark -

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return [self addButtonWithTitle:title actionBlock:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(MJGActionSheetActionBlock)actionBlock {
    NSInteger idx = [super addButtonWithTitle:title];
    [_actionBlocks insertObject:(actionBlock ?: ^(MJGActionSheet *actionSheet, NSInteger idx){}) atIndex:idx];
    return idx;
}


#pragma mark - Custom accessors

- (void)setDelegate:(id<UIActionSheetDelegate>)delegate {
    [super setDelegate:self];
    if (delegate != self) {
        self.forwardDelegate = delegate;
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_forwardDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    if ([_forwardDelegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_forwardDelegate actionSheetCancel:actionSheet];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    if ([_forwardDelegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [_forwardDelegate willPresentActionSheet:actionSheet];
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
    if ([_forwardDelegate respondsToSelector:@selector(didPresentActionSheet:)]) {
        [_forwardDelegate didPresentActionSheet:actionSheet];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [_forwardDelegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
        [_forwardDelegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
    
    MJGActionSheetActionBlock actionBlock = _actionBlocks[buttonIndex];
    actionBlock(self, buttonIndex);
}

@end
