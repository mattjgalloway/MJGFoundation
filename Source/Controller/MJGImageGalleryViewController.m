//
//  MJGImageGalleryViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGImageGalleryViewController.h"

@interface MJGImageGalleryViewController ()
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSArray *images;

@property (nonatomic, retain) NSMutableArray *pageViews;
@property (nonatomic, unsafe_unretained) NSInteger selectedPageIndex;
@property (nonatomic, retain) NSTimer *hideNavigationBarTimer;

- (NSInteger)visiblePageIndex;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
- (void)resetScrollView;
- (void)scrollViewLandedOnPage;

- (void)showNavigationBar;
- (void)hideNavigationBar;
- (void)viewTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation MJGImageGalleryViewController

@synthesize scrollView = _scrollView;
@synthesize startingPage = _startingPage;
@synthesize images = _images;
@synthesize pageViews = _pageViews, selectedPageIndex = _selectedPageIndex, hideNavigationBarTimer = _hideNavigationBarTimer;

#pragma mark -

- (id)initWithImages:(NSArray*)inImages {
    if ((self = [super init])) {
        _images = inImages;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -

- (NSInteger)visiblePageIndex {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    return floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
}

- (void)loadVisiblePages {
    NSInteger page = [self visiblePageIndex];
    
    NSInteger firstPage = page-1;
    NSInteger lastPage = page+1;
    
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<_images.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.images.count) return;
    
    UIImageView *pageView = [_pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame;
        frame = _scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        
        UIImage *thisImage = (UIImage*)[_images objectAtIndex:page];
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:thisImage];
        newPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        newPageView.frame = frame;
        
        [_scrollView addSubview:newPageView];
        
        [_pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= _images.count) return;
    
    UIImageView *pageView = [_pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [_pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)resetScrollView {
    _selectedPageIndex = 0;
    
    for (NSInteger i = 0; i < _pageViews.count; ++i) {
        [self purgePage:i];
    }
    
    [_pageViews removeAllObjects];
    
    for (NSInteger i = 0; i < _images.count; ++i) {
        [_pageViews addObject:[NSNull null]];
    }
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * _images.count, pagesScrollViewSize.height);
    _scrollView.contentOffset = CGPointMake(pagesScrollViewSize.width * _startingPage, 0.0f);
}

- (void)scrollViewLandedOnPage {
}


#pragma mark -

- (void)showNavigationBar {
    [self.hideNavigationBarTimer invalidate];
    self.hideNavigationBarTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)hideNavigationBar {
    [self.hideNavigationBarTimer invalidate];
    self.hideNavigationBarTimer = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewTapped:(UITapGestureRecognizer*)recognizer {
    if (self.navigationController.navigationBarHidden) {
        [self showNavigationBar];
    } else {
        [self hideNavigationBar];
    }
}


#pragma mark - View lifecycle

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Gallery";
    
    _pageViews = [NSMutableArray arrayWithCapacity:0];
    _selectedPageIndex = 0;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self resetScrollView];
    [self loadVisiblePages];
    [self scrollViewLandedOnPage];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    _scrollView = nil;
    
    _pageViews = nil;
    [_hideNavigationBarTimer invalidate]; _hideNavigationBarTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self showNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self showNavigationBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger newSelectedPage = [self visiblePageIndex];
    if (newSelectedPage != self.selectedPageIndex) {
        self.selectedPageIndex = newSelectedPage;
        [self loadVisiblePages];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewLandedOnPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewLandedOnPage];
}

@end
