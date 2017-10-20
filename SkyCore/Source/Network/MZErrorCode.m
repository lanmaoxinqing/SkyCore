//
//  MZErrorCode.m
//  meizhuang
//
//  Created by shinn on 16/9/21.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZErrorCode.h"

NSString *const MZLocalErrorDomain = @"com.163.mei.error.local";
NSString *const MZLocalSystemErrorMessage = @"系统异常";
NSString *const MZLocalNetworkErrorMessage = @"网络异常";
NSString *const MZRequestErrorDomain = @"com.163.mei.error";


@implementation NSError (MZError)

+ (NSError *)mz_commonLocalSystemErrorWithCode:(MZErrorCode)code {
    return [self mz_requestErrorWithCode:code message:MZLocalSystemErrorMessage];
}

+ (NSError *)mz_commonLocalNetworkErrorWithCode:(MZErrorCode)code {
    return [self mz_requestErrorWithCode:code message:MZLocalNetworkErrorMessage];
}

+(NSError *)mz_commonLocalErrorWithMessage:(NSString *)msg
{
    return [self mz_localErrorWithCode:MZErrorLocalCommonError message:msg];
}

+ (NSError *)mz_localErrorWithCode:(NSInteger)code message:(NSString *)msg {
    return [NSError errorWithDomain:MZLocalErrorDomain
                               code:code
                           userInfo:@{
                                      NSLocalizedDescriptionKey: msg
                                      }];
}

+ (NSError *)mz_requestErrorWithCode:(NSInteger)code message:(NSString *)msg {
    return [NSError errorWithDomain:MZRequestErrorDomain
                               code:code
                           userInfo:@{
                                      NSLocalizedDescriptionKey: msg
                                      }];
}

- (BOOL)isInWhiteList {
    //有自定义错误信息
    NSString *msg = MZLocalMessageForError(self);
    if (msg.length > 0) {
        return YES;
    }
    //服务器错误域
    if ([self.domain isEqualToString:MZRequestErrorDomain]) {
        //400,402,403,404错误需要拼接错误码
        if (self.code == MZErrorResourceInvalidParam ||
            self.code == MZErrorResourceException ||
            self.code == MZErrorResourceError ) {
            return NO;
        }
        return YES;
    }
    //NSURLError域
    else if ([self.domain isEqualToString:NSURLErrorDomain]) {
        //-1009,-1005,-1001不需要拼接错误码
        if (self.code == NSURLErrorTimedOut ||
            self.code == NSURLErrorNetworkConnectionLost ||
            self.code == NSURLErrorNotConnectedToInternet) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)isInFilterList {
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        if (self.code == NSURLErrorCancelled) {
            return YES;
        }
    }
    return NO;
}

NSString *MZLocalMessageForError(NSError *error) {
    if ([error.domain isEqualToString:MZRequestErrorDomain]) {
        NSString *msg = nil;
        switch (error.code) {
            case MZErrorLoginInvalidInitId:
                msg = @"数据请求失败，请稍后重试。\n多次失败建议升级或重装app";
                break;
            default:
                msg = nil;
                break;
        }
        return msg;
    }
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorTimedOut:
                return @"连接超时，请重试";
                break;
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
                return @"网络异常，请重试";
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}


@end

