//
//  XKCGContextDrawPDFView.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKCGContextDrawPDFView.h"

@interface XKCGContextDrawPDFView ()
{
    NSInteger _pageIndex;
    
    CGPDFDocumentRef _pdfDocumentRef;
}
@end

@implementation XKCGContextDrawPDFView

- (instancetype)initWithFrame:(CGRect)frame pageIndex:(NSInteger)pageIndex pdfDoc:(CGPDFDocumentRef)pdfDoc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _pageIndex = pageIndex;
        
        _pdfDocumentRef = pdfDoc;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); // 拿到当前画板，在这个画板上画就是在视图上画
    
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (_pageIndex == 0) _pageIndex = 1;
        
    //获取指定页的pdf文档
    CGPDFPageRef page = CGPDFDocumentGetPage(_pdfDocumentRef, _pageIndex);
    
    //创建一个仿射变换，该变换基于将PDF页的BOX映射到指定的矩形中。
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    
    CGContextConcatCTM(context, pdfTransform);
    
    //将pdf绘制到上下文中
    CGContextDrawPDFPage(context, page);
}
@end
