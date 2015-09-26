//
//  UIView+Frame.h
//  SkyCore
//
//  Created by sky on 14-9-1.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

-(void)setOriginx:(CGFloat)x;
-(void)setOriginy:(CGFloat)y;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;
-(void)setSize:(CGSize)size;
-(void)setOrigin:(CGPoint)point;

-(CGFloat)originx;
-(CGFloat)originy;
-(CGFloat)width;
-(CGFloat)height;
-(CGSize)size;
-(CGPoint)origin;

@end
