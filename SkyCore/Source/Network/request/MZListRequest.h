//
//  MZListRequest.h
//  meizhuang
//
//  Created by Ricky on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseRequest.h"
#import "MZListResponse.h"

//------------------------------------------------------
//@interface MZListResponse <T> : MZBaseResponse
//@property (nonatomic, strong) MZListEntity<T> *listEntity;
//
///**
// *  是否有下一页
// */
//@property (nonatomic, assign) BOOL hasNext;
//// override point
//+ (Class)entityClass;
//
//@end

/**
 *  基于offset-limit的传统分页方式, 目前搜索等接口仍然使用
 */
@interface MZOffsetPagedListRequest : MZBaseRequest
@property (nonatomic, readonly, strong) __kindof MZListResponse *response;
@property (nonatomic, assign) NSUInteger offset, limit;

- (id)parameters NS_REQUIRES_SUPER;
@end

//------------------------------------------------------

// Alias of MZListResponse
@compatibility_alias MZIdPagedListResponse MZListResponse;

/**
 *  基于pageEndId做的分页基类
 */
@interface MZIdPagedListRequest : MZBaseRequest

@property (nonatomic, readonly, strong) __kindof MZIdPagedListResponse *response;
@property (nonatomic, copy) NSString *pageEndId;
@property (nonatomic, assign) NSUInteger count;

- (id)parameters NS_REQUIRES_SUPER;
/**
 *  由于父类本身需要一些参数字段做分页，因此提供一个append方法来做子类添加的参数。
 *  如果完全不想要父类参数，请重写parameters方法全部覆盖。

 */
- (id)appendedParams;

@end
//------------------------------------------------------
///**
// *  基于createTime做的分页基类
// */
//@interface MZTimestampBasedListRequest : MZBaseRequest
//
//@property (nonatomic, readonly, strong) MZListResponse *response;
//@property (nonatomic, copy) NSString *createTime;
//@property (nonatomic, assign) NSInteger count;
//
//@end
