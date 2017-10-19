//
//  DragView.h
//  sky-core
//
//  Created by sky on 13-9-24.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
	可拖动UI
	@author sky
 */
@interface DragView : UIView{
    CGPoint beginPoint;//起点坐标
    BOOL moved;//是否移动
}

@property (nonatomic) BOOL dragEnable;//是否可拖动

@end
