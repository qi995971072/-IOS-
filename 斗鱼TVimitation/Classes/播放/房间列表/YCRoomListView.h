//
//  YCRoomListView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/8/5.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRoom.h"

@class YCRoomListView;
@protocol YCRoomListViewDelegate <NSObject>

@optional
- (void)roomListView:(YCRoomListView *)roolListView didSelectRoom:(YCRoom *)room;

@end

@interface YCRoomListView : UIView

@property (nonatomic,strong) NSArray *rooms;

@property (nonatomic,weak) id<YCRoomListViewDelegate> delegate;

@end
