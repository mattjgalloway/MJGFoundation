//
//  ExampleMJGRateViewViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 05/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "ExampleMJGRateViewViewController.h"

#import "MJGRateView.h"

@implementation ExampleMJGRateViewViewController

#pragma mark - View lifecycle

- (id)init {
    if ((self = [super initWithNibName:nil bundle:nil])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MJGRateView *rateView1 = [[MJGRateView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 180.0f, 60.0f)];
    rateView1.max = 5;
    [self.view addSubview:rateView1];
    
    MJGRateView *rateView2 = [[MJGRateView alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 180.0f, 60.0f)];
    rateView2.max = 10;
    rateView2.value = 3;
    rateView2.allowHalf = NO;
    rateView2.enabled = NO;
    [self.view addSubview:rateView2];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
