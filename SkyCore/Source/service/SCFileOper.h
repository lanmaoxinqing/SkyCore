//
//  FileOper.h
//  hztour-iphone
//
//  Created by liu ding on 11-12-31.
//  Copyright 2011年 teemax. All rights reserved.
//

/*
 用于存放文件操作方法
 */

#import <Foundation/Foundation.h>

typedef void (^CompleteHandle)(BOOL result,NSString *unzipPath,NSError *error);

@interface SCFileOper : NSObject {
    
}
/**
	创建,删除文件目录
	@param path 文件目录
 */
+(void)createFolder:(NSString *)path;
+(void)removeFolder:(NSString *)folderPath;
/**
	文件重命名
	@param oldFileName 原名
	@param newFileName 重命名
 */
+(void)renameFile:(NSString *)oldFileName newName:(NSString *)newFileName;
/**
	移动指定文件到指定目录
	@param filePaths 原文件路径数组
	@param newFolder 新文件目录
	@returns 是否移动成功
 */
+(BOOL)moveFiles:(NSArray *)filePaths toNewFolder:(NSString *)newFolder;

/**
	移动原文件目录中的文件至新文件目录
	@param oldFolder 原文件夹
	@param newFolder 新文件夹
	@returns 是否移动成功
 */
+(BOOL)moveFilesFromOldFolder:(NSString *)oldFolder toNewFolder:(NSString *)newFolder;

/**
	创建,删除文件
	@param filePath 文件路径
 */
+(void)createFile:(NSString *)filePath;
+(void)removeFile:(NSString *)filePath;

/**
 *  文件解压
 *
 *  @param filePath 压缩文件路径
 *  @param destinationPath 解压目录路径
 *  @param pwd 解压密码
 *  @param complete 解压完成时回调方法
 */
+(void)unzipFile:(NSString *)filePath complete:(CompleteHandle)complete;
+(void)unzipFile:(NSString *)filePath password:(NSString *)pwd complete:(CompleteHandle)complete;
+(void)unzipFile:(NSString *)filePath toDestinationPath:(NSString *)destinationPath complete:(CompleteHandle)complete;
+(void)unzipFile:(NSString *)filePath toDestinationPath:(NSString *)destinationPath password:(NSString *)pwd complete:(CompleteHandle)complete;


@end
