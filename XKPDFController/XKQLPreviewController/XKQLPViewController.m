//
//  XKQLPViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKQLPViewController.h"
#import "XKQLPreviewController.h"
@interface XKQLPViewController ()

@end

@implementation XKQLPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"QLPreviewController浏览";
    
    XKQLPreviewController * _qlpController = [[XKQLPreviewController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VALID_VIEW_HEIGHT)];
    
    _qlpController.fileUrl = @"http://public.cdn.sinoxk.com/cms/customer/train/files/OosdEJIzUCb9.pdf";
    
    [_qlpController xk_ShowInController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
