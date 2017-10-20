//
//  MZRequestCacheManager.m
//  Meixue
//
//  Created by sky on 2017/3/7.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "MZCachedRequestManager.h"
#import "MZBaseRequest.h"
#import "MZErrorCode.h"

@implementation MZCachedRequestManager

- (void)startRequest:(MZBaseRequest *)request withBlock:(MZRequestBlock)block {
    switch (request.cachePolicy) {
        case MZRequestCachePolicyReturnCacheAndRefreshCache:
        {
            NSData *responseData = [[MZRequestCache sharedCache] cacheForRequest:request];
            //有缓存，往下请求
            if (responseData) {
                void (^successBlock)(id,BOOL) = [self successCallbackForRequest:request block:block];
                successBlock(responseData, YES);
                block = NULL;
            }
            // 无缓存，往下请求
            break;
        }
        case MZRequestCachePolicyReturnCacheDataElseLoad:
        {
            NSData *responseData = [[MZRequestCache sharedCache] cacheForRequest:request];
            //有缓存，返回
            if (responseData) {
                void (^successBlock)(id,BOOL) = [self successCallbackForRequest:request block:block];
                successBlock(responseData, YES);
                return;
            }
            // 无缓存，往下请求
            break;
        }
        case MZRequestCachePolicyReturnLoadElseCacheData:
        {
            break;
        }
        case MZRequestCachePolicyIgnoringLoad:
        {
            NSData *responseData = [[MZRequestCache sharedCache] cacheForRequest:request];
            //有缓存，返回
            if (responseData) {
                void (^successBlock)(id,BOOL) = [self successCallbackForRequest:request block:block];
                successBlock(responseData, YES);
                return;
            }
            // 无缓存，报错，返回
            else {
                NSError *error = [NSError mz_commonLocalErrorWithMessage:MZLocalNetworkErrorMessage];
                block(request, error);
                return;
            }
            break;
        }
        case MZRequestCachePolicyIgnoringCacheData:
            break;
        default:
            break;
    }
    
    MZRequestBlock interruptBlock = ^(MZBaseRequest *request, NSError *error) {
        //没出错，记录缓存
        if (!error && (request.cachePolicy != MZRequestCachePolicyIgnoringCacheData)) {
            [[MZRequestCache sharedCache] setCache:request.response.responseData forRequest:request];
        }
        //网络请求有错误，使用缓存
        else if(error.code != NSURLErrorCancelled && request.cachePolicy == MZRequestCachePolicyReturnLoadElseCacheData) {
            NSData *responseData = [[MZRequestCache sharedCache] cacheForRequest:request];
            if (responseData) {
                void (^successBlock)(id,BOOL) = [self successCallbackForRequest:request block:block];
                successBlock(responseData, YES);
                return;
            }
        }
        !block ?: block(request, error);
    };
    //开始网络请求
    [super startRequest:request withBlock:interruptBlock];
}

@end

@implementation MZRequestCache (Manager)

- (MZBaseResponse *)cacheResponseForRequest:(MZBaseRequest *)request {
    NSData *data = [self cacheForRequest:request];
    if (!data) {
        return nil;
    }
    MZBaseRequest *resultRequest = [[MZCachedRequestManager defaultManger] request:request serializeResponse:data];
    return resultRequest.response;
}

+ (MZBaseResponse *)cacheResponseForRequest:(MZBaseRequest *)request {
    return [[MZRequestCache sharedCache] cacheResponseForRequest:request];
}

@end
