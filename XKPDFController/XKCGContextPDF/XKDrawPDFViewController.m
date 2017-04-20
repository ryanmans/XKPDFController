//
//  XKDrawPDFViewController.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "XKDrawPDFViewController.h"
#import "XKDrawPDFPageViewController.h"
#import "XKDrawBackViewController.h"

#import <UIKit/UIPageViewController.h>

@interface XKDrawPDFViewController () <UIPageViewControllerDataSource>
{
    CGPDFDocumentRef _pdfDocument;
    
    UIPageViewController * _pageViewController;
    
    UIViewController * _currentPageViewController; //当前
}
@end

@implementation XKDrawPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //创建CGPDFDocument对象
   
    _pdfDocument = [self xk_InitPDFDocumentRefByFilePath:[XKFileManagerInstance xk_GetMainBundlePathForResource:@"xktest" ofType:@"pdf"]];
    
    
    // UIPageViewControllerSpineLocationMin 单页显示
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];

    
    //初始化UIPageViewController，UIPageViewControllerTransitionStylePageCurl翻页效果，UIPageViewControllerNavigationOrientationHorizontal水平方向翻页

    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    //设置UIPageViewController的数据源
    _pageViewController.dataSource = self;
    
    //设置正反面都有文字
    _pageViewController.doubleSided = YES;
    
    //承载pdf每页内容的控制器
    XKDrawPDFPageViewController * xk_pageController = [self xk_ViewControllerAtIndex:1 pdfDocument:_pdfDocument];
    
    //设置pageViewCtrl的子控制器
    [_pageViewController setViewControllers:@[xk_pageController]
                           direction:UIPageViewControllerNavigationDirectionReverse
                            animated:NO
                          completion:^(BOOL f){}];
    
    [self addChildViewController:_pageViewController];
    
    [self.view addSubview:_pageViewController.view];
    
    //当我们向我们的视图控制器容器（就是父视图控制器，它调用addChildViewController方法加入子视图控制器，它就成为了视图控制器的容器）中添加（或者删除）子视图控制器后，必须调用该方法，告诉iOS，已经完成添加（或删除）子控制器的操作。
    [_pageViewController didMoveToParentViewController:self];
}

//创建单页pdf控制器
- (XKDrawPDFPageViewController*)xk_ViewControllerAtIndex:(NSInteger)pageIndex pdfDocument:(CGPDFDocumentRef)pdfDocument
{

    NSInteger pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    
    if ((pageSum == 0 || pageSum >= (pageSum + 1))) return nil;
    
    XKDrawPDFPageViewController * pageController = [[XKDrawPDFPageViewController alloc] init];
    pageController.pageIndex  = pageIndex;
    pageController.pdfDocument = pdfDocument;
    return pageController;
}

//获取每个视图的下标位置
- (NSUInteger)xk_GetIndexOfViewController:(XKDrawPDFPageViewController *)viewController {
    
    return viewController.pageIndex;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[XKDrawPDFPageViewController class]]) {
        
       _currentPageViewController = viewController;
        
        XKDrawBackViewController * xk_DrawBackVC = [[XKDrawBackViewController alloc] init];
        
        [xk_DrawBackVC xk_UpdateDrawBackViewController:viewController];
        
        return xk_DrawBackVC ;
    }
    
    //self.currentViewController保存的是后一个CGContextDrawPDFPageController，如果直接用viewController实际指的是backViewController，而其没有indexOfViewController：等方法程序会崩掉。

    NSInteger pageIndex = [self xk_GetIndexOfViewController:(XKDrawPDFPageViewController*)_currentPageViewController];
    
    if (pageIndex == 1 || pageIndex == NSNotFound) return nil;
    
    pageIndex --;
    
    return [self xk_ViewControllerAtIndex:pageIndex pdfDocument:_pdfDocument];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[XKDrawPDFPageViewController class]]) {
        
        _currentPageViewController = viewController;
        
        XKDrawBackViewController * xk_DrawBackVC = [[XKDrawBackViewController alloc] init];
        
        [xk_DrawBackVC xk_UpdateDrawBackViewController:viewController];
        
        return xk_DrawBackVC ;
    }

    //self.currentViewController保存的是后一个CGContextDrawPDFPageController，如果直接用viewController实际指的是backViewController，而其没有indexOfViewController：等方法程序会崩掉。
    
    NSInteger pageIndex = [self xk_GetIndexOfViewController:(XKDrawPDFPageViewController*)_currentPageViewController];

    if (pageIndex == NSNotFound) return nil;

    pageIndex ++;
    
    NSInteger pageSum = CGPDFDocumentGetNumberOfPages(_pdfDocument);
    
    if (pageIndex >= (pageSum + 1)) return nil;

    return [self xk_ViewControllerAtIndex:pageIndex pdfDocument:_pdfDocument];
}

#pragma mark -- 数据

//通过文件名 读取pdf文件里面的内容(文件必须存在于MainBundle)
- (CGPDFDocumentRef)xk_InitPDFDocumentRef:(NSString*)fileName
{
    //CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("test.pdf"), NULL, NULL);
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)fileName, NULL, NULL);
    
    //创建CGPDFDocument对象
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
    CFRelease(pdfURL);
    
    return pdfDocument;
}

//通过文件路径 读取pdf文件里面的内容
- (CGPDFDocumentRef)xk_InitPDFDocumentRefByFilePath:(NSString*)filePath
{
    
    CFStringRef cfPath = CFStringCreateWithCString(NULL, [filePath UTF8String], kCFStringEncodingUTF8);
    
    CFURLRef pdfURL = CFURLCreateWithFileSystemPath(NULL, cfPath, kCFURLPOSIXPathStyle, NO);

    //创建CGPDFDocument对象
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
    CFRelease(cfPath);

    CFRelease(pdfURL);
    
    return pdfDocument;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
