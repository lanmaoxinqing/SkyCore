//
//  BaseDao.m
//  coreDataTest
//
//  Created by liud on 13-5-27.
//  Copyright (c) 2013年 liud. All rights reserved.
//

#import "SCBaseDao.h"
#import "SCBaseManagedDomain.h"
#import "SCSysconfig.h"
#import "SCFileOper.h"

@interface SCBaseDao(Private)

+(NSManagedObjectModel *)model;
+(NSPersistentStoreCoordinator *)database;
+(NSArray *)sortDescriptorsByStr:(NSString *)sort;


@end

@implementation SCBaseDao

static NSMutableDictionary          *contexts;      //管理上下文缓存
static NSManagedObjectContext       *_context;      //管理上下文
static NSMutableDictionary          *tempContexts;      //临时管理上下文缓存
static NSManagedObjectContext       *_tempContext;  //临时管理上下文
static NSPersistentStoreCoordinator *_database;     //数据源
static NSManagedObjectModel         *_model;        //数据模板

#pragma mark - Private method
+(NSManagedObjectModel *)model{
    if (_model == nil) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _model;
}

+(NSPersistentStoreCoordinator *)database{
    if (_database == nil) {
        //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
        NSString *dataFile=[SCSysconfig databasePath];
//        NSLog(@"%@", dataFile);
        if(![[NSFileManager defaultManager] fileExistsAtPath:dataFile]){
            [[NSFileManager defaultManager] createFileAtPath:dataFile contents:nil attributes:nil];
        }
        NSURL *url=[NSURL fileURLWithPath:dataFile];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *error = nil;
        //通过数据模型来创建NSPersistentStoreCoordinator对象
        _database=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
        //连接SQLite
        if (![_database addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error]) {
            NSAssert(@"ERROR-[BaseDao database]:%@,%@",[error description],[[error userInfo] description]);
        }
    }
    return _database;
}

+(NSArray *)sortDescriptorsByStr:(NSString *)sort{
    NSArray *arr=[sort componentsSeparatedByString:@","];
    if([arr count]%2!=0){
        NSAssert(@"ERROR-[BaseDao sortDescriptorsByStr:]:以下排序字段键值对不完整\n%@\n",sort);
        return nil;
    }
    NSMutableArray *sorts=[NSMutableArray array];
    for(int i=0;i<[arr count];i=i+2){
        NSString *key=[arr objectAtIndex:i];
        BOOL value=[[arr objectAtIndex:i+1] boolValue];
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:key ascending:value];
        [sorts addObject:sort];
    }
    return sorts;
}

#pragma mark - public method
+(void)prepare{
    //检查配置文件是否配置数据库名称
    if(![[SCSysconfig bundleValueByKey:kBundleKeyDataBase] sc_isNotEmpty]){
        NSLog(@"尚未配置数据库名称");
        return;
    }
    //检测沙盒中数据库是否存在
    NSError *error=nil;
    BOOL isExists=[[NSFileManager defaultManager] fileExistsAtPath:[SCSysconfig databasePath]];
    //数据库已存在
    if(isExists){
        NSLog(@"数据库已存在,加载数据库");
        [SCBaseDao tempContext];
        [SCBaseDao context];
        return;
    }
    //沙盒数据库不存在,检测应用包中初始数据库是否存在
    NSString *dbPath=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[SCSysconfig bundleValueByKey:kBundleKeyDataBase]];
    isExists=[[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    if(isExists){
        //复制初始数据库至沙盒
        BOOL isCreate=[[NSFileManager defaultManager] copyItemAtPath:dbPath toPath:[SCSysconfig databasePath] error:&error];
        if(isCreate){
            NSLog(@"初始数据库添加成功,加载数据库");
            [SCBaseDao tempContext];
            [SCBaseDao context];
        }else{
            NSLog(@"初始数据库添加失败,创建并加载数据库");
            [SCBaseDao tempContext];
            [SCBaseDao context];
        }
    }else{
        NSLog(@"初始数据库不存在,创建并加载数据库");
        [SCBaseDao tempContext];
        [SCBaseDao context];
    }
}
//获取上下文,每个线程一个context
+(NSManagedObjectContext *)context{
    if(contexts==nil){
        contexts=[NSMutableDictionary new];
    }
    NSString *currentThread=[[NSThread currentThread] description];//当前线程种类
//    NSLog(@"currentThread:%@",currentThread);
    //字典中已存在,返回
    _context=[contexts objectForKey:currentThread];
    if(_context){
        return _context;
    }
    //创建失败
    NSPersistentStoreCoordinator *coordinator = [self database];//NSPersistentStoreCoordinator（持久化存储助理）
    if(!coordinator){
        NSLog(@"ERROR:上下文创建失败!");
        return nil;
    }
    //创建新的上下文,并添加到字典
    _context = [[NSManagedObjectContext alloc] init];//被管理数据的上下文
    [_context setPersistentStoreCoordinator: coordinator];
    [contexts setObject:_context forKey:currentThread];
    return _context;
}

+(void)save{
    NSError *error;
    [[self context] save:&error];
//    //子线程使用完上下文释放,减少内存消耗
//    if(![[NSThread currentThread] isMainThread]){
//        NSString *currentThread=[[NSThread currentThread] description];//当前线程种类
//        [self removeContextByKey:currentThread];
//    }
    if(error){
        NSLog(@"save error:%@",[error description]);
    }
}

+(void)removeContextsByKey:(NSString *)key{
//    NSLog(@"============before remove===============\n%d",[contexts count]);
    if(contexts!=nil){
        [contexts removeObjectForKey:key];
    }
    if(tempContexts!=nil){
        [tempContexts removeObjectForKey:key];
    }
//    NSLog(@"============after remove===============\n%d",[contexts count]);

}

+(NSManagedObjectContext *)tempContext{
    if(tempContexts==nil){
        tempContexts=[NSMutableDictionary new];
    }
    NSString *currentThread=[[NSThread currentThread] description];//当前线程种类
    //    NSLog(@"currentThread:%@",currentThread);
    //一个线程生成一个上下文
    _tempContext=[tempContexts objectForKey:currentThread];
    if (_tempContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [self database];//NSPersistentStoreCoordinator（持久化存储助理）
        if (coordinator != nil) {
            _tempContext = [[NSManagedObjectContext alloc] init];//被管理数据的上下文
            [_tempContext setPersistentStoreCoordinator: coordinator];
            [tempContexts setObject:_tempContext forKey:currentThread];
        }
    }
    return _tempContext;
}

//从core data中查对一个对象
+(NSManagedObject *)selectEntity:(NSString *)entityName byId:(NSString *)sid{
    //sid为空时无记录，防止因为查询条件为空而查出所有记录
    if(sid==nil){
        sid=@"-1";
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"sid = %@",sid];
    NSArray *arr=[self selectByName:entityName andPredicate:predicate sort:nil limited:0];
    if([arr sc_isNotEmpty]){
        NSManagedObject *obj=[arr objectAtIndex:0];
        return obj;
    }else{
        return nil;
    }
}

+(NSArray *)selectByEntity:(NSManagedObject *)obj{
    return [self selectByEntity:obj sort:nil limited:0];
}

+(NSArray *)selectByEntity:(NSManagedObject *)obj sort:(NSString *)sort limited:(int)limitCount{
    NSString *className=NSStringFromClass([obj class]);
    NSPredicate *predicate=nil;
    //添加条件
    unsigned int outCount=0;
    objc_property_t * const properties=class_copyPropertyList([obj class], &outCount);
    if(outCount>0){
        NSMutableArray *predicates=[NSMutableArray array];
        for(int i=0;i<outCount;i++){
            NSString *attr = [NSString stringWithUTF8String: property_getAttributes(properties[i])];
            NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            if([attr rangeOfString:@"NSNumber"].location!=NSNotFound){
                id value=[obj valueForKey:propertyName];
                if([value sc_isNotNull]){
                    NSString *preStr=[NSString stringWithFormat:@"%@ = %%@",propertyName];
                    NSLog(@"%@",preStr);
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:preStr,value];
                    [predicates addObject:predicate];
                }
            }else if([attr rangeOfString:@"NSString"].location!=NSNotFound ||
                     [attr rangeOfString:@"NSMutableString"].location!=NSNotFound){
                id value=[obj valueForKey:propertyName];
                if([value sc_isNotNull]){
                    NSString *preStr=[NSString stringWithFormat:@"%@ CONTAINS[cd] %%@",propertyName];
                    NSPredicate *predicate=[NSPredicate predicateWithFormat:preStr,value];
                    [predicates addObject:predicate];
                }
            }
        }
        free(properties);
        if([predicates sc_isNotEmpty]){
            predicate=[NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        }
    }
    NSArray *result=[self selectByName:className andPredicate:predicate sort:sort limited:limitCount];
    return result;
}

+(NSArray *)selectByName:(NSString *)entityName{
    return [self selectByName:entityName andConditions:nil andValues:nil sort:nil limited:0];
}

+(NSArray *)selectByName:(NSString *)entityName andConditions:(NSArray *)conditions andValues:(NSArray *)values{
    return [self selectByName:entityName andConditions:conditions andValues:values sort:nil limited:0];
}

+(NSArray *)selectByName:(NSString *)entityName andConditions:(NSArray *)conditions andValues:(NSArray *)values sort:(NSString *)sort limited:(int)limitCount{
    NSPredicate *predicate=nil;
    //添加条件
    if(conditions!=nil){
        NSMutableArray *predicates=[NSMutableArray array];
        NSUInteger count=[conditions count];
        for(int i=0;i<count;i++){
            NSString *format=[conditions objectAtIndex:i];
            id value=[values objectAtIndex:i];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:format,value];
            [predicates addObject:predicate];
        }
        predicate=[NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    }
    NSArray *result=[self selectByName:entityName andPredicate:predicate sort:sort limited:limitCount];
    return result;
}

+(NSArray *)selectByName:(NSString *)entityName andPredicate:(NSPredicate *)predicate sort:(NSString *)sort limited:(int)limitCount{
    //生成请求
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    //添加条件
    if(predicate!=nil){
        request.predicate=predicate;
    }
    //添加排序
    if(sort!=nil){
        NSArray *sorts=[self sortDescriptorsByStr:sort];
        request.sortDescriptors=sorts;
    }
    //添加数量限制
    if(limitCount>0){
        request.fetchLimit=limitCount;
    }
    NSLog(@"conditions:%@",[predicate predicateFormat]);
    NSError *error=nil;
    NSArray *result=[[self context] executeFetchRequest:request error:&error];
    if(error!=nil){
        NSLog(@"error:%@",[error description]);
    }
    return result;
}

+(id)saveOrUpdateEntity:(NSManagedObject *)entity{
    if(entity!=nil){
        NSString *className=NSStringFromClass([entity class]);
//        NSLog(@"%@", className);
        SCBaseManagedDomain *obj=(SCBaseManagedDomain *)[self selectEntity:className byId:[entity valueForKey:@"sid"]];
        //对象已存在,更新
        if(obj!=nil){
            //        NSLog(@"update");
            [obj sync:entity];
            [[self context] refreshObject:obj mergeChanges:YES];
        }
        //对象不存在,新增
        else{
            obj=[NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[self context]];
            [obj sync:entity];
            //        NSLog(@"insert");
        }
        return obj;
    }
    return nil;
}


@end
