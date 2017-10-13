//
//  AppCache.h
//  baseFrame-v2
//
//  Created by sky on 13-5-30.
//  Copyright (c) 2013年 teemax. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
	临时缓存,应用关闭后消失
 */
typedef enum {
	CacheKeyMember=10010,	/** Member对象 */
	CacheKeyLocation,	/** CLLocation对象 */
    CacheKeyTokenId,
}SCCacheKey;
/**
    字段持久缓存,保存在文件
 */
typedef enum{
    StoreKeyMemberId=10010, //会员ID
    StoreKeyAppId,          //应用ID
    StoreKeyCityId,         //城市ID
    StoreKeyAutoUpdate,     //软件更新提示,0关闭,1开启
}SCStoreKey;

/**
    对象序列化缓存,保存在文件
 */
typedef enum {
    ObjectKeyMember=10010,
}SCObjectKey;

/**
	系统缓存
	@author sky
 */
@interface SCAppCache : NSObject

#pragma mark - 临时缓存(退出应用后消失)
/**
	获取临时缓存
	@param key 索引
	@returns 缓存对象
 */
+(id)cacheValueForKey:(SCCacheKey)key;
/**
	设置临时缓存
	@param value 缓存对象
	@param key 索引
 */
+(void)setCacheValue:(id)value forKey:(SCCacheKey)key;
/**
	删除临时缓存
	@param key 索引
 */
+(void)deleteCacheForKey:(SCCacheKey)key;

#pragma mark - 字段持久缓存(保存在数据库)
/**
	获取持久缓存
	@param key 索引
	@returns 缓存字符串
 */
+(NSString *)storeValueForKey:(SCStoreKey)key;
/**
	设置持久缓存
	@param value 缓存字符串
	@param key 索引
 */
+(void)setStoreValue:(NSString *)value forKey:(SCStoreKey)key;

/**
 删除持久缓存
 @param key 索引
 */
+(void)deleteStoreValueForKey:(SCStoreKey)key;

#pragma mark - 对象持久缓存(保存在本地文件)
/**
	本地持久化序列化对象
	@param obj      序列化对象
	@param key      索引
 */
+(void)setStoreObject:(NSObject<NSCoding> *)obj forKey:(SCObjectKey)key;

/**
	读取序列化对象
	@param key 索引
	@returns 序列化对象
 */
+(NSObject<NSCoding> *)storeObjectForKey:(SCObjectKey)key;
/**
	删除序列化对象
	@param key 索引
 */
+(void)deleteStoreObjectForKey:(SCObjectKey)key;

#pragma mark - 清除应用缓存
/**
	清除应用缓存
 */
+(void)clearCache;

@end
