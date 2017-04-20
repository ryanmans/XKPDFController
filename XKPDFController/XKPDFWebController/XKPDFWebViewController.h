//
//  XKPDFWebViewController.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <UIKit/UIKit.h>

//UIWebView 加载pdf 视图 控件
@interface XKPDFWebViewController : UIView
@property (nonatomic,copy)NSString * fileUrl; //在线下载链接
@property (nonatomic,copy)NSString * filePath; //本地文件路径
@end
