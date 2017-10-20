//
//  MZBaseResponse+CommonErrorSolution.m
//  Meixue
//
//  Created by sky on 16/10/26.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseResponse+CommonErrorSolution.h"
#import "MZErrorCode.h"
#import "MZBaseRequest.h"
//#import "MZInitAppRequest.h"

#define MZDefaultRequestRetryCount 3

NSString *const MZErrorOriginDescriptionKey = @"MZErrorOriginDescriptionKey";

@implementation MZBaseResponse (CommonErrorSolution)

//static int __initId_retry_count = 0;
+ (void)resolveMZError:(NSError *)error request:(MZBaseRequest *)request completion:(void (^)(NSError *))completion {
    if (!error) {
        completion(error);
        return;
    }
    
    //重发请求
    if ([self resendIfNeeded:error request:request]) {
        return;
    }
    
    //优先使用本地定义错误文案
    NSString *msg = MZLocalMessageForError(error);
    //使用服务器文案
    if (msg.length == 0) {
        msg = error.localizedDescription;
    }
    //默认文案
    if (msg.length == 0) {
        msg = MZLocalNetworkErrorMessage;
    }
    //不在白名单,拼上错误码
    NSString *newMsg = msg;
    if (![error isInWhiteList]) {
        newMsg = [msg stringByAppendingFormat:@" (%zd)", error.code];
    }
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
    if (msg.length)
        [userInfo setObject:msg forKey:MZErrorOriginDescriptionKey];
    if (newMsg.length)
        [userInfo setObject:newMsg forKey:NSLocalizedDescriptionKey];
    NSError *resultError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
    completion(resultError);
}

+ (void)resolveHTTPError:(NSError *)error request:(MZBaseRequest *)request completion:(void (^)(NSError *))completion {
    if (!error) {
        completion(nil);
        return;
    }
    //重发请求
    if ([self resendIfNeeded:error request:request]) {
        return;
    }
    NSString *msg = nil, *newMsg = nil;
    //过滤名单中的错误信息不显示
    if ([error isInFilterList]) {
        msg = @"";
    }
    else {
        //优先使用本地定义错误文案
        msg = MZLocalMessageForError(error);
        //使用默认文案
        if (msg.length == 0) {
            newMsg = msg = @"网络异常，请重试";
        }
        //不在白名单,拼上错误码
        if (![error isInWhiteList]) {
            newMsg = [msg stringByAppendingFormat:@" (%zd)",error.code];
        }
    }
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
    if (msg.length)
        [userInfo setObject:msg forKey:MZErrorOriginDescriptionKey];
    if (newMsg.length)
        [userInfo setObject:newMsg forKey:NSLocalizedDescriptionKey];
    NSError *resultError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
    completion(resultError);
}

/**
 根据错误码重发请求

 @param error   错误
 @param request 请求

 @return 已重发
 */
+ (BOOL)resendIfNeeded:(NSError *)error request:(__kindof MZBaseRequest *)request {
//    //应用内需要重试的网络异常
//    if (error.domain == MZRequestErrorDomain) {
//        //initId出错，请求initId后重发请求
//        if (error.code == MZErrorLoginInvalidInitId) {
//            if (__initId_retry_count >= MZDefaultRequestRetryCount) {
//                __initId_retry_count = 0;
//                return NO;
//            }
//            __initId_retry_count ++;
//            MZInitAppRequest *appRequest = [[MZInitAppRequest alloc] init];
//            [appRequest startWithBlock:^(MZInitAppRequest *appRequest, NSError *error) {
//                [request resend];
//            }];
//            return YES;
//        }
//        return NO;
//    }
    //HTTP需要重试的常见网络异常(超时)
    if ([@[NSURLErrorDomain, NSPOSIXErrorDomain, AFURLResponseSerializationErrorDomain] containsObject:error.domain]) {
        if (error.code == NSURLErrorNetworkConnectionLost ||
            error.code == NSURLErrorTimedOut ||
            error.code == NSURLErrorBadServerResponse ||
            error.code == NSURLErrorConnectionResetByPeer ||
            error.code == NSURLErrorSecureConnectionFailed) {
            // 只有 GET 这种幂等操作才能重试！！！
            if (request.method == MZRequestMethodGet && request.retryCount < MZDefaultRequestRetryCount) {
                [request resend];
                return YES;
            }
        }
    }
    return NO;
}

@end
