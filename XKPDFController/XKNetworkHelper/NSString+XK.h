//
//  NSString+XK.h
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IsSafeString(x)           ((x != nil && x.length != 0)? x : @"")

@interface NSString (XK)

/**
 *  MD5加密
 *
 *  @return  MD5Encoding
 */
- (NSString*)xk_MD5Encoding;

/**
 *  UTF - 8 加密
 *
 *  @return  UTF8Encoding
 */
- (NSString*)xk_UTF8Encoding;

/**
 *  判断是否是纯中文
 *
 *  @return   yes / no
 */
- (BOOL)xk_IsChinese;

/**
 *  判断是否是包含有中文
 *
 *  @return   yes / no
 */
- (BOOL)xk_IsIncludeChinese;
@end
