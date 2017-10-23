//
//  MZBaseResponse+CommonErrorSolution.h
//  Meixue
//
//  Created by sky on 16/10/26.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseResponse.h"
#import "MZErrorCode.h"

FOUNDATION_EXTERN NSString *const MZErrorOriginDescriptionKey;

@interface MZBaseResponse (CommonErrorSolution)

/**
 处理服务器返回的错误码
 @param error      错误信息
 @param request    网络请求
 @param completion 完成回调，error为空表示错误被修复，否则未修复
 */
+ (void)resolveMZError:(NSError *)error request:(MZBaseRequest *)request completion:(void(^)(NSError *error))completion;

/**
 处理HTTP网络返回的错误码

 @param error      错误信息
 @param request    网络请求
 @param completion 完成回调，error为空表示错误被修复，否则未修复
 */
+ (void)resolveHTTPError:(NSError *)error request:(MZBaseRequest *)request completion:(void(^)(NSError *error))completion;

@end
