//
//  BaseDomain.h
//  SkyCore
//
//  Created by sky on 14-3-18.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Persistence.h"

@class GDataXMLElement;

/**
 非数据库模型基类,实现对象的编码,解码,字典映射,xml映射,
 所有非数据库自定义NSObject类都应继承本类
 */
@interface SCBaseDomain : NSObject<NSCoding>
/**
 将字典解析成类对象实例(对象属性与字典key值不符的字段需手动添加)
 @param dic 含类对象(属性-值)键值对的字典
 @returns 类对象实例
 */
-(id)initWithDictionary:(NSDictionary *)dic;
/**
 *  将XML节点解析成对象实例(默认属性名称首字母大写,未找到时使用原属性名称查找,不符合规则的字段需手动添加)
 *
 *  @param ele 包含对象数据的XML节点
 *
 *  @return 类对象实例
 */
-(id)initWithElement:(GDataXMLElement *)ele;

@end
