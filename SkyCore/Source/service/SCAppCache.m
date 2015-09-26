//
//  AppCache.m
//  baseFrame-v2
//
//  Created by sky on 13-5-30.
//  Copyright (c) 2013年 teemax. All rights reserved.
//

#import "SCAppCache.h"
#import "SCBaseDao.h"
#import "SCSysconfig.h"
#import "SCFileOper.h"

static NSMutableDictionary *_cacheDic;

@interface SCAppCache(Private)

+(NSMutableDictionary *)cacheDic;

@end

@implementation SCAppCache

#pragma mark - 临时缓存(退出应用后消失)
+(id)cacheValueForKey:(SCCacheKey)key{
    return [[self cacheDic] valueForKey:[NSString stringWithFormat:@"%d",key]];
}

+(void)setCacheValue:(id)value forKey:(SCCacheKey)key{
    [[self cacheDic] setObject:value forKey:[NSString stringWithFormat:@"%d",key]];
}

+(void)deleteCacheForKey:(SCCacheKey)key{
    [[self cacheDic] removeObjectForKey:[NSString stringWithFormat:@"%d",key]];
}

#pragma mark - 字段持久缓存(保存在数据库)
+(NSString *)storeValueForKey:(SCStoreKey)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:[@(key) stringValue]];
}

+(void)setStoreValue:(NSString *)value forKey:(SCStoreKey)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:[@(key) stringValue]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)deleteStoreValueForKey:(SCStoreKey)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[@(key) stringValue]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 对象持久缓存(保存在本地文件)
+(void)setStoreObject:(NSObject<NSCoding> *)obj forKey:(SCObjectKey)key{
    NSString *path=[SCSysconfig filePathByName:[NSString stringWithFormat:@"%d.domain",key]];
    [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

+(NSObject<NSCoding> *)storeObjectForKey:(SCObjectKey)key{
    NSString *path=[SCSysconfig filePathByName:[NSString stringWithFormat:@"%d.domain",key]];
    NSObject<NSCoding> *obj=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return obj;
}

+(void)deleteStoreObjectForKey:(SCObjectKey)key{
    NSString *path=[SCSysconfig filePathByName:[NSString stringWithFormat:@"%d.domain",key]];
    [SCFileOper removeFile:path];
}

#pragma mark - 清除数据更新缓存
+(void)clearCache{
    [_cacheDic removeAllObjects];
    [SCFileOper removeFolder:kRootFolder];
}

#pragma mark - private method
+(NSMutableDictionary *)cacheDic{
    if(_cacheDic==nil){
        _cacheDic=[NSMutableDictionary new];
    }
    return _cacheDic;
}

@end
