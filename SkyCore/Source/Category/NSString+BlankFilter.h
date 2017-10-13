//
//  NSString+BlankFilter.h
//  iMis-iphone
//
//  Created by sky on 14-5-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BlankFilter)


/**
	对空格和Tab进行合并，将合并后的字符串去除首尾空格，然后按空格分割
	@returns 分割好的数组
 */
-(NSArray *)componentsSeparatedByBlank;

/**
	合并空格和Tab制表符为1个空格
	@returns 合并后的字符串
 */
-(NSString *)stringByMergeBlank;

/**
 过滤两端空格和Tab制表符
 @returns 过滤后的字符串
 */
-(NSString *)stringbyTrimmingBlank;

/**
	删除字符串中的空格和Tab制表符
	@returns 删除后的字符串
 */
-(NSString *)stringByDeletingBlank;

@end
