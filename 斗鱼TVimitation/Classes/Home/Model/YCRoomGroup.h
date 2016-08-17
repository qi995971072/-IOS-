//
//  YCRoomGroup.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCRoomGroup : NSObject

@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,copy) NSString *groupImage;

@property (nonatomic,strong) NSArray *rooms;

@property (nonatomic,assign) CGFloat cellHeight;

@end
