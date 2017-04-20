//
//  XKBaseViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKBaseViewController.h"
#import "XKWebViewController.h"
#import "XKQLPViewController.h"
#import "ReaderViewController.h"
#import "XKDrawPDFViewController.h"

@interface XKBaseViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate>
@property (nonatomic,strong)UITableView * displayTableView;
@end

@implementation XKBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"PDF展现方式";
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"返回";
    
    self.navigationItem.backBarButtonItem = backItem;

    
    [self.view addSubview:self.displayTableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentity = @"xkBaseTableViewCellId";
    
    UITableViewCell * xk_ListCell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!xk_ListCell) {
        
        xk_ListCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
    }
    
    xk_ListCell.textLabel.textColor = [UIColor blackColor];

    switch (indexPath.row) {
            
        case 0:
        {
            xk_ListCell.textLabel.text = @"PDF-WebView浏览";
        }
            break;

        case 1:
        {
            xk_ListCell.textLabel.text = @"PDF-QLPreviewController浏览";
        }
            break;
            
        case 2:
        {
            xk_ListCell.textLabel.text = @"PDF - Reader";
        }
            break;
            
        case 3:
        {
            xk_ListCell.textLabel.text = @"PDF - CGContext DrawPDFPage";
        }
            break;
            
        default:
            break;
    }
    
    return xk_ListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            //UIWebView加载pdf文件（常用）
            XKWebViewController *webViewVC = [[XKWebViewController alloc] init];
            [self.navigationController pushViewController:webViewVC animated:YES];
        
        }
            break;
        case 1:
        {
            //QLPreviewController 加载pdf文件（常用）
            XKQLPViewController * qlpVC = [[XKQLPViewController alloc] init];
            [self.navigationController pushViewController:qlpVC animated:YES];
        }
            break;
        case 2:
        {
            //Reader初始化 加载本地pdf文件（参考）
            ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:[XKFileManagerInstance xk_GetMainBundlePathForResource:@"xktest" ofType:@"pdf"] password:nil]; //解析pdf文件
            
            ReaderViewController *rederVC = [[ReaderViewController alloc] initWithReaderDocument:doc];
            rederVC.delegate = self;
            rederVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            rederVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.navigationController pushViewController:rederVC animated:YES];

        }
            break;
            
        case 3:
        {
            //跳到XKDrawPDFViewController控制器，利用CGContext 画pdf

            XKDrawPDFViewController * xk_DrawPDFVC = [[XKDrawPDFViewController alloc] init];

            [self.navigationController pushViewController:xk_DrawPDFVC animated:YES];
            
        }
            break;
    }
    
}

#pragma mark - ReaderViewControllerDelegate

//因为PDF阅读器可能是push出来的，也可能是present出来的，为了更好的效果，这个代理方法可以实现很好的退出
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 懒加载

- (UITableView*)displayTableView
{
    if (!_displayTableView) {
        
        _displayTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _displayTableView.delegate = self;
        _displayTableView.dataSource = self;
        _displayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _displayTableView;
}

- (void)dealloc
{
    _displayTableView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
