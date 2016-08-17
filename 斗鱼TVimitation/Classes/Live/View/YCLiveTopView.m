//
//  YCLiveTopView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveTopView.h"
#import "YCTag.h"
#import "YCLiveDownView.h"

//--------------------------------------------
@interface YCLiveTopButton : UIButton


@end

@implementation YCLiveTopButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
//--------------------------------------------

@interface YCLiveTopView () <YCLiveDownViewDelegate>

/**
 *  下拉的按钮
 */
@property (nonatomic,weak) UIButton *downBtn;
/**
 *  顶部的所有按钮
 */
@property (nonatomic,strong) NSMutableArray *topBtns;
/**
 *  顶部的按钮的父控件
 */
@property (nonatomic,weak) UIScrollView *scrollView;
/**
 *  顶部的按钮的父控件的背景
 */
@property (nonatomic,weak) UIImageView *bgView;
/**
 *  顶部的选中按钮
 */
@property (nonatomic,strong) YCLiveTopButton *lastBtn;
/**
 *  下拉出现的view
 */
@property (nonatomic,weak) YCLiveDownView *downView;
/**
 *  自己的父View
 */
@property (nonatomic,strong) UIView *superView;
/**
 *  筛选Label
 */
@property (nonatomic,strong) UILabel *screenLabel;
/**
 *  遮盖view
 */
@property (nonatomic,strong) UIView *coverView;
@end

@implementation YCLiveTopView

- (UILabel *)screenLabel {
    if (!_screenLabel) {
        _screenLabel = [[UILabel alloc] init];
        _screenLabel.text = @"   筛选栏目";
        _screenLabel.backgroundColor = [UIColor whiteColor];
    }
    return _screenLabel;
}

- (NSMutableArray *)topBtns {
    if (!_topBtns) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDownView)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  获得一张纯颜色的图片
 */
- (UIImage *)buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setup {
    // 背景
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"column_header_mask_9x40_"]];
    bgView.contentMode = UIViewContentModeRight;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = YCColor(233, 233, 233).CGColor;
    
    // 下拉按钮
    UIButton *downBtn = [[UIButton alloc] init];
    downBtn.backgroundColor = [UIColor whiteColor];
    [downBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [downBtn setImage:[UIImage imageNamed:@"column_select_normal_20x20_"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"column_select_pressed_20x20_"] forState:UIControlStateSelected];
    downBtn.contentMode = UIViewContentModeCenter;
    [self addSubview:downBtn];
    self.downBtn = downBtn;
    
    // 顶部所有按钮的父控件
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
}

/**
 *  点击了下拉按钮
 */
- (void)btnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        // 隐藏下拉的列表
        [UIView animateWithDuration:0.3 animations:^{
            self.downView.frame = CGRectMake(0, 50, self.superView.width, 0);
        }];
        
        // 移除筛选的Label
        [self.screenLabel removeFromSuperview];
        // 移除这个view
        [self.coverView removeFromSuperview];
        
    } else {
        // 添加一个遮盖view
        [self.superView insertSubview:self.coverView belowSubview:self];
        // 将下拉的view放到最前面
        [self.superView bringSubviewToFront:self.downView];
        
        btn.selected = YES;
        // 显示筛选的Label
        self.screenLabel.frame = self.scrollView.bounds;
        [self.scrollView addSubview:self.screenLabel];
        // 显示下拉的列表
        [UIView animateWithDuration:0.3 animations:^{
            self.downView.frame = CGRectMake(0, 50, self.superView.width, 315);
        }];
    }
}

- (void)hideDownView {
    [self btnClick:self.downBtn];
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;

    YCLiveTopButton *allBtn = [[YCLiveTopButton alloc] init];
    [allBtn addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn setBackgroundImage:[self buttonImageFromColor:YCColor(238, 238, 238)] forState:UIControlStateNormal];
    [allBtn setBackgroundImage:[self buttonImageFromColor:[UIColor orangeColor]] forState:UIControlStateSelected];
    allBtn.selected = YES;
    [self.scrollView addSubview:allBtn];
    [self.topBtns addObject:allBtn];
    self.lastBtn = allBtn;
    
    for (int i = 0; i < tags.count; i++) {
        YCTag *tag = tags[i];
        YCLiveTopButton *btn = [[YCLiveTopButton alloc] init];
        [btn addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[self buttonImageFromColor:YCColor(238, 238, 238)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self buttonImageFromColor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [btn setTitle:tag.tag_name forState:UIControlStateNormal];
        
        //顺便将房间组的id赋给button的tag属性
        btn.tag = tag.tag_id.integerValue;
        [self.scrollView addSubview:btn];
        [self.topBtns addObject:btn];
    }
    
    // 给下拉的菜单赋数据
    self.downView.tags = self.tags;
    
}

/**
 *  点击了顶部的按钮
 */
- (void)topButtonClicked:(YCLiveTopButton *)btn {
    if (!btn.selected) {
        btn.selected = YES;
        self.lastBtn.selected = NO;
        self.lastBtn = btn;
        if (self.scrollView.contentSize.width - btn.x < self.scrollView.width) {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0);
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(btn.x - 8, 0);
            }];
        }
        // 通知代理
        if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"全部"]) {
            if ([self.delegate respondsToSelector:@selector(liveTopView:didClickButtonTitle:)]) {
                [self.delegate liveTopView:self didClickButtonTitle:@"全部"];
            }
        } else if ([self.delegate respondsToSelector:@selector(liveTopView:didClickButtonTagNumber:)]) {
            [self.delegate liveTopView:self didClickButtonTagNumber:btn.tag];
        }
        
        // 重新设置下拉列表选中的按钮
        [self.downView selectButtonViewName:[btn titleForState:UIControlStateNormal]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置downbtn的尺寸
    CGFloat downBtnW = 40;
    CGFloat downBtnH = self.height;
    self.downBtn.frame = CGRectMake(self.width - downBtnW, 0, downBtnW, downBtnH);
    
    self.scrollView.frame = CGRectMake(0, 0, self.width - downBtnW, self.height);
    self.bgView.frame = self.scrollView.frame;
    [self setupBtnsFrame];
    
    [self bringSubviewToFront:self.downBtn];
}

- (void)setupBtnsFrame {
    CGFloat btnH = 30;
    CGFloat margin = 8;
    CGFloat btnY = 10;
    CGFloat btnW = 0;
    CGFloat btnX = 0;
    YCLiveTopButton *lastBtn = nil;
    for (int i = 0; i < self.topBtns.count; i++) {
        YCLiveTopButton *liveBtn = self.topBtns[i];
        if (i == 0) {
            btnW  = [[liveBtn titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : liveBtn.titleLabel.font} context:nil].size.width + 25;
            liveBtn.frame = CGRectMake(margin, btnY, btnW, btnH);
            lastBtn = liveBtn;
        } else {
            btnW  = [[liveBtn titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : liveBtn.titleLabel.font} context:nil].size.width + 25;
            btnX = CGRectGetMaxX(lastBtn.frame) + margin;
            liveBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            lastBtn = liveBtn;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + margin, 0);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.superView = newSuperview;
    YCLiveDownView *downView = [[YCLiveDownView alloc] init];
    // 设置代理
    downView.downViewDelegate = self;
    downView.frame = CGRectMake(0, 50, self.superView.width, 0);
    downView.backgroundColor = YCColor(221, 221, 220);
    [self.superView addSubview:downView];
    self.downView = downView;
}

#pragma mark YCLiveDownViewDelegate
- (void)liveDownView:(YCLiveDownView *)downView DidClickDownButtonViewName:(NSString *)name {
    for (YCLiveTopButton *btn in self.topBtns) {
        if ([[btn titleForState:UIControlStateNormal] isEqualToString:name]) {
            [self topButtonClicked:btn];
            [self btnClick:self.downBtn];
            break;
        }
    }
}

@end
