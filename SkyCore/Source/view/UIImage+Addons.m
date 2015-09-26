//
//  UIImage+Addons.m
//  leziyou-iphone
//
//  Created by wei ding on 11-8-18.
//  Copyright 2011年 teemax. All rights reserved.
//

#import "UIImage+Addons.h"
#import "SCSysconfig.h"

@implementation UIImage(Addons)

- (UIImage*)transformWidth:(CGFloat)width 
					height:(CGFloat)height {
	
	CGFloat destW = width;
	CGFloat destH = height;
	CGFloat sourceW = width;
	CGFloat sourceH = height;
	
	CGImageRef imageRef = self.CGImage;
	CGContextRef bitmap = CGBitmapContextCreate(NULL, 
												destW, 
												destH,
												CGImageGetBitsPerComponent(imageRef), 
												4*destW, 
												CGImageGetColorSpace(imageRef),
												(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
	
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
//	[result release];
}

+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage
{
	UIGraphicsBeginImageContext(baseImage.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
	CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
	
	CGImageRef maskRef = theMaskImage.CGImage;
	
	CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
	CGImageRelease(maskImage);
	CGImageRelease(maskRef);
	
	CGContextDrawImage(ctx, area, masked);
	CGImageRelease(masked);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
	return newImage;
}

//+(UIImage *)imageWithUrl:(NSString *)urlStr defaultImgName:(NSString *)imgName shouldSearchLocalPath:(BOOL)shouldSearch{
//    //    NSLog(@"urlStr:%@",urlStr);
//    //新的图片上传路径
//    if([urlStr rangeOfString:@"upload_resource"].location!=NSNotFound){
//        urlStr=[urlStr stringByReplacingOccurrencesOfString:@"http://www.leziyou.com/" withString:@"http://pub-web.leziyou.com/leziyou-web-new/"];
//    }
//    //设置默认图片
//    UIImage *img=nil;
//    if(imgName!=nil){
//        img=[UIImage imageNamed:imgName];
//    }else{
//        img=[UIImage imageNamed:@"img_none.png"];
//    }
//    //没有图片名字,使用默认图片
//    if([urlStr lastPathComponent]==nil || [[urlStr lastPathComponent] length]==0 || [[urlStr lastPathComponent] isEqualToString:@"(null)"]){
//    }else{
//        NSString *localImage=[SysConfig getLocalImagePath:urlStr];
//        NSString *pathImage=[SysConfig getFilePathByName:urlStr];
//        //搜索本地路径且存在图片
//        if(shouldSearch && [[NSFileManager defaultManager] fileExistsAtPath:localImage]){
//            img=[[UIImage alloc] initWithContentsOfFile:localImage];
//        }
//        //搜索下载路径且存在图片
//        else if([[NSFileManager defaultManager] fileExistsAtPath:pathImage]){
//            img=[[UIImage alloc] initWithContentsOfFile:pathImage];
//        }
//        //下载图片
//        else{
//            NSURL *url = [NSURL URLWithString:urlStr];
//            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//            [request setAllowResumeForFileDownloads:YES];
//            [request setDownloadDestinationPath:pathImage];
//            [request startSynchronous];
//            //下载成功
//            if([[NSFileManager defaultManager] fileExistsAtPath:pathImage]){
//                img=[[UIImage alloc] initWithContentsOfFile:pathImage];
//            }
//        }
//    }
//
//    return img;
//}
//
//-(UIImage *)customImg{
//    CGSize imgSize = self.size;
//    CGFloat width = imgSize.width;
//    CGFloat height = imgSize.height;
//    if (width <= MAX_IMAGEPIX && height <= MAX_IMAGEPIX) {
//        // no need to compress.
//        return self;
//    }
//    if (width == 0 || height == 0) {
//        // void zero exception
//        return self;
//    }
//    UIImage *newImage = nil;
//    CGFloat widthFactor = MAX_IMAGEPIX / width;
//    CGFloat heightFactor = MAX_IMAGEPIX / height;
//    CGFloat scaleFactor = 0.0;
//    
//    if (widthFactor > heightFactor)
//        scaleFactor = heightFactor; // scale to fit height
//    else
//        scaleFactor = widthFactor; // scale to fit width
//    
//    CGFloat scaledWidth  = width * scaleFactor;
//    CGFloat scaledHeight = height * scaleFactor;
//    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
//    
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    
//    [self drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
