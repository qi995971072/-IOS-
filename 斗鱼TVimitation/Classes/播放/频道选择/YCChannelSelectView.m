//
//  YCChannelSelectView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCChannelSelectView.h"

@interface YCChannelSelectView ()


@end

@implementation YCChannelSelectView

+ (instancetype)channelSelectView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YCChannelSelectView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    [self setAttrWithBtn:self.superDefinitionBtn];
    [self setAttrWithBtn:self.highDefinitionBtn];
    [self setAttrWithBtn:self.normalDefinitionBtn];
}

- (void)setAttrWithBtn:(UIButton *)btn {
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    sender.layer.borderColor = [UIColor orangeColor].CGColor;
    if ([self.delegate respondsToSelector:@selector(channelSelectView:didClickBtn:)]) {
        [self.delegate channelSelectView:self didClickBtn:sender];
    }
}



@end
