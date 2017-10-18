//
//  NSString+SCUtils.h
//  SkyCore
//
//  Created by sky on 2017/10/14.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCBlankFilter)
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

- (NSString *)sc_trimWhitespaceAndNewline __attribute__((const));

/**
 *  删除 html 标签
 *
 *  @return 新的字符串
 */
- (NSString *)sc_stringByRemovingHTMLTags __attribute__((const));

@end

//MARK:- 拼音
@interface NSString (SCChineseLetters)

/**
 将中文字符串转换为拼音字符串

 @return 拼音字符串
 */
- (NSString *)letters;
/**
 获取首个字符的首字母

 @return 首字母
 */
- (NSString *)firstLetter;
/**
  获取首个字符的首字母
 
 @param str 字符串
 @return 首字母
 */
+ (NSString *)firstLetterOfString:(NSString *)str;
/**
 获取指定字符的第一个字母

 @param index 字符索引
 @return 首字母
 */
- (NSString *)firstLetterForCharactorAtIndex:(NSInteger)index;
/**
 获取指定字符的第一个字母

 @param index 字符索引
 @param str 字符串
 @return 首字母
 */
+ (NSString *)firstLetterForCharactorAtIndex:(NSInteger)index ofString:(NSString *)str;

@end

//MARK:- emoji
@interface NSString (SCEmoji)

/**
 子字符串截取时考虑emoji情况。
 
 @param from 开始截取字符的索引，如处于emoji中间，会后移排除。
 @return 子字符串
 */
- (NSString *)emoji_substringFromIndex:(NSUInteger)from;

/**
 子字符串截取时考虑emoji情况。
 
 @param to 截取字符的终点索引，如处于emoji中间，会前移排除。
 @return 子字符串
 */
- (NSString *)emoji_substringToIndex:(NSUInteger)to;
/**
 子字符串截取时考虑emoji情况。如处于emoji中间，会排除该emoji。
 
 @param range 截取的字符串区间。
 @return 子字符串
 */
- (NSString *)emoji_substringWithRange:(NSRange)range;

@end

//MARK:- Secret
@interface NSString (SCSecret)
/**
 将指定区域用指定字符串顺序替换.

 @param cover 用于替换的字符串,默认为'*'.长度超过替换区域会被截断,不足则重复
 @param range 替换区域.`location`超过字符串长度时不替换,`length`超过字符串长度时替换至末尾
 @return 替换后的字符串
 */
- (NSString *)stringByCoverString:(NSString *)cover inRange:(NSRange)range;

@end
