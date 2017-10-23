//
//  MZRequestGroup.m
//  meizhuang
//
//  Created by Ricky on 16/6/7.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZRequestGroup.h"


@interface MZRequestGroup ()
@property (strong) NSMutableArray <__kindof MZBaseRequest *> *finishedRequests;
@property (strong) NSMutableArray <__kindof MZBaseRequest *> *pendingRequests;
@property (strong) NSLock *lock;
@end

@implementation MZRequestGroup
@dynamic response;

+ (instancetype)requestWithRequests:(MZBaseRequest *)request, ...
{
    MZRequestGroup *group = [[self alloc] init];
    if (group) {
        va_list param;
        va_start(param, request);
        MZBaseRequest *value = va_arg(param, MZBaseRequest *);
        NSMutableArray *array = [NSMutableArray arrayWithObject:request];
        while (value) {
            [array addObject:value];
            value = va_arg(param, MZBaseRequest *);
        }
        va_end(param);
        
        group.requests = [NSArray arrayWithArray:array];
    }
    return group;
}

//+ (dispatch_queue_t)groupRequestQueue
//{
//    static dispatch_once_t onceToken;
//    static dispatch_queue_t queue = NULL;
//    dispatch_once(&onceToken, ^{
//        queue = dispatch_queue_create("com.163.mei.request.group.queue", DISPATCH_QUEUE_CONCURRENT);
//    });
//    return queue;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (__kindof MZBaseRequest *)objectAtIndexedSubscript:(NSUInteger)index
{
    return self.requests[index];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)startWithBlock:(void (^)(MZRequestGroup *, NSError *))aBlock
{
    __block void(^block)(MZRequestGroup *, NSError *) = aBlock ?: ^(MZRequestGroup * __unused group, NSError * __unused error) {};
    
    self.pendingRequests = [NSMutableArray arrayWithArray:self.requests];
    self.finishedRequests = [NSMutableArray arrayWithCapacity:self.requests.count];
    
    [self.requests enumerateObjectsUsingBlock:^(MZBaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startWithBlock:^(__kindof MZBaseRequest *request, NSError *error) {
            if (error) {
                [self.pendingRequests makeObjectsPerformSelector:@selector(cancel)];
                [self.lock lock];
                if (block)
                    block(self, error);
                block = nil;
                [self.lock unlock];
            }
            else {
                [self.lock lock];
                [self.pendingRequests removeObject:obj];
                [self.finishedRequests addObject:obj];
                [self.lock unlock];
                
                if (self.pendingRequests.count == 0) {
                    block(self, nil);
                }
            }
        }];
    }];
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_leave(group);
//    dispatch_group_enter(group);
//    dispatch_group_notify(group, [MZRequestGroup groupRequestQueue], ^{
//    });
}
#pragma clang diagnostic pop

- (void)startWithContinueRequestsWhenErrorOccurs:(void (^)(MZRequestGroup *, BOOL successful, NSArray *successRequests, NSArray *failureRequests))block
{
    block = block ?: ^(MZRequestGroup * __unused group, BOOL successful, NSArray *finishedRequests, NSArray *failureRequests) {};
    
    self.pendingRequests = [NSMutableArray arrayWithArray:self.requests];
    self.finishedRequests = [NSMutableArray arrayWithCapacity:self.requests.count];
    
    __block NSMutableArray <__kindof MZBaseRequest *> *failureRequests = [NSMutableArray arrayWithCapacity:self.requests.count];
    __block NSMutableArray <__kindof MZBaseRequest *> *successRequests = [NSMutableArray arrayWithCapacity:self.requests.count];
    
    [self.requests enumerateObjectsUsingBlock:^(MZBaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startWithBlock:^(__kindof MZBaseRequest *request, NSError *error) {
            if (error) {
                [self.lock lock];
                [self.pendingRequests removeObject:obj];
                [self.finishedRequests addObject:obj];
                [failureRequests addObject:obj];
                // if contains
                [successRequests removeObject:obj];
                [self.lock unlock];
            }
            else {
                [self.lock lock];
                [self.pendingRequests removeObject:obj];
                [self.finishedRequests addObject:obj];
                // if contains
                [failureRequests removeObject:obj];
                [successRequests addObject:obj];
                [self.lock unlock];
            }
            
            if (self.pendingRequests.count == 0) {
                block(self, failureRequests.count == 0, successRequests, failureRequests);
            }
        }];
    }];
    
}

- (__kindof MZBaseRequest *)cancel
{
    [self.pendingRequests makeObjectsPerformSelector:@selector(cancel)];
    return self;
}

@end
