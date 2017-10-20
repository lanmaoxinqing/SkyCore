//
//  MZRequestGroup.h
//  meizhuang
//
//  Created by Ricky on 16/6/7.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseRequest.h"


typedef void(^MZRequestGroupBlock)(NSArray<__kindof MZBaseRequest *> *requests, NSError *error);

@interface MZRequestGroup : MZBaseRequest
@property (nonatomic, strong) NSArray<__kindof MZBaseRequest *> *requests;

+ (instancetype)requestWithRequests:(__kindof MZBaseRequest *)request, ...;

- (void)startWithBlock:(void(^)(MZRequestGroup * group, NSError * error))block;

/**
 *  当请求组里面某个请求失败后，会继续剩下的请求
 *
 *  @param block <#block description#>
 */
- (void)startWithContinueRequestsWhenErrorOccurs:(void (^)(MZRequestGroup *group, BOOL successful, NSArray *successRequests, NSArray *failureRequests))block;

- (__kindof MZBaseRequest *)objectAtIndexedSubscript:(NSUInteger)index;

@end
