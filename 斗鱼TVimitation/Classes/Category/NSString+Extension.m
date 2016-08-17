//
//  NSString+Extension.m
//  亿企短信群发助手
//
//  Created by xiaochong on 16/6/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)urlEncode {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:enc];
    return [[[NSString alloc] initWithData:data encoding:enc] stringByAddingPercentEscapesUsingEncoding:enc];
}

+ (NSString *)GetNowTimes
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    return timeString;
}


@end
