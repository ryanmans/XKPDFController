//
//  XKWebViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKWebViewController.h"
#import "XKPDFWebViewController.h"

@interface XKWebViewController ()

@end

@implementation XKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"WebView浏览";
    
    XKPDFWebViewController * _pdfWebVC = [[XKPDFWebViewController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VALID_VIEW_HEIGHT)];
    
    //在线
    //_pdfWebVC.fileUrl = @"http://public.cdn.sinoxk.com/cms/customer/train/files/OosdEJIzUCb9.pdf";
    
    //本地
    _pdfWebVC.filePath = [XKFileManagerInstance xk_GetMainBundlePathForResource:@"xktest" ofType:@"pdf"];
    
    [self.view addSubview:_pdfWebVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
