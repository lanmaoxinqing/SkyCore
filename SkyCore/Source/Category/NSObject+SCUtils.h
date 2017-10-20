//
//  NSObject+SCUtils.h
//  SkyCore
//
//  Created by 心情 on 2017/10/20.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(NotNull)
/**
 *  数据非空判断,字符串数组字典如已初始化,但内容为空,判断为YES
 *
 *  @return 是否为空
 */
- (BOOL)sc_isNotNull;
/**
 *  数据内容非空判断,字符串数组字典如已初始化,但内容为空,判断为NO
 *
 *  @return 是否为空
 */
- (BOOL)sc_isNotEmpty;

@end

@interface NSObject (PropertyClass)

- (Class)sc_classOfProperty:(NSString *)propertyName;
+ (Class)sc_classOfProperty:(NSString *)propertyName;

@end

@interface NSObject (NotificationCenter)

/**
 *  使用 block 监听一个通知，自动释放 block，但是 block 中引用 self 需要 weakify.
 *  @warning      同一个 name + object 只能有一个 block（最后一个）
 *
 *  @param name   通知名
 *  @param object 监听的实例，为 nil ，监听所有实例
 *  @param queue  回调的队列
 *  @param block  回调 block
 */
- (void)observeNotificationName:(NSString *)name object:(id)object inQueue:(NSOperationQueue *)queue usingBlock:(void(^)(NSNotification * noti))block;
- (void)observeNotificationName:(NSString *)name object:(id)object usingBlock:(void(^)(NSNotification *noti))block;
- (void)unobserveNotificationName:(NSString *)name object:(id)object;
@end

