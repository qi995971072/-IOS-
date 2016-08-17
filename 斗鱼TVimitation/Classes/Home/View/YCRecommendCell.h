//
//  YCRecommendCell.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRoomGroup.h"

@class YCRoom;
typedef void (^PlayBlock)(YCRoom *room);

@interface YCRecommendCell : UITableViewCell
/**
 *  创给cell的数据
 */
@property (nonatomic,strong) NSArray *rooms;

/**
 *  额外自己加的一个来判断颜值分组的属性
 */
@property (nonatomic,copy) NSString *groupName;

@property (nonatomic,copy) PlayBlock block;
@end
