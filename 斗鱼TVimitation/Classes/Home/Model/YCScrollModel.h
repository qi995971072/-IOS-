//
//  YCScrollModel.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCRoom.h"

@interface YCScrollModel : NSObject

@property(nonatomic,copy) NSString *ID;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) NSString *pic_url;

@property(nonatomic,copy) NSString *tv_pic_url;

@property(nonatomic,strong) YCRoom *room;

@end
