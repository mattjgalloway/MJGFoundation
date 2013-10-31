//
//  MJGAlertView.m
//  MJGFoundation
//
//  Created by Matt Galloway on 31/10/2013.
//  Copyright (c) 2013 Swipe Stack Ltd. All rights reserved.
//

#import "MJGAlertView.h"

@interface MJGAlertView () <UIAlertViewDelegate>

@property (nonatomic, weak) id <UIAlertViewDelegate> forwardDelegate;

@property (nonatomic, strong) NSMutableArray *actionBlocks;

@end

@implementation MJGAlertView

#pragma mark -

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if ((self = [self initWithTitle:title message:message])) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg actionBlock:nil];
        }
        va_end(args);
        
        if (cancelButtonTitle) {
            NSInteger idx = [self addButtonWithTitle:cancelButtonTitle actionBlock:nil];
            self.cancelButtonIndex = idx;
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message {
    if ((self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil])) {
        _actionBlocks = [NSMutableArray new];
    }
    return self;
}


#pragma mark -

- (NSInteger)addButtonWithTitle:(NSString *)title {
    return [self addButtonWithTitle:title actionBlock:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(MJGAlertViewActionBlock)actionBlock {
    NSInteger idx = [super addButtonWithTitle:title];
    [_actionBlocks insertObject:(actionBlock ?: ^(MJGAlertView *actionSheet, NSInteger idx){}) atIndex:idx];
    return idx;
}


#pragma mark - Custom accessors

- (void)setDelegate:(id<UIAlertViewDelegate>)delegate {
    [super setDelegate:self];
    if (delegate != self) {
        self.forwardDelegate = delegate;
    }
}


#pragma mark - UIActionSheetDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_forwardDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
    
    MJGAlertViewActionBlock actionBlock = _actionBlocks[buttonIndex];
    actionBlock(self, buttonIndex);
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if ([_forwardDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [_forwardDelegate alertViewCancel:alertView];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    if ([_forwardDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_forwardDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    if ([_forwardDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [_forwardDelegate didPresentAlertView:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [_forwardDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([_forwardDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [_forwardDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if ([_forwardDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [_forwardDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    return YES;
}

@end
