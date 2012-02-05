//
//  MJGObjectCache.m
//  MJGFoundation
//
//  Created by Matt Galloway on 03/02/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MJGObjectCache.h"

#import "MJGObjectCacheEntry.h"

static MJGObjectCache *sharedInstance = nil;

static NSString *kCacheFileName = @"MJGObjectCache.dat";

@interface MJGObjectCache ()
@property (nonatomic, copy) NSString *cacheFilename;

@property (nonatomic, strong) NSMutableSet *allEntries;
@property (nonatomic, strong) NSMutableDictionary *entriesByKey;

- (void)loadData;
- (void)saveData;

- (MJGObjectCacheEntry*)getCacheEntryForKey:(NSString*)key;
- (void)addCacheEntry:(MJGObjectCacheEntry*)entry;
- (void)removeCacheEntry:(MJGObjectCacheEntry*)entry;
@end

@implementation MJGObjectCache

@synthesize cacheFilename = _cacheFilename;

@synthesize allEntries = _allEntries;
@synthesize entriesByKey = _entriesByKey;

#pragma mark -

+ (id)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}


#pragma mark -

- (id)initWithCacheFilename:(NSString*)cacheFilename {
    if ((self = [super init])) {
        self.cacheFilename = cacheFilename;
        [self loadData];
    }
    return self;
}

- (id)init {
    if ((self = [self initWithCacheFilename:kCacheFileName])) {
    }
    return self;
}


#pragma mark -

- (void)setObject:(id)object forKey:(NSString*)key withExpiryDate:(NSDate*)expiry {
    MJGObjectCacheEntry *newEntry = [[MJGObjectCacheEntry alloc] init];
    newEntry.object = object;
    newEntry.key = key;
    newEntry.expiryDate = expiry;
    [self addCacheEntry:newEntry];
}

- (id)objectForKey:(NSString*)key {
    MJGObjectCacheEntry *entry = [self getCacheEntryForKey:key];
    if (entry) {
        return entry.object;
    }
    return nil;
}

- (void)clearCacheForKey:(NSString*)key {
    MJGObjectCacheEntry *entry = [self getCacheEntryForKey:key];
    if (entry) {
        [self removeCacheEntry:entry];
    }
}


#pragma mark -

- (MJGObjectCacheEntry*)getCacheEntryForKey:(NSString*)key {
    MJGObjectCacheEntry *entry = [_entriesByKey objectForKey:key];
    if (entry) {
        if ([entry hasExpired]) {
            [self removeCacheEntry:entry];
            return nil;
        } else {
            return entry;
        }
    }
    return nil;
}

- (void)addCacheEntry:(MJGObjectCacheEntry*)entry {
    MJGObjectCacheEntry *existingEntry = [self getCacheEntryForKey:entry.key];
    if (existingEntry) {
        [self removeCacheEntry:existingEntry];
    }
    [_allEntries addObject:entry];
    [_entriesByKey setObject:entry forKey:entry.key];
}

- (void)removeCacheEntry:(MJGObjectCacheEntry*)entry {
    [_allEntries removeObject:entry];
    [_entriesByKey removeObjectForKey:entry.key];
}


#pragma mark -

- (void)loadData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:_cacheFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSMutableData *theData = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
        self.allEntries = [[decoder decodeObjectForKey:@"cache"] mutableCopy];
        [decoder finishDecoding];
    }
    
    if (!_allEntries) {
        self.allEntries = [[NSMutableSet alloc] initWithCapacity:0];
    }
    
    self.entriesByKey = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (MJGObjectCacheEntry *entry in _allEntries) {
        [_entriesByKey setObject:entry forKey:entry.key];
    }
}

- (void)saveData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:_cacheFilename];
    
    NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
    
    [encoder encodeObject:_allEntries forKey:@"cache"];
    [encoder finishEncoding];
    
    [theData writeToFile:path atomically:YES];
}

@end
