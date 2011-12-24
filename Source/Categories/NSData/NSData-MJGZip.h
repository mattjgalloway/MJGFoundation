//
//  NSData-MJGZip.h
//  MJGFoundation
//
//  Created by Matt Galloway on 24/12/2011.
//  Copyright (c) 2011 Matt Galloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MJGZip)

- (NSData*)gzipInflate;
- (NSData*)gzipDeflate;

@end
