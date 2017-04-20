//
//  XKQLPreviewController.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用系统原生控件 加载 pdf，
@interface XKQLPreviewController : UIView

@property (nonatomic,copy)NSString * fileUrl;//在线下载链接

//展现在控制器中
- (void)xk_ShowInController:(UIViewController*)viewController;

@end
