//
//  XKNetworkHelper.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKNetworkHelper.h"
#import "NSString+XK.h"
#import "XKFileManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

static AFHTTPSessionManager *_sessionManager;

static NSMutableArray *_allSessionTask;

static NSString * _fileRootDir;

static NSString * _fileCacheDir;

static NSString * _fileBufferDir;

@implementation XKNetworkHelper

+ (void)initialize
{
    _sessionManager = [AFHTTPSessionManager manager];
    
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //文件下载的根目录文件
    _fileRootDir = [XKFileManagerInstance xk_AppendingCachesDirectory:@"fileDownManager"];
    
    //文件下载的目录文件
    _fileCacheDir = [_fileRootDir stringByAppendingPathComponent:@"fileCache"];
    
    [XKFileManagerInstance xk_CreateDirectoryAtPath:_fileCacheDir];
    
    //文件下载缓冲区
    _fileBufferDir = [_fileRootDir stringByAppendingPathComponent:@"fileBuffer"];
    
    [XKFileManagerInstance xk_CreateDirectoryAtPath:_fileBufferDir];
    
    //临时（清空旧版本的存储）
    NSString * XKCoursePDF = [NSString stringWithFormat:@"%@/%@",_fileRootDir,@"XKCoursePDF"];
    
    if ([XKFileManagerInstance xk_FileExistsAtPath:XKCoursePDF]) {
        
        [XKFileManagerInstance xk_RemoveItemAtPath:XKCoursePDF];
    }
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    
    if (!_allSessionTask) {
        
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

//构建文件名
+ (NSString*)xk_CreateNameWithURL:(NSString*)URL fileType:(NSString*)fileType
{
    return [NSString stringWithFormat:@"%@.%@",IsSafeString(URL).xk_MD5Encoding,IsSafeString(fileType)];
}

//判断文件是否存在
+ (BOOL)xk_fileCacheExist:(NSString*)fileName
{
    if (!fileName) return NO;
    
    NSString * fileCachePath = [NSString stringWithFormat:@"%@/%@",_fileCacheDir,fileName];
    
    return [XKFileManagerInstance xk_FileExistsAtPath:fileCachePath];
}

// 获取已下载文件存储路径
+ (NSString*)xk_GetCacheDirPath:(NSString *)fileName
{
    return fileName ? [_fileCacheDir stringByAppendingPathComponent:fileName] : nil;
}

//删除已下载文件
+ (BOOL)xk_DeleteCachefile:(NSString *)fileName
{
    NSString * fileCachePath = [NSString stringWithFormat:@"%@/%@",_fileCacheDir,fileName];
    
    return [XKFileManagerInstance xk_RemoveItemAtPath:fileCachePath];
}

//清空缓存文件
+ (BOOL)xk_CleanCachefile
{
    return [XKFileManagerInstance xk_RemoveItemAtPath:_fileCacheDir];
}

//清空下载目录
+ (BOOL)xk_CleanRootDir
{
    return [XKFileManagerInstance xk_RemoveItemAtPath:_fileRootDir];
}

//获取缓冲区配置数据
+ (NSData*)xk_GetBufferData:(NSString*)URL
{
    NSString * bufferCfg = [NSString stringWithFormat:@"%@%@",URL.xk_MD5Encoding ,@".psCfg"];
    
    NSString * fileBufferPath = [NSString stringWithFormat:@"%@/%@",_fileBufferDir,bufferCfg];;
    
    if (![XKFileManagerInstance xk_FileExistsAtPath:fileBufferPath]) return nil;
    
    return [NSData dataWithContentsOfFile:fileBufferPath];
}

#pragma mark - 下载文件
//文件下载
+ (NSURLSessionDownloadTask *)xk_DownloadWithURL:(NSString *)URL
                                        fileName:(NSString *)fileName
                                        progress:(XKHttpProgress)progress
                                         success:(void (^)(NSString * _Nullable))success
                                         failure:(XKHttpRequestFailed)failure

{
    
    //如果包含中文，需要编码
    URL = URL.xk_IsIncludeChinese ?  [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : URL;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        runBlockWithMain(^{
            
            progress ? progress(downloadProgress) : nil;
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接文件路径
        NSString *filePath = [_fileCacheDir stringByAppendingPathComponent:IsSafeString(fileName)];
        
        NSLog(@"文件下载的路径 ----  %@",filePath);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        
        if(failure && error) {failure(error) ; return ;};
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

// 文件恢复下载
+ (NSURLSessionDownloadTask *)xk_ResumeDownloadWithURL:(NSString *)URL
                                              fileName:(NSString *)fileName
                                              progress:(XKHttpProgress)progress
                                               success:(void (^)(NSString * _Nullable))success
                                               failure:(XKHttpRequestFailed)failure
{
    
    NSData * fileBufferData = [self xk_GetBufferData:URL];
    
    if (!fileBufferData) { //缓冲区没有配置数据 ，则直接下载
        
        return [self xk_DownloadWithURL:URL fileName:fileName progress:progress success:success failure:failure];
    }
    
    NSURLSessionDownloadTask * downloadTask = [_sessionManager downloadTaskWithResumeData:fileBufferData progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        runBlockWithMain(^{
            
            progress ? progress(downloadProgress) : nil;
            
        });
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接文件路径
        NSString *filePath = [_fileCacheDir stringByAppendingPathComponent:IsSafeString(fileName)];
        
        NSLog(@"文件恢复下载的路径 ----  %@",filePath);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        
        if(failure && error) {failure(error) ; return ;};
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
    
}

//暂停任务
+ (void)xk_SuspendDownloaderTask:(NSString *)URL
{
    if (!URL) return;
    
    @synchronized (self) {
        
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                 
                 [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                     
                     runBlockWithMain(^{
                         
                         if (resumeData.length) {
                             
                             NSString * bufferCfg = [NSString stringWithFormat:@"%@%@",URL.xk_MD5Encoding ,@".psCfg"];
                             
                             NSString * fileBufferPath = [_fileBufferDir stringByAppendingPathComponent:bufferCfg];
                             
                             [resumeData writeToFile:fileBufferPath atomically:YES];
                         }
                     });
                     
                 }];
                 
                 [[self allSessionTask] removeObject:task];
                 
                 *stop = YES;
             }
             
         }];
    }
}

// 取消全部请求
+ (void)xk_CancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

// 取消单个任务请求
+ (void)xk_CancelRequestWithURL:(NSString *)URL {
    
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GCD Thread -

//主线程
void runBlockWithMain(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

//异步线程
void runBlockWithAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

// 先异步 后同步
void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asyncBlock();
        dispatch_async(dispatch_get_main_queue(), syncBlock);
    });
}
@end

