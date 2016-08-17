//
//  YCVerticalButton.m
//  百思不得姐
//
//  Created by xiaochong on 16/3/12.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCVerticalButton.h"

@implementation YCVerticalButton


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
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 修改标题
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 5;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    self.imageView.clipsToBounds = YES;
}
@end
