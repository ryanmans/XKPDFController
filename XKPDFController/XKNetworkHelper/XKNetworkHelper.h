//
//  XKNetworkHelper.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//网络协助类：文件上传 ，下载 等等

/** 请求成功的Block */
typedef void(^XKHttpRequestSuccess)(id _Nullable responseObject);

/** 请求失败的Block */
typedef void(^XKHttpRequestFailed)(NSError * _Nullable error);

/** 缓存的Block */
typedef void(^XKHttpRequestCache)(id _Nullable responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^XKHttpProgress)(NSProgress * _Nullable progress);


@interface XKNetworkHelper : NSObject


/**
 获取文件名
 
 @param URL 下载链接
 @param fileType 文件类型
 @return filename
 */
+ (NSString*)xk_CreateNameWithURL:(NSString*)URL fileType:(NSString*)fileType;


/**
 判断文件是否存在
 
 @param fileName 文件名
 @return yes / no
 */
+ (BOOL)xk_fileCacheExist:(NSString*)fileName;

/**
 获取已下载文件存储路径
 
 @param fileName 文件名
 @return 文件存储路径
 */
+ (NSString*)xk_GetCacheDirPath:(NSString *)fileName;


/**
 删除已下载文件
 
 @param fileName 文件名
 @return yes / no
 */
+ (BOOL)xk_DeleteCachefile:(NSString*)fileName;

/**
 清空缓存文件
 
 @return yes / no
 */
+ (BOOL)xk_CleanCachefile;


/**
 清空下载目录
 
 @return yes / no
 */
+ (BOOL)xk_CleanRootDir;


/**
 文件下载
 
 @param URL 下载链接
 @param fileName 文件名
 @param progress 进度
 @param success 成功，返回文件存储路径
 @param failure 失败error
 @return 返回的对象可取消请求,调用xk_CancelDownloaderTask方法
 */
+ (NSURLSessionDownloadTask *)xk_DownloadWithURL:(NSString *)URL
                                        fileName:(NSString*)fileName
                                        progress:(XKHttpProgress)progress
                                         success:(void(^)(NSString * _Nullable filePath))success
                                         failure:(XKHttpRequestFailed)failure;


/**
 文件恢复下载
 
 @param URL 下载链接
 @param fileName 文件名
 @param progress 进度
 @param success 成功，返回文件存储路径
 @param failure 失败error
 @return 返回的对象可取消请求,调用xk_CancelDownloaderTask方法
 */
+ (NSURLSessionDownloadTask *)xk_ResumeDownloadWithURL:(NSString *)URL
                                              fileName:(NSString*)fileName
                                              progress:(XKHttpProgress)progress
                                               success:(void(^)(NSString * _Nullable filePath))success
                                               failure:(XKHttpRequestFailed)failure;


/**
 暂停下载任务
 
 @param URL 下载的链接
 */
+ (void)xk_SuspendDownloaderTask:(NSString *)URL;


/**
 取消全部请求
 */
+ (void)xk_CancelAllRequest;


/**
 取消单个任务请求
 
 @param URL 下载的链接
 */
+ (void)xk_CancelRequestWithURL:(NSString *)URL;


#pragma mark - GCD Thread-

/**
 *  主线程
 *
 *  @param block  主线程
 */
void runBlockWithMain(dispatch_block_t block);

/**
 *  异步线程
 *
 *  @param block  异步执行
 */
void runBlockWithAsync(dispatch_block_t block);

/**
 *  先异步 后同步
 *
 *  @param asyncBlock  异步
 *  @param syncBlock   同步
 */
void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock);

@end

NS_ASSUME_NONNULL_END
