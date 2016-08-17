//
//  YCChannelSelectScrollView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCChannelSelectScrollView.h"
#import "YCChannelSelectView.h"

@interface YCChannelSelectScrollView () <YCChannelSelectViewDelegate>

@property (nonatomic,strong) UIButton *lastBtn;

@end

@implementation YCChannelSelectScrollView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)setChannels:(NSArray *)channels {
    _channels = channels;
    
    for (int i = 0; i < channels.count; i++) {
        YCChannelSelectView *channelSelectView = [YCChannelSelectView channelSelectView];
        if (i == 0) {
            self.lastBtn = channelSelectView.normalDefinitionBtn;
            channelSelectView.normalDefinitionBtn.selected = YES;
            channelSelectView.normalDefinitionBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        }
        channelSelectView.delegate = self;
        channelSelectView.titleLabel.text = channels[i];
        [self addSubview:channelSelectView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewH = 70;
    for (int i = 0; i < self.subviews.count; i++) {
        YCChannelSelectView *channelSelectView = self.subviews[i];
        channelSelectView.frame = CGRectMake(0, i * viewH, self.width, viewH);
    }
    self.contentSize = CGSizeMake(0, self.subviews.count * viewH);
}

#pragma mark - YCChannelSelectViewDelegate
- (void)channelSelectView:(YCChannelSelectView *)view didClickBtn:(UIButton *)btn {
    self.lastBtn.selected = NO;
    self.lastBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.selectedChannel(view.titleLabel.text, [btn titleForState:UIControlStateNormal]);
    
    self.lastBtn = btn;
}

@end
