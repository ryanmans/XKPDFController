//
//  XKFileManager.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKFileManager.h"

@interface XKFileManager ()
{
    NSFileManager * _fm;
}
@property (nonatomic,strong) dispatch_queue_t fmQueue;
@end

@implementation XKFileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fm = [NSFileManager defaultManager];
        _fmQueue = dispatch_queue_create("com.Ryan_Man.PSFileManager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (XKFileManager*)shareInstance
{
    static XKFileManager * _fileManger = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _fileManger = [[XKFileManager alloc] init];
        
    });
    
    return _fileManger;
}

#pragma mark - Get -

//获取沙盒主目录路径
- (NSString*)xk_GetHomeDirectory
{
    return NSHomeDirectory();
}

//获取Library目录
- (NSString*)xk_GetLibraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

//获取Caches目录路径
- (NSString*)xk_GetCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

// 获取documents  下路径
- (NSString*)xk_GetDocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

// 获取temp 目录路径
- (NSString*)xk_GetTemporaryDirectory
{
    return NSTemporaryDirectory();
}

// 获取 NSBundle资源路径
- (NSString*)xk_GetMainBundlePathForResource:(NSString *)resource ofType:(NSString *)type
{
    return [[NSBundle mainBundle] pathForResource:resource ofType:type];
}

#pragma mark - Appending -

//获取沙盒主目录路径 NSHomeDirectory()下 某文件目录路径
- (NSString*)xk_AppendingHomeDirectory:(NSString*)fileName
{
    return [[self xk_GetHomeDirectory] stringByAppendingPathComponent:fileName];
}

//获取Caches目录路径 NSCachesDirectory[0]，某文件目录路径
- (NSString*)xk_AppendingCachesDirectory:(NSString*)fileName
{
    return [[self xk_GetCachesDirectory] stringByAppendingPathComponent:fileName];
}

//获取Documents目录路径 NSDocumentationDirectory[0]，某文件目录路径
- (NSString*)xk_AppendingDocumentDirectory:(NSString *)fileName
{
    return [[self xk_GetDocumentDirectory] stringByAppendingPathComponent:fileName];
}

//获取temp 目录路径  NSTemporaryDirectory(),某文件目录路径
- (NSString*)xk_AppendingTemporaryDirectory:(NSString *)fileName
{
    return [[self xk_GetTemporaryDirectory] stringByAppendingPathComponent:fileName];
}

#pragma mark - resource -

//获取某路径下的所有子路径名
- (NSArray*)xk_GetSubpathsAtPath:(NSString*)path
{
    if (![self xk_FileExistsAtPath:path]) return nil;
    
    return [_fm subpathsAtPath:path];
}

// 获取文件路径下的二进制数据
- (NSData*)xk_GetContentsAtPath:(NSString *)path
{
    if (![self xk_FileExistsAtPath:path]) return nil;
    
    return [_fm contentsAtPath:path];
}

//获取某路径文件的size
- (NSUInteger)xk_GetFileSizeWithPath:(NSString *)path
{
    if (![self xk_FileExistsAtPath:path]) return 0;
    
    return (NSUInteger)[[_fm attributesOfItemAtPath:path error:nil] fileSize];
}

//获取某个文件的全部size
- (NSUInteger)xk_GetAllFileSizeWithPath:(NSString *)path
{
    if (![self xk_FileExistsAtPath:path]) return 0;
    
    __block NSUInteger size = 0;
    dispatch_sync(self.fmQueue, ^{
        
        NSDirectoryEnumerator *fileEnumerator = [self->_fm enumeratorAtPath:path];
        
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}


#pragma mark - handle -

//判断路径是否存在
- (BOOL)xk_FileExistsAtPath:(NSString *)path
{
    if ( !path || path.length == 0) return NO;
    
    return [_fm fileExistsAtPath:path];
}

//创建文件目录
- (BOOL)xk_CreateDirectoryAtPath:(NSString*)path
{
    if ([self xk_FileExistsAtPath:path]) return YES;
    
    return [_fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

//重命名或者移动一个文件（to不能是已存在的）
- (BOOL)xk_MoveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if ((srcPath.length && dstPath.length) == NO) return NO;
    
    if (![self xk_FileExistsAtPath:srcPath]) return NO;
    
    return [_fm moveItemAtPath:srcPath toPath:dstPath error:nil];
}

//重命名或者复制一个文件（to不能是已存在的）
- (BOOL)xk_CopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if ((srcPath.length && dstPath.length) == NO) return NO;
    
    if (![self xk_FileExistsAtPath:srcPath]) return NO;
    
    return [_fm copyItemAtPath:srcPath toPath:dstPath error:nil];
}

//删除文件
- (BOOL)xk_RemoveItemAtPath:(NSString *)path
{
    if (![self xk_FileExistsAtPath:path]) return YES;
    
    return [_fm removeItemAtPath:path error:nil];
}

#pragma mark - NSUserDefaults -

//取值NSUserDefaults
- (id)xk_UserDefaultsObjectForkey:(NSString*)defaultName
{
    if (!defaultName || defaultName.length == 0) return nil;
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

//存值NSUserDefaults
- (void)xk_UserDefaultsSetObject:(id)Object forKey:(NSString *)defaultName
{
    if (!defaultName || defaultName.length == 0) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:Object forKey:defaultName];
}

//删值 NSUserDefaults
- (void)xk_UserDefaultsRemoveObjectForKey:(NSString *)defaultName
{
    if (!defaultName || defaultName.length == 0) return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}
@end

