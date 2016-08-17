//
//  YCCollectionViewCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface YCCollectionViewCell ()

/**
 *  房间ImageView
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

/**
 *  主播名字
 */
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 *  在线人数
 */
@property (strong, nonatomic) IBOutlet UILabel *onlinePeople;

/**
 *  标题
 */
@property (strong, nonatomic) IBOutlet UILabel *roomNameLabel;

@end

@implementation YCCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setRoom:(YCRoom *)room {
    _room = room;
    
    /**
     *  房间图片
     */
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:room.room_src] placeholderImage:[UIImage imageNamed:@"live_cell_default_phone_103x103_"]];
    
    /**
     *  房间名
     */
    self.roomNameLabel.text = room.room_name;
    
    self.nickNameLabel.text = room.nickname;

    /**
     *  在线数量
     */
    int onlineNumber = room.online.intValue;
    if (onlineNumber < 10000) {
        self.onlinePeople.text = room.online;
    } else {
        self.onlinePeople.text = [NSString stringWithFormat:@"%0.1f万",[room.online doubleValue]/10000];
    }
}


@end
