//
//  XKCGContextDrawPDFView.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <UIKit/UIKit.h>

//画出pdf
@interface XKCGContextDrawPDFView : UIView
- (instancetype)initWithFrame:(CGRect)frame pageIndex:(NSInteger)pageIndex pdfDoc:(CGPDFDocumentRef)pdfDoc;

@end
