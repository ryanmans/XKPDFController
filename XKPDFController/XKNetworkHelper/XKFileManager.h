//
//  XKFileManager.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _API_UNAVAILABLE(INFO)    __attribute__((unavailable(INFO)))

NS_ASSUME_NONNULL_BEGIN

#define  XKFileManagerInstance   [XKFileManager shareInstance]

@interface XKFileManager : NSObject

/**
 *  forbid
 *
 *  @return class
 */
+ (instancetype)new _API_UNAVAILABLE("使用shareInstance来获取实例");

/**
 *  单列
 *
 *  @return class
 */
+ (XKFileManager*)shareInstance;

#pragma mark - Get -

/**
 *  获取沙盒主目录路径 NSHomeDirectory()
 *
 *  @return string
 */
- (NSString*)xk_GetHomeDirectory;

/**
 *  获取Library目录 NSLibraryDirectory
 *
 *  @return string
 */
- (NSString*)xk_GetLibraryDirectory;

/**
 *   获取Caches目录路径 NSCachesDirectory[0]
 *
 *  @return string
 */
- (NSString*)xk_GetCachesDirectory;

/**
 *  获取Documents目录路径 NSDocumentationDirectory[0]
 *
 *  @return string
 */
- (NSString*)xk_GetDocumentDirectory;

/**
 *  获取temp 目录路径  NSTemporaryDirectory()(会多 ‘／’，系统自带)
 *
 *  @return string
 */
- (NSString*)xk_GetTemporaryDirectory;

/**
 *  获取NSBundle 下资源路径
 *
 *  @param resource 资源名称
 *  @param type     资源类型
 *
 *  @return string
 */
- (nullable NSString*)xk_GetMainBundlePathForResource:(NSString*)resource ofType:(NSString*)type;

#pragma mark - Appending -

/**
 *  获取沙盒主目录路径 NSHomeDirectory()下 某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return string
 */
- (nullable NSString*)xk_AppendingHomeDirectory:(NSString*)fileName;

/**
 *  获取Caches目录路径 NSCachesDirectory[0]，某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return string
 */
- (nullable NSString*)xk_AppendingCachesDirectory:(NSString*)fileName;

/**
 * 获取Documents目录路径 NSDocumentationDirectory[0]，某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return string
 */
- (nullable NSString*)xk_AppendingDocumentDirectory:(NSString*)fileName;

#pragma mark - resource -

/**
 *  获取某路径下的所有子路径名
 *
 *  @param path 文件路径
 *
 *  @return array
 */
- (nullable NSArray<NSString *> *)xk_GetSubpathsAtPath:(NSString*)path;

/**
 *  获取文件路径下的二进制数据
 *
 *  @param path 文件路径
 *
 *  @return data
 */
- (nullable NSData*)xk_GetContentsAtPath:(NSString*)path;

/**
 *  获取某路径文件的size
 *
 *  @param path 文件路径
 *
 *  @return NSUInteger
 */
- (NSUInteger)xk_GetFileSizeWithPath:(NSString*)path;

/**
 * 获取某个文件的全部size
 *
 *  @param path 文件路径
 *
 *  @return NSUInteger
 */
- (NSUInteger)xk_GetAllFileSizeWithPath:(NSString *)path;

#pragma mark - handle -

/**
 *  判断路径是否存在
 *
 *  @param path 文件路径
 *
 *  @return yes / no
 */
- (BOOL)xk_FileExistsAtPath:(NSString*)path;

/**
 *  创建文件目录目录
 *
 *  @param path 文件路径
 *
 *  @return yes / no
 */
- (BOOL)xk_CreateDirectoryAtPath:(NSString*)path;

/**
 *  重命名或者移动一个文件（to不能是已存在的）
 *
 *  @param srcPath 旧路径
 *  @param dstPath 新路径
 *
 *  @return yes / no
 */
- (BOOL)xk_MoveItemAtPath:(NSString*)srcPath toPath:(NSString *)dstPath;

/**
 *  重命名或者复制一个文件（to不能是已存在的）
 *
 *  @param srcPath 旧路径
 *  @param dstPath 新路径
 *
 *  @return yes / no
 */
- (BOOL)xk_CopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

/**
 *  删除文件
 *
 *  @param path 文件路径
 *
 *  @return yes / no
 */
- (BOOL)xk_RemoveItemAtPath:(NSString*)path;

#pragma mark - NSUserDefaults -

/**
 *  取值 NSUserDefaults
 *
 *  @param defaultName name
 *
 *  @return id
 */
- (nullable id)xk_UserDefaultsObjectForkey:(NSString*)defaultName;

/**
 *  存值 NSUserDefaults
 *
 *  @param Object  id
 *  @param defaultName  name
 */
- (void)xk_UserDefaultsSetObject:(id)Object forKey:(NSString *)defaultName;

/**
 *  删值 NSUserDefaults
 *
 *  @param defaultName name
 */
- (void)xk_UserDefaultsRemoveObjectForKey:(NSString*)defaultName;

@end
NS_ASSUME_NONNULL_END
