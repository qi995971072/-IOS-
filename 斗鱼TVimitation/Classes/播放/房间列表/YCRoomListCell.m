//
//  YCRoomListCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/8/5.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCRoomListCell.h"

@interface YCRoomListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *onlinePeopleLabel;

@end

@implementation YCRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:@"https://rpic.douyucdn.cn/z1608/05/18/424559_160805181731.jpg"]];
}

- (void)setRoom:(YCRoom *)room {
    _room = room;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:room.room_src]];
    self.roomNameLabel.text = room.room_name;

    int onlineNumber = room.online.intValue;
    if (onlineNumber < 10000) {
        self.onlinePeopleLabel.text = room.online;
    } else {
        self.onlinePeopleLabel.text = [NSString stringWithFormat:@"%0.1f万",[room.online doubleValue] / 10000];
    }
}

@end
