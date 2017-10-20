//
//  MZListRequest.m
//  meizhuang
//
//  Created by Ricky on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZListRequest.h"


@implementation MZOffsetPagedListRequest
@dynamic response;

+ (Class)responseClass
{
    return [MZListResponse class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limit = 10;
        self.offset = 0;
    }
    return self;
}

- (id)parameters
{
    return [super parameters];
}

@end

//@implementation MZTimestampBasedListRequest
//
//@dynamic response;
//
//+ (Class)responseClass
//{
//    return [MZListResponse class];
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.createTime = @"0";
//        self.count = 10;
//    }
//    return self;
//}
//
//- (id)parameters
//{
//    return @{@"createTime": self.createTime,
//             @"count": @(self.count)};
//}
//
//
//@end

@implementation MZIdPagedListRequest

@dynamic response;

+ (Class)responseClass
{
    return [MZIdPagedListResponse class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageEndId = @"0";
        self.count = 10;
    }
    return self;
}

- (id)parameters
{
    NSMutableDictionary *baseParams = [[super parameters] mutableCopy];
    if (!baseParams) {
        baseParams = [NSMutableDictionary new];
        [baseParams setObject:@(self.count) forKey:@"count"];
    }
    [baseParams setObject:self.pageEndId ?: @"0" forKey:@"pageEndId"];
    
    id appendedParams = [self appendedParams];
    if ([appendedParams isKindOfClass:[NSDictionary class]] && [appendedParams allKeys].count) {
        [baseParams addEntriesFromDictionary:[self appendedParams]];
    }
    
    return [baseParams copy];
}

- (id)appendedParams
{
    return @{};
}

@end

