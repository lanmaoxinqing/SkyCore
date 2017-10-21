//
//  SCMacros.h
//  SkyCore
//
//  Created by sky on 2017/10/21.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#ifndef SCMacros_h
#define SCMacros_h

//iOS版本
#define SCSystemVersionOver(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

/*日志打印*/
#if DEBUG
//simple
#ifdef SCLogSimple
#define NSLog(s, ...) printf("%s\n",[[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String])
#endif
//detail
#ifdef SCLogDetail
#define NSLog(s, ...) NSLog(@"%s(%d) %@",__FUNCTION__, __LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__])
#endif
#else
//product
#define NSLog(s, ...)
#endif

#define IgnorePerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* SCMacros_h */
