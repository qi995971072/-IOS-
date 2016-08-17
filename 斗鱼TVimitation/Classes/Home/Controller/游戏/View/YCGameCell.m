//
//  YCGameCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/17.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCGameCell.h"
#import "YCGameVerticalButton.h"
#import "YCTag.h"

@implementation YCGameCell

- (void)setAllTags:(NSArray *)allTags {
    _allTags = allTags;
    
    // 设置所有的button的frame
    CGFloat btnW = GameBtnW;
    CGFloat btnH = GameBtnH;
    CGFloat margin = GameBtnMargin;
    CGFloat btnMargin = (self.width - 2 * margin - 3 * btnW ) / 2;
    for (int i = 0; i < allTags.count; i++) {
        YCTag *tag = allTags[i];
        CGFloat btnX = 20 + (i % 3) * ( btnW + btnMargin);
        CGFloat btnY = margin + (i / 3) * (btnH + 2 * margin);
        YCGameVerticalButton *btn = [[YCGameVerticalButton alloc] init];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:tag.tag_name forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:tag.icon_url] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        UIView *divider = [[UIView alloc] init];
        divider.alpha = 0.1;
        divider.frame = CGRectMake(20, btnY + btnH - 1 + 20, self.width - 40, 1);
        divider.backgroundColor = [UIColor grayColor];
        [self addSubview:divider];
    }
}

@end
