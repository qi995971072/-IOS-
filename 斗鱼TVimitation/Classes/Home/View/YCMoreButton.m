//
//  YCMoreButton.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCMoreButton.h"

@implementation YCMoreButton

- (instancetype)init {
    if (self = [super init]) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width * 0.7;
    self.titleLabel.y = 0;
    self.titleLabel.height = self.height;
    
    self.imageView.x = self.titleLabel.width;
    self.imageView.y = 0;
    self.imageView.width = self.width - self.imageView.x;
    self.imageView.height = self.height;
}


@end
