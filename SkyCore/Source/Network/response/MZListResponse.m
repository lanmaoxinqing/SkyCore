//
//  MZListResponse.m
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZListResponse.h"
#import "MZResponseListParser.h"

@interface MZListResponse <ObjectType>()

@end
@implementation MZListResponse

- (instancetype)initWithResponseData:(NSData *)data
{
    self = [super initWithResponseData:data];
    if (self) {
        
    }
    return self;
}

- (NSError *)parseForEntityName:(NSString *)entityName entityClass:(Class)clazz {
    if (self.parser == nil) {
        self.parser = [[MZResponseListParser alloc] initWithResponse:self];
    }
    
    NSError *error = [self.parser parseForItemClass:clazz];
    if (error) {
        return error;
    }
    
    if (entityName.length && self.listEntity) {
        [self setValue:self.listEntity forKeyPath:entityName];
    }
    return nil;
}

- (BOOL)hasNext
{
    return self.listEntity.hasNext;
}

/**
 过时方法

 @param object <#object description#>

 @return <#return value description#>
 */
- (instancetype)initWithObject:(id)object
{
    self = [super initWithObject:object];
    if (self) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            MZListEntity *entity = [MZListEntity new];
            if ([object[@"total"] isKindOfClass:[NSNumber class]]) {
                entity.total = [object[@"total"] integerValue];
            }
            entity.list = [NSArray yy_modelArrayWithClass:self.class.entityClass json:object[@"list"]];
            self.listEntity = entity;
            if ([object[@"hasNext"] isKindOfClass:[NSNumber class]]) {
                self.listEntity.hasNext = [object[@"hasNext"] boolValue];
            }
        }
    }
    return self;
}


@end

