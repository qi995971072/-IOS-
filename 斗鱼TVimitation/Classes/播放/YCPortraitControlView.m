//
//  YCPortraitControlView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/24.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCPortraitControlView.h"
#import <Masonry.h>

@interface YCPortraitControlView ()
/**
 *  返回按钮
 */
@property (nonatomic,weak) UIButton *backBtn;
/**
 *  更多按钮
 */
@property (nonatomic,weak) UIButton *moreBtn;
/**
 *  分享和举报的父控件
 */
@property (nonatomic,weak) UIImageView *moreView;
/**
 *  分享按钮
 */
@property (nonatomic,weak) UIButton *shareBtn;
/**
 *  举报按钮
 */
@property (nonatomic,weak) UIButton *reportBtn;
/**
 *  送花按钮
 */
@property (nonatomic,weak) UIButton *giftBtn;
/**
 *  播放和暂停按钮
 */
@property (nonatomic,weak) UIButton *playOrPauseBtn;
/**
 *  全屏
 */
@property (nonatomic,weak) UIButton *fullScreenBtn;

@end

@implementation YCPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
                
        // 添加子控件
        // 返回按钮
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"dyla_返回_36x36_"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"dyla_返回pressed_36x36_"] forState:UIControlStateHighlighted];
        [self addSubview:backBtn];
        self.backBtn = backBtn;

        
        // 分享和举报
        UIButton *moreBtn = [[UIButton alloc] init];
        [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setImage:[UIImage imageNamed:@"btn_v_more_34x34_"] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"btn_v_more_h_34x34_"] forState:UIControlStateHighlighted];
        [self addSubview:moreBtn];
        self.moreBtn = moreBtn;

        // 送花
        UIButton *giftBtn = [[UIButton alloc] init];
        [giftBtn addTarget:self action:@selector(giftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [giftBtn setImage:[UIImage imageNamed:@"btn_close_gift_select_36x36_"] forState:UIControlStateNormal];
        [giftBtn setImage:[UIImage imageNamed:@"btn_close_gift_selectHighlight-1_36x36_"] forState:UIControlStateHighlighted];
        [self addSubview:giftBtn];
        self.giftBtn = giftBtn;
        
        // 播放和暂停
        UIButton *playOrPauseBtn = [[UIButton alloc] init];
        [playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_pause_36x36_"] forState:UIControlStateNormal];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_pause_h_36x36_"] forState:UIControlStateHighlighted];
        [self addSubview:playOrPauseBtn];
        self.playOrPauseBtn = playOrPauseBtn;
        
        // 全屏
        UIButton *fullScreenBtn = [[UIButton alloc] init];
        [fullScreenBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_vdo_full_36x36_"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_vdo_full_click_36x36_"] forState:UIControlStateHighlighted];
        [self addSubview:fullScreenBtn];
        self.fullScreenBtn = fullScreenBtn;
    
        
        // 点击了更多显示的view
        UIImageView *moreView = [[UIImageView  alloc] init];
        moreView.hidden = YES;
        moreView.userInteractionEnabled = YES;
        moreView.alpha = 0.6;
        moreView.image = [UIImage imageNamed:@"Image_more_bg_88x80_"];
        moreView.frame = CGRectMake(0, 300, 80, 60);
        [self addSubview:moreView];
        self.moreView = moreView;
        

        
        UIButton *shareBtn = [[UIButton alloc] init];
        [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setImage:[UIImage imageNamed:@"btn_h_share_22x22_"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"btn_h_share_highlight_22x22_"] forState:UIControlStateHighlighted];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [moreView addSubview:shareBtn];
        self.shareBtn = shareBtn;
        
        UIButton *reportBtn = [[UIButton alloc] init];
        [reportBtn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setImage:[UIImage imageNamed:@"report_18x18_"] forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        reportBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [moreView addSubview:reportBtn];
        self.reportBtn = reportBtn;
        
        [self makeSubViewsConstraints];
        
    }
    return self;
}

- (void)makeSubViewsConstraints {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.height.offset(35);
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(5);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.height.offset(35);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width * 9 / 16  - 35 * 4 - 2 * 5) / 3;

    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.height.offset(35);
        make.top.equalTo(self.moreBtn.mas_bottom).offset(margin);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.height.offset(35);
        make.top.equalTo(self.giftBtn.mas_bottom).offset(margin);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.height.offset(35);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.moreBtn.mas_left).offset(-5);
        make.width.offset(80);
        make.height.offset(60);
    }];

    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreView.mas_top);
        make.left.equalTo(self.moreView.mas_left);
        make.height.offset(30);
        make.right.equalTo(self.moreView.mas_right);
    }];

    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareBtn.mas_bottom);
        make.left.equalTo(self.moreView.mas_left);
        make.height.offset(30);
        make.right.equalTo(self.moreView.mas_right);
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointAtBackBtn = CGRectContainsPoint(self.backBtn.frame, point);
    BOOL pointAtMoreBtn = CGRectContainsPoint(self.moreBtn.frame, point);
    BOOL pointAtMoreView = CGRectContainsPoint(self.moreView.frame, point);
    BOOL pointAtGiftBtn = CGRectContainsPoint(self.giftBtn.frame, point);
    BOOL pointAtPlayOrPauseBtn = CGRectContainsPoint(self.playOrPauseBtn.frame, point);
    BOOL pointAtFullScreenBtn = CGRectContainsPoint(self.fullScreenBtn.frame, point);
    
    if (pointAtBackBtn || pointAtMoreBtn || pointAtMoreView || pointAtGiftBtn || pointAtPlayOrPauseBtn || pointAtFullScreenBtn) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}

#pragma mark 按钮的点击事件集合
- (void)moreBtnClick:(UIButton *)btn {
    self.moreView.hidden = !self.moreView.hidden;
}

/**
 *  点击了返回
 */
- (void)back {
    if ([self.delegate respondsToSelector:@selector(portControlViewDidClickBackBtn:)]) {
        [self.delegate portControlViewDidClickBackBtn:self];
    }
}
/**
 *  点击了送礼物
 */
- (void)giftBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:@"btn_close_gift_select_36x36_"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_close_gift_selectHighlight-1_36x36_"] forState:UIControlStateHighlighted];
    } else {
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:@"btn_close_gift_36x36_"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_close_gift_highlight_36x36_"] forState:UIControlStateHighlighted];
    }
}

/**
 *  点击了播放和暂停
 */
- (void)playOrPause:(UIButton *)btn {
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayStateShouldChanged" object:nil];
}

- (void)setIsPlaying:(BOOL)isPlaying {
    if (isPlaying) {
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_pause_36x36_"] forState:UIControlStateNormal];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_pause_h_36x36_"] forState:UIControlStateHighlighted];
    } else {
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_play_36x36_"] forState:UIControlStateNormal];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_v_play_h_36x36_"] forState:UIControlStateHighlighted];
    }
}

/**
 *  点击了分享
 */
- (void)share:(UIButton *)btn {
    NSLog(@"分享");
    self.moreView.hidden = YES;
}
/**
 *  点击了举报
 */
- (void)report:(UIButton *)btn {
    NSLog(@"举报");
    self.moreView.hidden = YES;
}

- (void)fullScreen {
    if ([self.delegate respondsToSelector:@selector(portControlView:setLandScape:)]) {
        [self.delegate portControlView:self setLandScape:UIInterfaceOrientationLandscapeRight];
    }
}
@end
