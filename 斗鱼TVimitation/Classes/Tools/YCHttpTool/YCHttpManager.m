//
//  YCHttpManager.m
//  亿企短信群发助手
//
//  Created by xiaochong on 16/5/14.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCHttpManager.h"

@implementation YCHttpManager

static YCHttpManager *_sharedInstance = nil;

+ (id)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [self manager];
        _sharedInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedInstance.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedInstance.requestSerializer.timeoutInterval = 10;

    });
    
    return _sharedInstance;
}


@end
