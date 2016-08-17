//
//  YCLiveDownView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveDownView.h"
#import "YCTag.h"
#import "YCLiveDownButtonView.h"

@interface YCLiveDownView ()

@property (nonatomic,strong) YCLiveDownButtonView *lastButtonView;

@property (nonatomic,strong) NSMutableArray *buttonViews;

@end

@implementation YCLiveDownView

- (NSMutableArray *)buttonViews {
    if (!_buttonViews) {
        _buttonViews = [NSMutableArray array];
    }
    return _buttonViews;
}

- (void)setTags:(NSArray *)tags {
    
    if (tags.count == 0) {
        return;
    }
    
    _tags = tags;
    
    YCLiveDownButtonView *allBtnView = [YCLiveDownButtonView downButtonView];
    allBtnView.tagNameLabel.text = @"全部";
    allBtnView.tagIconView.image = [UIImage imageNamed:@"column_all_live_44x44_"];
    allBtnView.checkIconView.hidden = NO;
    [self addSubview:allBtnView];
    self.lastButtonView = allBtnView;
    [self.buttonViews addObject:allBtnView];
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClick:)];
    [allBtnView addGestureRecognizer:tap];
    
    for (int i = 0; i < tags.count; i++) {
        YCTag *tag = tags[i];
        YCLiveDownButtonView *btn = [YCLiveDownButtonView downButtonView];
        [btn.tagIconView sd_setImageWithURL:[NSURL URLWithString:tag.icon_url]];
        btn.tagNameLabel.text = tag.tag_name;
        [self addSubview:btn];
        [self.buttonViews addObject:btn];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClick:)];
        [btn addGestureRecognizer:tap];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < self.buttonViews.count; i++) {
        YCLiveDownButtonView *btn = self.buttonViews[i];
        btnX = (i) % 3 * btnW;
        btnY = (i) / 3 * btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    self.contentSize = CGSizeMake(0, (self.buttonViews.count + 3 - 1) / 3 * btnH);
}

- (void)buttonViewClick:(UITapGestureRecognizer *)tapGest {
    YCLiveDownButtonView *btn = (YCLiveDownButtonView *)tapGest.view;
    if (![self.lastButtonView.tagNameLabel.text isEqualToString:btn.tagNameLabel.text]) {
        self.lastButtonView.checkIconView.hidden = YES;
        btn.checkIconView.hidden = NO;
        self.lastButtonView = btn;
        if ([self.downViewDelegate respondsToSelector:@selector(liveDownView:DidClickDownButtonViewName:)]) {
            [self.downViewDelegate liveDownView:self DidClickDownButtonViewName:btn.tagNameLabel.text];
        }
    }
}

/**
 *  重新设置下拉列表选中的按钮
 */
- (void)selectButtonViewName:(NSString *)btnName {
    for (YCLiveDownButtonView *btn in self.buttonViews) {
        if ([btn.tagNameLabel.text isEqualToString:btnName]) {
            self.lastButtonView.checkIconView.hidden = YES;
            btn.checkIconView.hidden = NO;
            self.lastButtonView = btn;
        }
    }
}

@end
