//
//  NSObject+NotNull.h
//  hostel-iphone
//
//  Created by liu ding on 12-7-12.
//  Copyright 2012年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(NotNull)
/**
 *  数据非空判断,字符串数组字典如已初始化,但内容为空,判断为YES
 *
 *  @return 是否为空
 */
-(BOOL) isNotNull;
/**
 *  数据内容非空判断,字符串数组字典如已初始化,但内容为空,判断为NO
 *
 *  @return 是否为空
 */
-(BOOL) isNotEmpty;
@end
