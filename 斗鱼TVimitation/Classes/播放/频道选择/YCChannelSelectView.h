//
//  YCChannelSelectView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCChannelSelectView;
@protocol YCChannelSelectViewDelegate <NSObject>

@optional

- (void)channelSelectView:(YCChannelSelectView *)view didClickBtn:(UIButton *)btn;

@end

@interface YCChannelSelectView : UIView

+ (instancetype)channelSelectView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *superDefinitionBtn;

@property (weak, nonatomic) IBOutlet UIButton *highDefinitionBtn;

@property (weak, nonatomic) IBOutlet UIButton *normalDefinitionBtn;

@property (nonatomic,weak) id<YCChannelSelectViewDelegate> delegate;


@end
