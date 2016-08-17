//
//  NSDate+Extension.m
//  亿企短信群发助手
//
//  Created by xiaochong on 16/5/27.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)nowDateString {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    return [fmt stringFromDate:[NSDate date]];
}

@end
