//
//  XKPDFWebViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKPDFWebViewController.h"
@interface XKPDFWebViewController () <UIWebViewDelegate,UIScrollViewDelegate>
{
    NSString * _fileName;
}
@property (nonatomic,strong)MBProgressHUD * hud;
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation XKPDFWebViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.webView];
        
        [self addSubview:self.hud];
        
        //使文档的显示范围适合UIWebView的bounds
        [self.webView setScalesPageToFit:YES];
        
        WeakSelf(ws);
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(ws);
        }];
        
    }
    return self;
}

- (void)setFileUrl:(NSString *)fileUrl
{
    _fileUrl = fileUrl;
    
    _fileName = [XKNetworkHelper xk_CreateNameWithURL:_fileUrl fileType:@"pdf"];
    
    [self xk_showPdf];
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    
    [self xk_PDFWebReloadData:filePath];
}

//MARK:展现pdf
- (void)xk_showPdf
{
    if (self.fileUrl.length == 0) return;
    
    //检测本地缓存
    if ([XKNetworkHelper xk_fileCacheExist:_fileName]) {
        
        [self xk_PDFWebReloadData:[XKNetworkHelper xk_GetCacheDirPath:_fileName]];
        
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
            
            [ws xk_PDFWebReloadData:filePath];
        });
        
    } failure:^(NSError * _Nullable error) {
        
        NSLog(@"pdf down error ----- %@",error.localizedDescription);
        
        runBlockWithMain(^{
            
            //ShowTSMessage(@"文件下载失败,请稍后重试", nil);
        });
    }];
}

//数据刷新
- (void)xk_PDFWebReloadData:(NSString*)filePath
{
    
    if (![NSThread isMainThread]) {
        
        runBlockWithMain(^{
            
            [self xk_PDFWebReloadData:filePath];
            
        });
        return;
    }
    
    if (filePath.length == NO) return;
    
    NSURL * url = [NSURL fileURLWithPath:filePath] ;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

#pragma mark - delegate  -

//部分要求 :需要通过滚动的事件，进行某些操作。刚好本身使用UIWebView 就支持
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    float y = offset_Y + scrollView.bounds.size.height - scrollView.contentInset.bottom;
    
    float h = scrollView.contentSize.height;

    if (y >= (h + 5)) {
        
        NSLog(@"滚动到底部");
    }
}

#pragma mark - 懒加载

- (MBProgressHUD*)hud
{
    if (!_hud)
    {
        _hud = [[MBProgressHUD alloc] initWithFrame:self.bounds];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _hud;
}

- (UIWebView*)webView
{
    if (!_webView) {
        
        _webView = [UIWebView new];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (void)dealloc
{
    _hud = nil;
    
    _webView = nil;
}
@end
