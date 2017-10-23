//
//  MZRequestQueue.m
//  meizhuang
//
//  Created by hzduanjiashun on 16/8/29.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZRequestQueue.h"

@interface MZRequestQueue ()

@end

@implementation MZRequestQueue {
    NSMutableArray<MZBaseRequest *> *_queue;
    BOOL _executing;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [NSMutableArray new];
    }
    return self;
}

- (void)requestIfNeed {
    if (_queue.firstObject && !_executing) {
        _executing = YES;
        MZBaseRequest *req = _queue.firstObject;
        [req startWithBlock:^(__kindof MZBaseRequest *request, NSError *error) {
            if ([NSThread currentThread].isMainThread) {
                self->_executing = NO;
                [self->_queue removeObjectAtIndex:0];
                [self requestIfNeed];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_executing = NO;
                    [self->_queue removeObjectAtIndex:0];
                    [self requestIfNeed];
                });
            }
        }];
    }
}

- (void)addRequest:(MZBaseRequest *)req {
    if ([NSThread currentThread].isMainThread) {
        [_queue addObject:req];
        [self requestIfNeed];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_queue addObject:req];
            [self requestIfNeed];
        });
    }
}

@end
