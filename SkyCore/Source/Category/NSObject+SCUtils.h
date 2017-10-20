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


