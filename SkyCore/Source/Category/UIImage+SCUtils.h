//
//  UIImage+SCUtils.h
//  SkyCore
//
//  Created by sky on 2017/10/19.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SCScale)

/**
 *  将图片的宽度等比缩放到指定宽度，无论新宽度比原来大还是小，输出的图片宽一定为指定宽度，高度等比
 *
 *  @param width 指定新宽度
 *
 *  @return 宽度为指定宽度的新图片
 */
- (UIImage *)sc_resizedImageWithWidth:(CGFloat)width;

/**
 *  将图片的高度等比缩放到指定高度，无论新高度比原来大还是小，输出的图片宽一定为指定高度，宽度等比
 *
 *  @param width 指定新高度
 *
 *  @return 高度为指定高度的新图片
 */
- (UIImage *)sc_resizedImageWithHeight:(CGFloat)height;

/**
 *  将图片高宽调整为新的高宽，如果不等比，新图片将被拉伸，新图片保存高宽为指定高宽
 *
 *  @param size 指定的目标高宽
 *
 *  @return 高宽为指定高宽的新图片
 */
- (UIImage *)sc_resizedImageWithSize:(CGSize)size;

/**
 *  将图片等比适配到指定高宽，最终长边等于指定长边，短边等比
 *
 *  @param size 指定的目标高宽
 *
 *  @return 缩放后的图片，面积小于等于指定的高宽面积
 */
- (UIImage *)sc_resizedImageFitSize:(CGSize)size;

/**
 *  将图片等比充满到指定高宽，最终短边等于指定短边，长边等比
 *
 *  @param size 指定的目标高宽
 *
 *  @return 缩放后的图片，面积大于等于指定的高宽面积
 */
- (UIImage *)sc_resizedImageFillSize:(CGSize)size;

/**
 *  获取一张等比填充指定尺寸的图，最终图片面积等于指定高宽面积，
 *  @warning 此方法并不会判断原图的尺寸，如果原图比新尺寸还小，新图将会拉伸！
 *
 *  @param size 指定的目标尺寸
 *
 *  @return 尺寸等于指定尺寸的新图片
 */
- (UIImage *)sc_clippedResizedImageFillSize:(CGSize)size;

/**
 *  获取图片的指定尺寸的缩略图，缩略图等比填充指定大小，如果原图尺寸比指定尺寸小，返回原图
 *
 *  @param size 缩略图大小
 *
 *  @return 缩略图
 */
- (UIImage *)sc_thumbnailImageWithSize:(CGSize)size;

/**
 截取指定区域的内容作为新图片返回

 @param rect 指定区域
 @return 截取后的图片
 */
- (UIImage *)sc_imageByCroppingWithRect:(CGRect)rect;

@end


@interface UIImage (SCRound)

- (UIImage *)sc_roundedImageWithCornerRadius:(CGFloat)radius;
- (UIImage *)sc_roundedImage;

@end

