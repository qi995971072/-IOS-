//
//  YCRoom.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCRoom.h"
#import "YCCdsn.h"

@implementation YCRoom

+ (void)load {
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"cdnsWithName" : [YCCdsn class]};
    }];
}

MJCodingImplementation
@end
