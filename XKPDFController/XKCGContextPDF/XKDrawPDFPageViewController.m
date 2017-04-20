//
//  XKDrawPDFPageViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKDrawPDFPageViewController.h"
#import "XKCGContextDrawPDFView.h"
@interface XKDrawPDFPageViewController ()

@end

@implementation XKDrawPDFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XKCGContextDrawPDFView * xk_DrawPDFView = [[XKCGContextDrawPDFView alloc] initWithFrame:self.view.bounds pageIndex:self.pageIndex pdfDoc:self.pdfDocument];
    
    [self.view addSubview:xk_DrawPDFView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
