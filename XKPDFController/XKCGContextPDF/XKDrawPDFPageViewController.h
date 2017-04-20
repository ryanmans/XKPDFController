//
//  XKDrawPDFPageViewController.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <UIKit/UIKit.h>

//每页pdf 视图
@interface XKDrawPDFPageViewController : UIViewController
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) CGPDFDocumentRef pdfDocument;
@end
