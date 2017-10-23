//
//  MZRequestCache.h
//  Meixue
//
//  Created by 郑志勤 on 16/10/21.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBaseRequest.h"

@protocol MZRequestCacheItem <NSObject>

@property (nonatomic, strong, nullable, readonly) NSData *data;
@property (nonatomic, strong, nullable, readonly) NSDate *createDate;

@end

@interface MZRequestCache : NSObject

+ (nonnull instancetype)sharedCache;

- (nullable NSString *)cacheKeyForRequest:(nonnull MZBaseRequest *)request;

- (void)setCache:(nullable NSData *)data forKey:(nonnull NSString *)key;
- (nullable NSData *)cacheForKey:(nonnull NSString *)key;

- (void)setCache:(nullable NSData *)data forRequest:(nonnull MZBaseRequest *)request;
- (nullable NSData *)cacheForRequest:(nonnull MZBaseRequest *)request;

@end

@interface MZRequestCache (ExpireSupport)

- (nullable id<MZRequestCacheItem>)cacheItemForKey:(nonnull NSString *)key;
/**
 根据请求返回有效缓存,如果缓存时间超过`request.cacheValidateTime`,则返回nil
 @param request 请求
 @return 缓存结果
 */
- (nullable id<MZRequestCacheItem>)cacheItemForRequest:(nonnull MZBaseRequest *)request;

@end
