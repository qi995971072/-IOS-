
//
//  YCMeHeaderView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/8/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCMeHeaderView.h"
#import "YCBottomButton.h"
#import <Masonry.h>

@interface YCMeHeaderView ()
/**
 *  背景图片
 */
@property (nonatomic,weak) UIImageView *backgroundView;
/**
 *  消息按钮
 */
@property (nonatomic,weak) UIButton *messageBtn;
/**
 *  编写个人信息按钮
 */
@property (nonatomic,weak) UIButton *myInfoBtn;
/**
 *  头像
 */
@property (nonatomic,weak) UIImageView *iconView;
/**
 *  等级图片
 */
@property (nonatomic,weak) UIImageView *levelView;
/**
 *  昵称label
 */
@property (nonatomic,weak) UILabel *nameLabel;
/**
 *  鱼丸、鱼翅label
 */
@property (nonatomic,weak) UILabel *fishBallLabel;
/**
 *  直播按钮
 */
@property (nonatomic,weak) UIButton *liveBtn;
/**
 *  观看历史
 */
@property (nonatomic,weak) YCBottomButton *hisBtn;
/**
 *  关注管理
 */
@property (nonatomic,weak) YCBottomButton *focusManageBtn;
/**
 *  鱼丸任务
 */
@property (nonatomic,weak) YCBottomButton *fishTaskBtn;
/**
 *  鱼翅充值
 */
@property (nonatomic,weak) YCBottomButton *finTopUpBtn;

@end

@implementation YCMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setup {
    
    // 0.背景图片
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_userView_background_375x227_"]];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    // 1.消息按钮
    UIButton *messageBtn = [[UIButton alloc] init];
    [messageBtn setImage:[UIImage imageNamed:@"image_message_unread_23x23_"] forState:UIControlStateNormal];
    [self addSubview:messageBtn];
    self.messageBtn = messageBtn;
    
    // 2.编写个人信息按钮
    UIButton *myInfoBtn = [[UIButton alloc] init];
    [myInfoBtn setImage:[UIImage imageNamed:@"dyla_btn_cover_upload_16x16_"] forState:UIControlStateNormal];
    [self addSubview:myInfoBtn];
    self.myInfoBtn = myInfoBtn;
    
    // 3.头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"dy015"];
    [self addSubview:iconView];
    self.iconView = iconView;
    self.iconView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.iconView.layer.cornerRadius = 40;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.layer.borderWidth = 5;
    self.iconView.layer.borderColor = YCColor(254, 190, 0).CGColor;
    
    // 4.等级
    UIImageView *levelView = [[UIImageView alloc] init];
    [levelView sd_setImageWithURL:[NSURL URLWithString:@"http://staticlive.douyucdn.cn/common/douyu/images/user_level/newm2_lv1.png?v=v48748"]];
    [self addSubview:levelView];
    self.levelView = levelView;
    
    // 5.昵称label
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"ITChong";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 6.鱼丸、鱼翅label
    UILabel *fishBallLabel = [[UILabel alloc] init];
    fishBallLabel.font = [UIFont systemFontOfSize:14];
    fishBallLabel.textColor = [UIColor whiteColor];
    fishBallLabel.textAlignment = NSTextAlignmentCenter;
    fishBallLabel.text = @"鱼丸 0  |  鱼翅 0";
    [self addSubview:fishBallLabel];
    self.fishBallLabel = fishBallLabel;
    
    // 7.直播按钮
    UIButton *liveBtn = [[UIButton alloc] init];
    liveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [liveBtn setTitle:@"我要直播" forState:UIControlStateNormal];
    liveBtn.backgroundColor = YCColor(27, 85, 232);
    liveBtn.layer.cornerRadius = 13;
    liveBtn.layer.masksToBounds = YES;
    [self addSubview:liveBtn];
    self.liveBtn = liveBtn;
    
    // 8.观看历史
    YCBottomButton *hisBtn = [[YCBottomButton alloc] init];
    [hisBtn setImage:[UIImage imageNamed:@"image_my_history_26x26_"] forState:UIControlStateNormal];
    [hisBtn setTitle:@"观看历史" forState:UIControlStateNormal];
    [self addSubview:hisBtn];
    self.hisBtn = hisBtn;
    
    // 9.关注管理
    YCBottomButton *focusManageBtn = [[YCBottomButton alloc] init];
    [focusManageBtn setImage:[UIImage imageNamed:@"image_my_focus_26x26_"] forState:UIControlStateNormal];
    [focusManageBtn setTitle:@"关注管理" forState:UIControlStateNormal];
    [self addSubview:focusManageBtn];
    self.focusManageBtn = focusManageBtn;
    
    // 10.鱼丸任务
    YCBottomButton *fishTaskBtn = [[YCBottomButton alloc] init];
    [fishTaskBtn setImage:[UIImage imageNamed:@"image_my_task_26x26_"] forState:UIControlStateNormal];
    [fishTaskBtn setTitle:@"鱼丸任务" forState:UIControlStateNormal];
    [self addSubview:fishTaskBtn];
    self.fishTaskBtn = fishTaskBtn;
    
    // 11.鱼翅充值
    YCBottomButton *finTopUpBtn = [[YCBottomButton alloc] init];
    [finTopUpBtn setImage:[UIImage imageNamed:@"Image_my_pay_26x26_"] forState:UIControlStateNormal];
    [finTopUpBtn setTitle:@"鱼翅充值" forState:UIControlStateNormal];
    [self addSubview:finTopUpBtn];
    self.finTopUpBtn = finTopUpBtn;
    
    // 设置子控件的约束
    // 背景图片约束
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.offset(200);
        make.right.equalTo(self.mas_right);
    }];
    
    // 消息按钮约束
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    // 编辑个人信息按钮约束
    [self.myInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    // 头像约束
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(80);
        make.height.offset(80);
    }];
    
    // 等级图片
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(5);
        make.right.equalTo(self.iconView.mas_right);
        make.width.offset(30);
        make.height.offset(15);
    }];
    
    // 昵称
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(20);
    }];
    
    // 鱼丸和鱼翅
    [self.fishBallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.offset(20);
    }];
    
    // 直播按钮
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(200);
        make.height.offset(30);
    }];
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 4 * 50 - 2 * 20) / 3;
    // 观看历史
    [self.hisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.offset(50);
        make.height.offset(70);
    }];
    
    // 关注管理
    [self.focusManageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hisBtn.mas_right).offset(margin);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.offset(50);
        make.height.offset(70);
    }];
    
    // 鱼丸任务
    [self.fishTaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusManageBtn.mas_right).offset(margin);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.offset(50);
        make.height.offset(70);
    }];
    
    // 鱼翅充值
    [self.finTopUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.offset(50);
        make.height.offset(70);
    }];
}
@end
