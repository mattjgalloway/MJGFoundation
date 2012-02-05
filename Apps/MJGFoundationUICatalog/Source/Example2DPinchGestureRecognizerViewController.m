//
//  Example2DPinchGestureRecognizerViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 01/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "Example2DPinchGestureRecognizerViewController.h"

#import "MJG2DPinchGestureRecognizer.h"

@interface Example2DPinchGestureRecognizerViewController ()
- (void)pinched:(MJG2DPinchGestureRecognizer*)recognizer;
@end

@implementation Example2DPinchGestureRecognizerViewController

#pragma mark -

- (void)pinched:(MJG2DPinchGestureRecognizer*)recognizer {
    NSLog(@"Horizontal = %.2f", recognizer.horizontalScale);
    NSLog(@"Vertical = %.2f", recognizer.verticalScale);
    NSLog(@"Combined = %.2f", recognizer.scale);
}


#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    MJG2DPinchGestureRecognizer *gr = [[MJG2DPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched:)];
    [self.view addGestureRecognizer:gr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
