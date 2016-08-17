//
//  YCScrollModel.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCScrollModel.h"

@implementation YCScrollModel

+ (void)load {
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{ @"ID" : @"id"};
    }];
}

MJCodingImplementation
@end
