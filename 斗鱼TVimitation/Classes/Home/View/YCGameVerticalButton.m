//
//  YCGameVerticalButton.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/17.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCGameVerticalButton.h"

@implementation YCGameVerticalButton
- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 修改图片
    self.imageView.width = self.width * 0.7;
    self.imageView.height = self.imageView.width;
    self.imageView.x = (self.width - self.imageView.width ) / 2;
    self.imageView.y = 0;
    
    // 修改标题
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor redColor];
}

- (void)setHighlighted:(BOOL)highlighted {}
@end
