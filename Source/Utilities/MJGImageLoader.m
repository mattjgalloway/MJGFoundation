//
//  MJGImageLoader.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGImageLoader.h"

@interface MJGImageLoader ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, copy) MJGImageLoaderHandler handler;
@end

@implementation MJGImageLoader

@synthesize url = _url, connection = _connection, responseData = _responseData;
@synthesize handler = _handler;

#pragma mark -

- (id)initWithURL:(NSURL*)inUrl {
    if ((self = [super init])) {
        _url = inUrl;
        _connection = nil;
        _responseData = nil;
    }
    return self;
}


#pragma mark -

- (void)startWithHandler:(MJGImageLoaderHandler)inHandler {
    self.handler = inHandler;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:30.0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel {
    [_connection cancel];
    _connection = nil;
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)aConnection didReceiveResponse:(NSURLResponse*)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection*)aConnection didReceiveData:(NSData*)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)aConnection {
    UIImage *image = [UIImage imageWithData:_responseData];
    if (self.handler) {
        self.handler(image, nil);
    }
    _responseData = nil;
    _connection = nil;
}

- (void)connection:(NSURLConnection*)aConnection didFailWithError:(NSError*)error {  
    if (self.handler) {
        self.handler(nil, error);
    }
    _responseData = nil;
    _connection = nil;
}

@end
