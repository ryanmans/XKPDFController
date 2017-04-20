//
//  XKQLPreviewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKQLPreviewController.h"

#import <QuickLook/QuickLook.h> //原生加载pdf类库

@interface XKQLPreviewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSString * _fileName;
}
@property (nonatomic,strong)MBProgressHUD * hud;
@property (nonatomic,strong)QLPreviewController * pdfPreviewController;
@end

@implementation XKQLPreviewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.pdfPreviewController.view];
        
        [self addSubview:self.hud];

        WeakSelf(ws);
        
        [self.pdfPreviewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(ws);
        }];
        
    }
    return self;
}

//展示pdf视图
- (void)xk_ShowInController:(UIViewController *)viewController
{
    if (viewController == nil) return;
    
    [viewController.view addSubview:self];
    
    //iOS10 变化
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
        [viewController addChildViewController:self.pdfPreviewController];
    }
}

- (void)setFileUrl:(NSString *)fileUrl{
    
    _fileUrl = fileUrl;
    
    _fileName = [XKNetworkHelper xk_CreateNameWithURL:_fileUrl fileType:@"pdf"];
    
    [self xk_showPdf];
}

//MARK:展现pdf
- (void)xk_showPdf
{
    if (self.fileUrl.length == 0) return;
    
    //检测本地缓存
    if ([XKNetworkHelper xk_fileCacheExist:_fileName]) {
        
        [_pdfPreviewController reloadData];
        
        return;
    }
    
    WeakSelf(ws);
    
    [self.hud showAnimated:YES];
    
    ////该方法 内部已经具备去缓冲查询暂停文件
    [XKNetworkHelper xk_ResumeDownloadWithURL:_fileUrl fileName:_fileName progress:^(NSProgress * _Nullable progress) {
        
        ws.hud.progress = progress.completedUnitCount/progress.totalUnitCount;
        
    } success:^(NSString * _Nullable filePath) {
        
        runBlockWithMain(^{
            
            [ws.hud hideAnimated:YES];
            
            [ws.pdfPreviewController reloadData];
        });
        
    } failure:^(NSError * _Nullable error) {
        
        NSLog(@"pdf down error ----- %@",error.localizedDescription);
        
        runBlockWithMain(^{
            
           // ShowTSMessage(@"文件下载失败,请稍后重试", nil);
        });
    }];
    
}

#pragma mark - delegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return  [XKNetworkHelper xk_fileCacheExist:_fileName] ? [NSURL fileURLWithPath:[XKNetworkHelper xk_GetCacheDirPath:_fileName]] : nil;
}

#pragma mark - 懒加载
- (QLPreviewController*)pdfPreviewController
{
    if (!_pdfPreviewController)
    {
        _pdfPreviewController = [QLPreviewController new];
        _pdfPreviewController.delegate = self;
        _pdfPreviewController.dataSource = self;
    }
    
    return _pdfPreviewController;
}

- (MBProgressHUD*)hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithFrame:self.bounds];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _hud;
}

- (void)dealloc
{
    _hud = nil;
    
    _pdfPreviewController = nil;
}
@end
