//
//  UIImage+Addons.h
//  leziyou-iphone
//
//  Created by wei ding on 11-8-18.
//  Copyright 2011年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MAX_IMAGEPIX 320.0 //max pix 320.0px
#define MAX_IMAGEDATA_LEN 100000.0   // max data length 5K

@interface UIImage(Addons)
/**
	修改图片尺寸
	@param width 修改后的宽度
	@param height 修改后的高度
	@returns 修改后的图片
 */
-(UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height;
/**
	使用纯色对图片进行蒙版
	@param baseImage 原图
	@param theColor 覆盖的颜色
	@returns 修改后的图片
 */
+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;
/**
	使用图片对图片进行蒙版
	@param baseImage 原图
	@param theMaskImage 蒙版图片
	@returns 修改后的图片
 */
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;
/**
	根据纯色生成图片
	@param color 颜色
	@param size 图片尺寸
	@returns 生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

///*
// 图片查找下载
// urlStr:图片网络路径
// shouldSearch:是否搜索程序目录
// */
//
//+(UIImage *)imageWithUrl:(NSString *)urlStr defaultImgName:(NSString *)imgName shouldSearchLocalPath:(BOOL)shouldSearch;
//-(UIImage *)customImg;

@end
