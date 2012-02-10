//
//  MJGFullscreenWebViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGFullscreenWebViewController.h"

@interface MJGFullscreenWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;

@property (nonatomic, strong) NSURL *startURL;
@property (nonatomic, strong) NSTimer *buttonRefreshTimer;

@property (nonatomic, strong) UIColor *savedToolbarTintColor;

- (void)done:(id)sender;

- (void)updateBackForwardButtons;
- (void)showLoadingView;
- (void)hideLoadingView;
@end

@implementation MJGFullscreenWebViewController

@synthesize webView = _webView, loadingView = _loadingView, toolbar = _toolbar, backButton = _backButton, forwardButton = _forwardButton, refreshButton = _refreshButton, stopButton = _stopButton;
@synthesize delegate = _delegate;
@synthesize startURL = _startURL, buttonRefreshTimer = _buttonRefreshTimer;
@synthesize savedToolbarTintColor = _savedToolbarTintColor;

#pragma mark -

- (void)setToolbarTintColor:(UIColor*)color {
    _savedToolbarTintColor = color;
    [_toolbar setTintColor:color];
}


#pragma mark -

- (void)done:(id)sender {
    [_buttonRefreshTimer invalidate]; _buttonRefreshTimer = nil;
    if ([_delegate respondsToSelector:@selector(fullscreenWebViewControllerDidFinish:)]) {
        [_delegate fullscreenWebViewControllerDidFinish:self];
    }
}


#pragma mark -

- (void)updateBackForwardButtons {
    _backButton.enabled = _webView.canGoBack;
    _forwardButton.enabled = _webView.canGoForward;
}

- (void)showLoadingView {
    _loadingView.hidden = NO;
    [UIView animateWithDuration:0.5 
                     animations:^{
                         _loadingView.center = CGPointMake(self.view.bounds.size.width/2.0f, _loadingView.frame.size.height/2.0f);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.5 
                     animations:^{
                         _loadingView.center = CGPointMake(self.view.bounds.size.width/2.0f, -(_loadingView.frame.size.height/2.0f));
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _loadingView.hidden = YES;
                         }
                     }];
}


#pragma mark -

- (id)initWithURL:(NSURL*)inURL {
    if ((self = [super init])) {
        _startURL = inURL;
    }
    return self;
}

- (void)dealloc {
    _webView.delegate = nil;
    [_buttonRefreshTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height - 44.0f)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, bounds.size.height - 44.0f, bounds.size.width, 44.0f)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    if (_savedToolbarTintColor) {
        _toolbar.tintColor = _savedToolbarTintColor;
    }
    [self.view addSubview:_toolbar];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:_webView action:@selector(goBack)];
    _backButton.style = UIBarButtonItemStyleBordered;
    _forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:_webView action:@selector(goForward)];
    _forwardButton.style = UIBarButtonItemStyleBordered;
    _stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:_webView action:@selector(stopLoading)];
    _stopButton.style = UIBarButtonItemStyleBordered;
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:_webView action:@selector(reload)];
    _refreshButton.style = UIBarButtonItemStyleBordered;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    
    _toolbar.items = [NSArray arrayWithObjects:spacer, _backButton, spacer, _forwardButton, spacer, _stopButton, spacer, _refreshButton, spacer, doneButton, spacer, nil];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, bounds.size.width, 30.0f)];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _loadingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _loadingView.opaque = NO;
    [self.view addSubview:_loadingView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 4.0f, bounds.size.width - 48.0f, 22.0f)];
    loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    loadingLabel.text = @"Loading...";
    loadingLabel.font = [UIFont systemFontOfSize:17.0f];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.opaque = NO;
    [_loadingView addSubview:loadingLabel];
    
    UIActivityIndicatorView *activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activitySpinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [activitySpinner startAnimating];
    [_loadingView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(_loadingView.bounds.size.width - 10.0f - (activitySpinner.bounds.size.width / 2.0f), 15.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backButton.enabled = _webView.canGoBack;
    _forwardButton.enabled = _webView.canGoForward;
    _refreshButton.enabled = NO;
    _stopButton.enabled = NO;
    
    _buttonRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateBackForwardButtons) userInfo:nil repeats:YES];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_startURL]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_webView stopLoading];
    _webView.delegate = nil;
    _webView = nil;
    _loadingView = nil;
    _toolbar = nil;
    _backButton = nil;
    _forwardButton = nil;
    _refreshButton = nil;
    _stopButton = nil;
    
    [_buttonRefreshTimer invalidate]; _buttonRefreshTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)aWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    [self updateBackForwardButtons];

    NSURL *url = request.URL;

    if ([url.host isEqualToString:@"phobos.apple.com"] || [url.host isEqualToString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)aWebView {
    [self showLoadingView];
    [self updateBackForwardButtons];
    _refreshButton.enabled = YES;
    _stopButton.enabled = YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)aWebView {
    [self hideLoadingView];
    [self updateBackForwardButtons];
    _refreshButton.enabled = YES;
    _stopButton.enabled = NO;
}

@end
