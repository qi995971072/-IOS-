//
//  YCLandScapeControlView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/25.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLandScapeControlView.h"

@interface YCLandScapeControlView () <UITextFieldDelegate>
/**
 *  上半部分控制view
 */
@property (weak, nonatomic) IBOutlet UIView *topControlView;
/**
 *  下半部分控制view
 */
@property (weak, nonatomic) IBOutlet UIView *bottomControlView;
/**
 *  房间名
 */
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
/**
 *  播放和暂停按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/**
 *  输入弹幕的文本框的父控件
 */
@property (weak, nonatomic) IBOutlet UIView *textFieldSuperView;
/**
 *  弹幕按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *barrageBtn;
/**
 *  弹幕文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *barrageField;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,assign) BOOL isClickReturn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation YCLandScapeControlView

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didmissKeyboard)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (void)didmissKeyboard {
    [self.barrageField endEditing:YES];
}

+ (instancetype)landScapeControlView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YCLandScapeControlView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.bottomControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.textFieldSuperView.layer.cornerRadius = 5;
    self.textFieldSuperView.layer.masksToBounds = YES;
    
    self.barrageField.delegate = self;
    
    // 监听键盘的显示和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointAtTopControlView = CGRectContainsPoint(self.topControlView.frame, point);
    BOOL pointAtBottomControlView = CGRectContainsPoint(self.bottomControlView.frame, point);
    if (pointAtTopControlView || pointAtBottomControlView) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}

#pragma mark - 所有按钮的点击事件
- (IBAction)backBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControlViewDidClickBackBtn:)]) {
        [self.delegate landScapeControlViewDidClickBackBtn:self];
    }
}

- (IBAction)selectChannel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControlViewDidClickChannelSelectBtn:)]) {
        [self.delegate landScapeControlViewDidClickChannelSelectBtn:self];
    }
}

- (IBAction)attentionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(landScapeControllView:didAttention:)]) {
        [self.delegate landScapeControllView:self didAttention:sender.selected];
    }
}

- (IBAction)shareBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControlViewDidClickShareBtn:)]) {
        [self.delegate landScapeControlViewDidClickShareBtn:self];
    }
}

- (IBAction)giftBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(landScapeControllView:didCliciGiftBtn:)]) {
        [self.delegate landScapeControllView:self didCliciGiftBtn:!sender.selected];
    }
}

- (IBAction)settingBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControlViewDidClickSettingBtn:)]) {
        [self.delegate landScapeControlViewDidClickSettingBtn:self];
    }
}

- (IBAction)roomListBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControllViewdidClickRoomListBtn:)]) {
        [self.delegate landScapeControllViewdidClickRoomListBtn:self];
    }
}

- (IBAction)refreshBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeControllViewDidClickRefreshBtn:)]) {
        [self.delegate landScapeControllViewDidClickRefreshBtn:self];
    }
}

- (IBAction)playOrPauseBtnClick:(id)sender {
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayStateShouldChanged" object:nil];
}

/**
 *  设置播放和暂停按钮的状态
 */
- (void)setIsPlaying:(BOOL)isPlaying {
    self.playOrPauseBtn.selected = !isPlaying;
}

/**
 *  设置弹幕的打开和关闭的状态
 */
- (void)setIsOpenBarrage:(BOOL)isOpenBarrage {
    self.barrageBtn.selected = !isOpenBarrage;
}

/**
 *  点击了弹幕按钮
 */
- (IBAction)barrageBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(landScapeControllView:didCliciBarrageBtn:)]) {
        [self.delegate landScapeControllView:self didCliciBarrageBtn:!sender.selected];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField hasText]) {
        self.isClickReturn = YES;
        [textField endEditing:YES];
    } else {
        [textField endEditing:YES];
    }
    return YES;
}

#pragma mark - 监听键盘的弹出和隐藏
/**
 *  键盘即将显示
 */
- (void)keyboardWillShow:(NSNotification *)note {
    
    // 隐藏上面的控制view
    self.topControlView.hidden = YES;

    // 关闭自动隐藏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteTimer" object:nil];
    
    [self.superview insertSubview:self.coverView belowSubview:self];
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomConstraint.constant = keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        [self.bottomControlView layoutIfNeeded];
    }];
}

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note {

    // 显示上面的控制view
    self.topControlView.hidden = NO;
    
    if (self.isClickReturn) {
        self.isClickReturn = NO;
        // 隐藏横屏的view、隐藏状态栏
        self.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        // 发弹幕通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendBarrage" object:nil userInfo:@{ @"text" : self.barrageField.text}];
        // 清空文本框的文字
        self.barrageField.text = nil;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTimer" object:nil];
    }

    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:duration animations:^{
        [self.bottomControlView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];

}


@end
