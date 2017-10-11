//
//  BaseManagedDomain.h
//  coreDataTest
//
//  Created by liud on 13-5-27.
//  Copyright (c) 2013年 liud. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSObject+NotNull.h"

/**
	数据库基础对象类,实现对象的持久和非持久初始化,编码,解码,字典映射,xml映射,
    所有自定义NSManagedObject类都应继承本类
	@author sky
 */
@class GDataXMLElement;
@interface SCBaseManagedDomain : NSManagedObject<NSCoding>

/**
	非持久化初始化
	@returns 瞬态类对象实例
 */
-(id)init;
/**
	持久化初始化(创建的对象已在管理上下文中,可直接进行增删改查操作,临时变量请使用init方法初始化)
	@returns 持久化类对象实例
 */
-(id)initPersistence;
/**
	从另一个相同类(或子类)对象实例中复制属性(仅复制本类中的属性,不包括关联属性relationship)
	@param obj 复制源类对象实例
 */
-(void)valueFrom:(NSManagedObject *)obj;
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
//-(id)initWithElement:(GDataXMLElement *)ele;

@end
