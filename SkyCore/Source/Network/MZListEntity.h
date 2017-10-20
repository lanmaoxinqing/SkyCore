//
//  MZListEntity.h
//  meizhuang
//
//  Created by Ricky on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface MZListEntity <__covariant ObjectType> : NSObject <YYModel>
@property (nonatomic, strong) NSArray <ObjectType> *list;
@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, assign) BOOL hasNext;

@end

