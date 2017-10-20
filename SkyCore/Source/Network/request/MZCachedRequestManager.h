//
//  MZRequestCacheManager.h
//  Meixue
//
//  Created by sky on 2017/3/7.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "MZRequestManager.h"
#import "MZRequestCache.h"

@interface MZCachedRequestManager : MZRequestManager

@end


@interface MZRequestCache (Manager)

+ (__kindof MZBaseResponse *)cacheResponseForRequest:(MZBaseRequest *)request;
- (__kindof MZBaseResponse *)cacheResponseForRequest:(MZBaseRequest *)request;

@end
