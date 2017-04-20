//
//  NSString+XK.m
//  XKPDFController
//
//  Created by RyanMans on 17/4/19.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "NSString+XK.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (XK)

//md5 加密
- (NSString*)xk_MD5Encoding
{
    const char * utfString = self.UTF8String;
    
    unsigned char  result [16] = {0};
    
    CC_MD5(utfString, (CC_LONG)strlen(utfString), result);
    
    char szOutput[33] = { 0 };
    
    for (int index = 0; index < 16; index++)
    {
        unsigned char src = result[index];
        
        sprintf(szOutput, "%s%02x",szOutput,src);
    }
    return [NSString stringWithUTF8String:szOutput];
    
}

//utf - 8
- (NSString*)xk_UTF8Encoding
{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)IsSafeString(self),NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    return encodedString;
}

//判断是否是纯中文
- (BOOL)xk_IsChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

// 判断是否是包含有中文
- (BOOL)xk_IsIncludeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00 && a <0x9fff){
            return YES;
        }
    }
    return NO;
}
@end
