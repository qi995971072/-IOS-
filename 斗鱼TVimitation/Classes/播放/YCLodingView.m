//
//  YCLodingView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/23.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLodingView.h"
#import <Masonry.h>

@interface YCLodingView ()

@property (nonatomic,weak) UIImageView *animView;

@end

@implementation YCLodingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 动画
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.animationImages = @[ [UIImage imageNamed:@"image_loading_player01_108x100_"],
                                       [UIImage imageNamed:@"image_loading_player02_108x100_"],
                                       [UIImage imageNamed:@"image_loading_player03_108x100_"]
                                       ];
        imageView.animationDuration = 0.5;
        imageView.animationRepeatCount = MAXFLOAT;
        [imageView startAnimating];
        [self addSubview:imageView];
        self.animView = imageView;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(216);
            make.height.equalTo(self.mas_height).multipliedBy(0.7);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top);
        }];
        
        // 文字
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.text = @"视频加载中...";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(216);
            make.height.equalTo(self.mas_height).multipliedBy(0.1);
            make.top.equalTo(imageView.mas_bottom).offset(-20);;
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    return self;
}

- (void)starAnim {
    [self.animView startAnimating];
}

- (void)stopAnim {
    [self.animView stopAnimating];
}

@end
