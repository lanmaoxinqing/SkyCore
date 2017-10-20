//
//  MZRequestTransaction.h
//  Meixue
//
//  Created by hzduanjiashun on 2017/5/27.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZBaseRequest, MZRequestTransactionGroup;

/**
 合并多个请求为同一事务，会同步返回结果
 */
@interface MZRequestTransaction : NSObject

+ (instancetype)sharedTrasaction;

+ (void)perform:(void (NS_NOESCAPE ^)())block;
/**
 合并请求

 @param block block内同步开始的请求会自动合并，请求回调会同步执行
 @param complete complete会在所有请求回调执行完成后执行
 */
+ (void)perform:(void (NS_NOESCAPE ^)())block complete:(void (^)())complete;

// Private
- (MZRequestTransactionGroup *)currentTransactionGroup;
- (void)requestSignalFinish:(MZBaseRequest *)request;

@end


@interface MZRequestTransactionGroup : NSObject

- (void)addRequest:(MZBaseRequest *)request;

@end
