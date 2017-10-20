//
//  MZListResponse.h
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseResponse.h"
#import "MZListEntity.h"

@interface MZListResponse<ResponseEntityType> : MZBaseResponse

@property (nonatomic, strong) MZListEntity<ResponseEntityType> *listEntity;
/**
 *  是否有下一页
 */
@property (nonatomic, readonly) BOOL hasNext DEPRECATED_MSG_ATTRIBUTE("Use `listEntity.hasNext` instead");

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

@end
