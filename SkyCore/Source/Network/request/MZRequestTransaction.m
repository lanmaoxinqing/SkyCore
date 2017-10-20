//
//  MZRequestTransaction.m
//  Meixue
//
//  Created by hzduanjiashun on 2017/5/27.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <pthread/pthread.h>

#import "MZRequestTransaction.h"
#import "MZBaseRequest.h"


@interface MZBaseRequest (block)

@property (nonatomic, copy) MZRequestBlock errorBlock;
@property (nonatomic, copy) MZRequestBlock responseBlock;
@property (nonatomic, copy) MZRequestBlock finishBlock;

@end


@interface MZRequestTransactionGroup ()
@property (nonatomic, copy) dispatch_block_t completeBlock;

- (BOOL)isValidate;
- (BOOL)isAllInvoked;
- (void)finish;

- (BOOL)requestSignalFinish:(MZBaseRequest *)request;
@end

@implementation MZRequestTransaction {
    // 当前的transaction，以线程id来区分，便于在block中全局获取
    NSMutableDictionary<NSNumber *, MZRequestTransactionGroup *> *_currentTransactions;
    // 所有transaction
    NSMutableArray<MZRequestTransactionGroup *> *_allTransactions;
    pthread_mutex_t _lock;
    
    // 将所有信号都放到一个线程中响应，可以避免多线程同步问题
    NSOperationQueue *_signalQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentTransactions = [NSMutableDictionary new];
        _allTransactions = [NSMutableArray new];
        pthread_mutex_init(&_lock, NULL);
        _signalQueue = [[NSOperationQueue alloc] init];
        _signalQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

+ (instancetype)sharedTrasaction {
    static MZRequestTransaction *transaction;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transaction = [MZRequestTransaction new];
    });
    return transaction;
}

+ (void)perform:(void (^)())block {
    [[self sharedTrasaction] perform:block complete:NULL];
}

+ (void)perform:(void (^)())block complete:(void (^)())complete {
    [[self sharedTrasaction] perform:block complete:complete];
}

- (void)perform:(void (^)())block complete:(dispatch_block_t)complete {
    pthread_mutex_lock(&_lock);
    
    NSInteger machPort = pthread_mach_thread_np(pthread_self());
    MZRequestTransactionGroup *group = _currentTransactions[@(machPort)];
    if (group) {
        NSAssert(false, @"Can not perform a transaction in another transaction!");
        return;
    }
    group = [MZRequestTransactionGroup new];
    group.completeBlock = complete;
    
    _currentTransactions[@(machPort)] = group;
    if (block) block();
    if (group.isValidate) {
        [_allTransactions addObject:group];
    }
    _currentTransactions[@(machPort)] = nil;
    
    pthread_mutex_unlock(&_lock);
}

- (MZRequestTransactionGroup *)currentTransactionGroup {
    NSInteger machPort = pthread_mach_thread_np(pthread_self());
    MZRequestTransactionGroup *group = _currentTransactions[@(machPort)];
    
    return group;
}

- (void)requestSignalFinish:(MZBaseRequest *)request {
    [_signalQueue addOperationWithBlock:^{
        __block BOOL signaledAtAll = NO;
        __block MZRequestTransactionGroup *group = nil;
        
        pthread_mutex_lock(&self->_lock);
        [self->_allTransactions enumerateObjectsUsingBlock:^(MZRequestTransactionGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj requestSignalFinish:request]) {
                *stop = YES;
                signaledAtAll = YES;
                group = obj;
            }
        }];
        
        if (signaledAtAll) {
            if (group.isAllInvoked) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [group finish];
                });
                
                [self->_allTransactions removeObject:group];
            }
        }
        else {
            NSAssert(false, @"No group found! It must be some Error!");
        }
        pthread_mutex_unlock(&self->_lock);
    }];
    
}

@end


@interface MZRequestTransactionItem : NSObject

@property (strong, nonatomic) MZBaseRequest *request;

@property (nonatomic, copy) MZRequestBlock finishBlock;

@property (assign, nonatomic) BOOL invoked;

@end

@implementation MZRequestTransactionItem

@end

@implementation MZRequestTransactionGroup {
    NSMutableArray<MZRequestTransactionItem *> *_items;
    pthread_mutex_t _lock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
}

- (void)addRequest:(MZBaseRequest *)request {
    MZRequestTransactionItem *item = [MZRequestTransactionItem new];
    item.request = request;
    item.finishBlock = request.finishBlock;
    pthread_mutex_lock(&_lock);
    [_items addObject:item];
    pthread_mutex_unlock(&_lock);
}

- (BOOL)isValidate {
    return _items.count != 0;
}

- (BOOL)isAllInvoked {
    BOOL invoked = YES;
    pthread_mutex_lock(&_lock);
    for (MZRequestTransactionItem *item in _items) {
        if (!item.invoked) {
            invoked = NO;
            break;
        }
    }
    pthread_mutex_unlock(&_lock);
    return invoked;
}

- (void)finish {
    if (self.isAllInvoked) {
        pthread_mutex_lock(&_lock);
        for (MZRequestTransactionItem *item in _items) {
            if (item.finishBlock) item.finishBlock(item.request, item.request.error);
        }
        pthread_mutex_unlock(&_lock);
        if (self.completeBlock) {
            self.completeBlock();
        }
    }
}

- (BOOL)requestSignalFinish:(MZBaseRequest *)request {
    BOOL signaled = NO;
    pthread_mutex_lock(&_lock);
    for (MZRequestTransactionItem *item in _items) {
        if (item.request == request) {
            item.invoked = YES;
            signaled = YES;
            break;
        }
    }
    pthread_mutex_unlock(&_lock);
    return signaled;
}

@end
