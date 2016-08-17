//
//  YCRoomList.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCTag.h"

@implementation YCTag

+ (void)load {
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return @{ @"room_list" : [YCRoom class]};
    }];
}

- (BOOL)isEqual:(YCTag *)object {
    if ([object.tag_id isEqualToString:self.tag_id] && [object.tag_name isEqualToString:self.tag_name]) {
        return YES;
    }
    return NO;
}

MJCodingImplementation

@end
