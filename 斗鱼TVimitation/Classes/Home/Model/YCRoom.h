//
//  YCRoom.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YCRoom : NSObject
/**
 *  房间号
 */
@property(nonatomic,copy) NSString *room_id;
/**
 *  房间图片
 */
@property(nonatomic,copy) NSString *room_src;

@property(nonatomic,copy) NSString *vertical_src;

@property(nonatomic,copy) NSString *isVertical;

@property(nonatomic,copy) NSString *cate_id;
/**
 *  房间名
 */
@property(nonatomic,copy) NSString *room_name;

@property(nonatomic,copy) NSString *show_status;

@property (nonatomic,copy) NSString *subject;

@property(nonatomic,copy) NSString *show_time;

@property(nonatomic,copy) NSString *vod_quality;

@property(nonatomic,copy) NSString *owner_uid;

@property(nonatomic,copy) NSString *specific_catalog;

@property(nonatomic,copy) NSString *specific_status;

@property(nonatomic,copy) NSString *credit_illegal;

@property(nonatomic,copy) NSString *is_white_list;

@property(nonatomic,copy) NSString *cur_credit;

@property(nonatomic,copy) NSString *low_credit;

@property(nonatomic,copy) NSString *online;

@property(nonatomic,copy) NSString *nickname;

@property(nonatomic,copy) NSString *url;

@property(nonatomic,copy) NSString *game_url;

@property(nonatomic,copy) NSString *game_name;

@property(nonatomic,copy) NSString *show_details;

@property(nonatomic,copy) NSString *owner_avatar;

@property(nonatomic,copy) NSString *is_pass_player;

@property(nonatomic,copy) NSString *game_icon_url;

@property(nonatomic,copy) NSString *owner_weight;

@property (nonatomic,copy) NSString *child_id;
@property (nonatomic,copy) NSString *ranktype;

@property (nonatomic,copy) NSString *anchor_city;

/**
 *  粉丝数
 */
@property(nonatomic,copy) NSString *fans;

@property(nonatomic,strong) NSArray *cdnsWithName;


/*"room_id": "503867",
 "room_src": "http://staticlive.douyutv.com/upload/appCovers/503867/20160607/9a4e0794a23f0f2b8629a14c76900531_small.jpg",
 "vertical_src": "http://staticlive.douyutv.com/upload/appCovers/503867/20160607/9a4e0794a23f0f2b8629a14c76900531_big.jpg",
 "isVertical": 1,
 "cate_id": "201",
 "room_name": "早起搬砖化妆中",
 "show_status": "1",
 "subject": "",
 "show_time": "1468715329",
 "owner_uid": "29603764",
 "specific_catalog": "",
 "specific_status": "0",
 "vod_quality": "0",
 "nickname": "DG丶菜爷",
 "online": 25133,
 "game_name": "颜值",
 "child_id": "0",
 "ranktype": 0,
 "anchor_city": "鱼塘"*/

@end
