//
//  MZRequestCache.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/21.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZRequestCache.h"
#import "SCStore.h"
#import "NSString+MD5.h"

@interface SCStoreFile (MZRequestCacheItem)<MZRequestCacheItem>

@end

@implementation SCStoreFile (MZRequestCacheItem)

- (NSDate *)createDate {
    return self.lastModifyDate;
}

@end

@interface MZRequestCache ()

@property (nonatomic, strong) dispatch_queue_t saveQueue;


@end

@implementation MZRequestCache

+ (instancetype)sharedCache {
    static dispatch_once_t onceToken;
    static MZRequestCache *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[MZRequestCache alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _saveQueue = dispatch_queue_create("com.netease.meixue.MZRequestCache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSString *)cacheKeyForRequest:(MZBaseRequest *)request
{
    NSString *path = [request path];
    NSString *originalKey = path;
    id parameters = request.parameters;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [((NSDictionary *)parameters).allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        NSMutableString *paramStr = [NSMutableString new];
        for (NSString *key in keys) {
            if (paramStr.length > 0) {
                [paramStr appendString:@"&"];
            }
            [paramStr appendString:[NSString stringWithFormat:@"%@=%@", keys, parameters[key]]];
        }
        if (paramStr.length > 0) {
            originalKey = [NSString stringWithFormat:@"%@?%@", path, paramStr];
        }
    }
    return [NSString stringWithFormat:@"%@", originalKey.MD5];
}

- (void)setCache:(NSData *)data forKey:(NSString *)key
{
    [self cacheData:data forKey:key];
}

- (void)setCache:(NSData *)data forRequest:(MZBaseRequest *)request
{
    [self cacheData:data forKey:[self cacheKeyForRequest:request]];
}

- (NSData *)cacheForKey:(NSString *)key
{
    id<MZRequestCacheItem> item = [self cacheItemForKey:key];
    return item.data;
}

- (NSData *)cacheForRequest:(MZBaseRequest *)request
{
    return [self cacheItemForRequest:request].data;
}

- (void)cacheData:(id)data forKey:(NSString *)key {
    NSData *d = nil;
    if ([data isKindOfClass:[NSString class]]
        || [data isKindOfClass:[NSDictionary class]]
        || [data isKindOfClass:[NSArray class]]) {
        d = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    } else if ([data isKindOfClass:[NSData class]]) {
        d = data;
    }
    dispatch_async(self.saveQueue, ^{
        if (d && key) {
            [[SCStore defaultStore] file_setData:d forKey:key];
        }
    });
}

@end


@implementation MZRequestCache (ExpireSupport)

- (id<MZRequestCacheItem>)cacheItemForKey:(NSString *)key {
    return [[SCStore defaultStore] file_storeFileForKey:key];
}

- (id<MZRequestCacheItem>)cacheItemForRequest:(MZBaseRequest *)request {
    id<MZRequestCacheItem> entity = [self cacheItemForKey:[self cacheKeyForRequest:request]];
    if ([[NSDate date] timeIntervalSinceDate:entity.createDate] < request.cacheValidateTime) {
        return entity;
    }
    return nil;
}

@end
