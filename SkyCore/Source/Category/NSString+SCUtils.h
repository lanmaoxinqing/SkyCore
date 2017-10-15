//
//  NSString+SCUtils.h
//  SkyCore
//
//  Created by sky on 2017/10/14.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BlankFilter)
/**
 对空格和Tab进行合并，将合并后的字符串去除首尾空格，然后按空格分割
 @returns 分割好的数组
 */
- (NSArray *)componentsSeparatedByBlank;
/**
 合并空格和Tab制表符为1个空格
 @returns 合并后的字符串
 */
- (NSString *)stringByMergeBlank;
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
/**
 *  合并多个连续空格为一个，多个连续回车为一个
 *  @code
 *  @"abc    d\n\ne\n\n  g" 为 @"abc d\ne\n g"
 *  @endcode
 *  @return 新的字符串
 */
- (NSString *)sc_stringByMergeContinuousWhiteSpaceAndNewline __attribute__((const));

/**
 *  合并多个连续回车为一个
 *
 *  @return 新的字符串
 */
- (NSString *)sc_stringByMergeContinuousNewline __attribute__((const));

/**
 *  合并多个连续空格或回车为一个空格
 *
 *  @return 新的字符串
 */
- (NSString *)sc_stringByMergeContinuousWhiteSpaceOrNewline __attribute__((const));

- (NSString *)sc_trim __attribute__((const));

/**
 *  删除 html 标签
 *
 *  @return 新的字符串
 */
- (NSString *)sc_stringByRemovingHTMLTags __attribute__((const));
@end

