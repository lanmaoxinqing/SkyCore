//
//  NSString+md5.h
//  hztour-iphone
//
//  Created by liu ding on 12-6-1.
//  Copyright 2012年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(md5)
/**
 *  将字符串MD5加密
 *
 *  @return 加密后的字符串
 */
-(NSString *) md5HexDigest;
@end
