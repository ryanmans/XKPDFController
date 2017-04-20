//
//  XKDrawBackViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKDrawBackViewController.h"

@interface XKDrawBackViewController ()
{
    UIImageView * _pdfImageView;
}
@end

@implementation XKDrawBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pdfImageView = [UIImageView new];
    _pdfImageView.bounds = self.view.bounds;
    [self.view addSubview:_pdfImageView];
}

//更新
- (void)xk_UpdateDrawBackViewController:(UIViewController*)targetViewController
{
    _pdfImageView.image = [self xk_CaptureView:targetViewController.view];
}

//绘制图片
- (UIImage*)xk_CaptureView:(UIView*)view
{
    CGRect rect = view.bounds;

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0.0);

    CGContextConcatCTM(context,transform);

    [view.layer renderInContext:context];

    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
