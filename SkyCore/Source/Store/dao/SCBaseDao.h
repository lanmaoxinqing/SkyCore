//
//  BaseDao.h
//  coreDataTest
//
//  Created by liud on 13-5-27.
//  Copyright (c) 2013年 liud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

#define kCurrentContentKey ([[NSThread currentThread] description])

/**
	数据库基本操作
	@author sky
 */
@interface SCBaseDao : NSObject{
}

/**
	初始化并加载数据库,当项目需要使用数据库操作时,请确保此方法最优先被调用(可以写在AppDelegate中)
 */
+(void)prepare;

/**
	获取临时管理上下文
	@returns
 */
+(NSManagedObjectContext *)tempContext;
/**
	获取持久化管理上下文
	@returns
 */
+(NSManagedObjectContext *)context;

/**
	保存数据库操作变动
 */
+(void)save;

/**
    根据线程名删除上下文,用于清理线程中操作数据库后残留的临时上下文,请不要主动调用此方法
	@param key 线程名(使用kCurrentContentKey获取线程key值)
	@param sid 类ID
	@returns 类对象
 */
+(void)removeContextsByKey:(NSString *)key;

/**
	根据类名,类ID获取类对象
	@param entityName 类名
	@param sid 类ID
	@returns 类对象
 */
+(NSManagedObject *)selectEntity:(NSString *)entityName byId:(NSString *)sid;
/**
	根据对象搜索结果
	@param obj 需要搜索的对象实例,搜索条件为赋值的属性
	@returns 符合搜索条件的对象实例列表
 */
+(NSArray *)selectByEntity:(NSManagedObject *)obj;
/**
	根据对象搜索结果
	@param obj 需要搜索的对象实例,搜索条件为赋值的属性
	@param sort 排序方式,YES为正序,NO为倒序,格式为:
        @"排序字段(即属性名),排序方式(YES或者NO),排序字段(即属性名),排序方式(YES或者NO)..."
        例如:
        @"type,YES,day,NO,id,YES..."
	@param limitCount 返回结果数量,0则全部返回
	@returns 符合搜索条件的对象实例列表
 */
+(NSArray *)selectByEntity:(NSManagedObject *)obj sort:(NSString *)sort limited:(int)limitCount;
/**
	根据对象名称搜索
	@param entityName 需要搜索的对象名称
	@returns 该对象在数据库中的所有记录
 */
+(NSArray *)selectByName:(NSString *)entityName;
/**
	根据对象名称,搜索条件搜索
	@param entityName 需要搜索的对象名称
	@param conditions 搜索条件,可使用匹配条件:==  >=  <=  LIKE  CONTAINS  MATCHES  BETWEEN(具体可查看)
                                    格式为:@"查询字段(即属性名) 匹配条件 占位符"
                                    例如:@"ID == %@"
	@param values condition中占位符对应值(建议统一使用字符串)
	@returns 符合搜索条件的对象实例列表
 */
+(NSArray *)selectByName:(NSString *)entityName andConditions:(NSArray *)conditions andValues:(NSArray *)values;
/**
	根据对象名称,搜索条件搜索
	@param entityName 需要搜索的对象名称
    @param conditions 搜索条件,可使用匹配条件:==  >=  <=  LIKE  CONTAINS  MATCHES  BETWEEN
                                    格式为:@"查询字段(即属性名) 匹配条件 占位符"
                                    例如:@"ID == %@"

	@param values condition中占位符对应值(建议统一使用字符串) 
	@param sort 排序方式,YES为正序,NO为倒序,格式为:
        @"排序字段(即属性名),排序方式(YES或者NO),排序字段(即属性名),排序方式(YES或者NO)..."
        例如:
        @"type,YES,day,NO,id,YES..."
	@param limitCount 返回结果数量,0则全部返回
	@returns 符合搜索条件的对象实例列表
 */
+(NSArray *)selectByName:(NSString *)entityName andConditions:(NSArray *)conditions andValues:(NSArray *)values sort:(NSString *)sort limited:(int)limitCount;

/**
	通用查询语句,自定义NSPredicate查询条件
	@param entityName 需要搜索的对象名称
	@param predicate NSPredicate搜索条件
	@param sort 排序方式,YES为正序,NO为倒序,格式为:
        @"排序字段(即属性名),排序方式(YES或者NO),排序字段(即属性名),排序方式(YES或者NO)..."
        例如:
        @"type,YES,day,NO,id,YES..."
	@param limitCount 返回结果数量,0则全部返回
	@returns 符合搜索条件的对象实例列表
 */
+(NSArray *)selectByName:(NSString *)entityName andPredicate:(NSPredicate *)predicate sort:(NSString *)sort limited:(int)limitCount;

/**
	更新或新增对象
	@param entity 需要更新或新增的对象(根据sid匹配)
 */
+(id)saveOrUpdateEntity:(NSManagedObject *)entity;
@end
