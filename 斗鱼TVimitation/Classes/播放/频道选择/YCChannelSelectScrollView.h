//
//  YCChannelSelectScrollView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCChannelSelectScrollView : UIScrollView

@property (nonatomic,strong) NSArray *channels;

/**
 *  选择了频道将会调用的block
 */
@property (nonatomic,copy) void (^selectedChannel)(NSString *title, NSString* channelString);

@end
