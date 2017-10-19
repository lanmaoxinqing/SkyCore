//
//  UIImage+SCUtils.m
//  SkyCore
//
//  Created by sky on 2017/10/19.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import "UIImage+SCUtils.h"

@implementation UIImage (SCScale)

- (UIImage *)sc_resizedImageWithWidth:(CGFloat)width
{
    CGFloat height = width / self.size.width * self.size.height;
    return [self sc_resizedImageWithSize:CGSizeMake(width, height)];
}

- (UIImage *)sc_resizedImageWithHeight:(CGFloat)height
{
    CGFloat width = height / self.size.height * self.size.width;
    return [self sc_resizedImageWithSize:CGSizeMake(width, height)];
}

- (UIImage *)sc_resizedImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:(CGRect){{0, 0}, size}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)sc_clippedResizedImageFillSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    if (self.size.width * size.height > self.size.height * size.width) {
        CGFloat width = self.size.width * size.height / self.size.height;
        [self drawInRect:CGRectMake(-(width - size.width) / 2, 0, width, size.height)];
    }
    else {
        CGFloat height = self.size.height * size.width / self.size.width;
        [self drawInRect:CGRectMake(0, -(height - size.height) / 2, size.width, height)];
    }
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}

- (UIImage *)sc_thumbnailImageWithSize:(CGSize)size
{
    if (self.size.width < size.width && self.size.height < size.height) {
        return self;
    }
    return [self sc_clippedResizedImageFillSize:size];
}

- (UIImage *)sc_resizedImageFitSize:(CGSize)size
{
    // 原图片比较宽
    if (self.size.width * size.height > self.size.height * size.width) {
        return [self sc_resizedImageWithWidth:size.width];
    }
    else {
        return [self sc_resizedImageWithHeight:size.height];
    }
}

- (UIImage *)sc_resizedImageFillSize:(CGSize)size
{
    // 原图片比较宽
    if (self.size.width * size.height > self.size.height * size.width) {
        return [self sc_resizedImageWithHeight:size.height];
    }
    else {
        return [self sc_resizedImageWithWidth:size.width];
    }
}

- (UIImage *)sc_imageByCroppingWithRect:(CGRect)rect
{
    @autoreleasepool {
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return image;
    }
}

@end
