//
//  FileOper.m
//  hztour-iphone
//
//  Created by liu ding on 11-12-31.
//  Copyright 2011年 teemax. All rights reserved.
//

#import "SCFileOper.h"
#import "SSZipArchive.h"

@implementation SCFileOper
+(void) createFolder:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    }
}

+(void)removeFolder:(NSString *)folderPath{
    [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
}

+(void) renameFile:(NSString *)oldFileName newName:(NSString *)newFileName{
    NSError *error;
    if ([[NSFileManager defaultManager] moveItemAtPath:oldFileName toPath:newFileName error:&error] != YES){
        //        NSLog(@"Unable to move file: %@ fileName:%@", [error localizedDescription],oldFileName);
    }
}

+(BOOL)moveFiles:(NSArray *)filePaths toNewFolder:(NSString *)newFolder{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(filePaths!=nil && [filePaths count]>0){
        for(NSString *filePath in filePaths){
            if([filePath isNotEmpty] && [fileManager fileExistsAtPath:filePath]){
                NSString *newPath=[newFolder stringByAppendingPathComponent:[filePath lastPathComponent]];
                [fileManager moveItemAtPath:filePath toPath:newPath error:nil];
            }
        }
    }
    return YES;
}

+(BOOL) moveFilesFromOldFolder:(NSString *)oldFolder toNewFolder:(NSString *)newFolder{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //目录下无文件
    if (![fileManager isExecutableFileAtPath:oldFolder]) {
        return YES;
    }
    NSArray *arr=[fileManager contentsOfDirectoryAtPath:oldFolder error:nil];
//    NSLog(@"file count:%d",[arr count]);
    if(arr!=nil && [arr count]>0){
        for(NSString *fileName in arr){
            NSString *oldPath=[oldFolder stringByAppendingPathComponent:fileName];
            //            NSLog(@"oldPath:%@",oldPath);
            NSString *newPath=[newFolder stringByAppendingPathComponent:fileName];
            //            NSLog(@"newPath:%@",newPath);
            [fileManager moveItemAtPath:oldPath toPath:newPath error:nil];
        }
    }
    return YES;
}

+(void)createFile:(NSString *)filePath{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
}

+(void)removeFile:(NSString *)filePath{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

+(void)unzipFile:(NSString *)filePath complete:(CompleteHandle)complete{
    [self unzipFile:filePath password:nil complete:complete];
}

+(void)unzipFile:(NSString *)filePath password:(NSString *)pwd complete:(CompleteHandle)complete{
    NSString *path=[filePath stringByDeletingLastPathComponent];
    [self unzipFile:filePath toDestinationPath:path password:pwd complete:complete];
}

+(void)unzipFile:(NSString *)filePath toDestinationPath:(NSString *)destinationPath complete:(CompleteHandle)complete{
    [self unzipFile:filePath toDestinationPath:destinationPath password:nil complete:complete];
}

+(void)unzipFile:(NSString *)filePath toDestinationPath:(NSString *)destinationPath password:(NSString *)pwd complete:(CompleteHandle)complete{
    NSError *error=nil;
    BOOL result=[SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath overwrite:YES password:pwd error:&error];
    if(complete){
        complete(result,destinationPath,error);
    }
}

@end
