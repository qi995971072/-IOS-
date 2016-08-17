//
//  YCHttpManager.h
//  亿企短信群发助手
//
//  Created by xiaochong on 16/5/14.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


@interface YCHttpManager : AFHTTPSessionManager

+ (id)sharedInstance;

@end
