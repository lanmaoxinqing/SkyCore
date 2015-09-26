//
//  UIViewController+Addons.h
//  hztour-iphone
//
//  Created by liu ding on 12-2-8.
//  Copyright 2012年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Addons)

-(void)showWaitview;//添加等待滚动圈
-(void)showWaitview:(NSString *)text;//添加等待滚动圈
-(void)removeWaitview;//移除等待滚动圈
-(void)showSuggestion:(NSString *)info;
-(void)showSuggestion:(NSString *)info showTime:(float)time;
-(void)showAlertWithMessage:(NSString *)msg;

@end


@interface UIViewController(Addons)
-(void)showWaitview;//添加等待滚动圈
-(void)showWaitview:(NSString *)text;//添加等待滚动圈
-(void)removeWaitview;//移除等待滚动圈
-(void)setTitle:(NSString *)title Animated:(BOOL)animate;//设置滚动标题
/*
 添加提示信息
 */
-(void)showSuggestion:(NSString *)info;
-(void)showSuggestion:(NSString *)info showTime:(float)time;

-(void)replaceBgColorWithImage;//为视图添加背景图片
-(void)showAlertWithMessage:(NSString *)msg;

-(id)createControllerByName:(NSString *)name;

@end