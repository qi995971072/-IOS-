//
//  YCFaceCollectionViewCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/17.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCFaceCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface YCFaceCollectionViewCell ()

/**
 *  房间ImageView
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  当前在线的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *onlinePeopleLabel;

/**
 *  标题
 */
@property (strong, nonatomic) IBOutlet UILabel *roomNameLabel;
/**
 *  位置
 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation YCFaceCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    
    self.onlinePeopleLabel.layer.cornerRadius = 3;
    self.onlinePeopleLabel.layer.masksToBounds = YES;
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
    
    /**
     *  在线数量
     */
    int onlineNumber = room.online.intValue;
    if (onlineNumber < 10000) {
        self.onlinePeopleLabel.text = [NSString stringWithFormat:@"%@人在线",room.online];
    } else {
        self.onlinePeopleLabel.text = [NSString stringWithFormat:@"%0.1f万人在线",[room.online doubleValue]/10000];
    }
    
    /**
     *  位置
     */
    if (room.anchor_city) {
        self.locationLabel.text = room.anchor_city;
    } else {
        self.locationLabel.text = @"南阳理工学院";
    }
}

@end
