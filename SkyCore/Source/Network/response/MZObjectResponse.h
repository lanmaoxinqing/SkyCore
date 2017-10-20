//
//  MZObjectResponse.h
//  Meixue
//
//  Created by 郑志勤 on 16/10/20.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "MZBaseResponse.h"

@interface MZObjectResponse<ResponseEntityType> : MZBaseResponse

@property (nonatomic, strong) ResponseEntityType resultEntity;

@end
