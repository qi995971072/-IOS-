//
//  YCSettingScrollView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCSettingScrollView.h"
#import <Masonry.h>

@interface YCSettingScrollView ()
/**
 *  透明度slider
 */
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
/**
 *  字体slider
 */
@property (weak, nonatomic) IBOutlet UISlider *fontSlider;
/**
 *  亮度slider
 */
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UILabel *barrageAlphaLabel;

@property (weak, nonatomic) IBOutlet UILabel *barrageFontLabel;

@property (weak, nonatomic) IBOutlet UILabel *barrageBrightness;

@property (weak, nonatomic) IBOutlet UIView *softDecodingPerformanceView;

@property (weak, nonatomic) IBOutlet UILabel *softDecodingPerformanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *powerMinimumLabel;

@property (nonatomic,weak) UISlider *softDecodingPerformanceSlider;

@property (weak, nonatomic) IBOutlet UIButton *topBarrageBtn;

@property (weak, nonatomic) IBOutlet UIButton *bottomBarrageBtn;

@property (weak, nonatomic) IBOutlet UIButton *fullBarrageBtn;


@property (nonatomic,strong) UIButton *lastSelectedBarrageBtn;

@end

@implementation YCSettingScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSNumber *alphaValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"barrageTextAlpha"];
    NSNumber *fontValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"barrageTextFontSize"];
    
    [self.alphaSlider setValue:( alphaValue == nil ? 1 : (([alphaValue floatValue] - 0.3) / 0.7) )];
    [self.fontSlider setValue:( fontValue == nil ? 0 : ([fontValue floatValue] - 15) / 10 )];
    [self.brightnessSlider setValue:[UIScreen mainScreen].brightness];
    
    self.barrageAlphaLabel.text = [NSString stringWithFormat:@"%.0f%%", self.alphaSlider.value * 100];
    self.barrageFontLabel.text = [NSString stringWithFormat:@"%.0f%%", self.fontSlider.value * 100];
    self.barrageBrightness.text = [NSString stringWithFormat:@"%.0f%%", self.brightnessSlider.value * 100];

    
    // 额外添加一个修改软解码性能的slider
    UISlider *softDecodingPerformanceSlider = [[UISlider alloc] init];
    [softDecodingPerformanceSlider addTarget:self action:@selector(softDecodingPerformanceSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    softDecodingPerformanceSlider.minimumTrackTintColor = [UIColor orangeColor];
    [self.softDecodingPerformanceView addSubview:softDecodingPerformanceSlider];
    self.softDecodingPerformanceSlider = softDecodingPerformanceSlider;
    
    // 设置slider的约束
    [softDecodingPerformanceSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.softDecodingPerformanceLabel.mas_right).offset(10);
        make.top.equalTo(self.powerMinimumLabel.mas_bottom);
        make.right.equalTo(self.softDecodingPerformanceView.mas_right).offset(-10);
        make.bottom.equalTo(self.softDecodingPerformanceView.mas_bottom);
    }];
    
    NSNumber *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"barrageLocation"];
    if (locationID == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(3) forKey:@"barrageLocation"];
        self.lastSelectedBarrageBtn = self.fullBarrageBtn;
        self.fullBarrageBtn.selected = YES;
    } else {
        switch (locationID.intValue) {
            case 1:
                self.lastSelectedBarrageBtn = self.topBarrageBtn;
                self.topBarrageBtn.selected = YES;
                break;
            case 2:
                self.lastSelectedBarrageBtn = self.bottomBarrageBtn;
                self.bottomBarrageBtn.selected = YES;
                break;
            case 3:
                self.lastSelectedBarrageBtn = self.fullBarrageBtn;
                self.fullBarrageBtn.selected = YES;
                break;
            default:
                break;
        }
    }
}

+ (instancetype)settingScrollView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YCSettingScrollView" owner:nil options:nil] firstObject];
}
/**
 *  改变透明度
 */
- (IBAction)barrageAlphaSlideClick:(UISlider *)sender {
    self.barrageAlphaLabel.text = [NSString stringWithFormat:@"%.0f%%", sender.value * 100];
    [self noticeDelegateWithType:BarrageAttributeTypeAlpha value:sender.value];
}
/**
 *  改变字体大小
 */
- (IBAction)barrageFontSliderClick:(UISlider *)sender {
    self.barrageFontLabel.text = [NSString stringWithFormat:@"%.0f%%", sender.value * 100];
    [self noticeDelegateWithType:BarrageAttributeTypeFont value:sender.value];
}
/**
 *  改变亮度 */
- (IBAction)barrageBrightnessSliderClick:(UISlider *)sender {
    self.barrageBrightness.text = [NSString stringWithFormat:@"%.0f%%", sender.value * 100];
    [self noticeDelegateWithType:BarrageAttributeTypeBrightness value:sender.value];
}
/**
 *  改变软编码质量
 */
- (void)softDecodingPerformanceSliderValueChanged:(UISlider *)slider {
    [self noticeDelegateWithType:BarrageAttributeTypeSoftDecodingPerformance value:slider.value];
}
/**
 *  通知代理，改变的类型和值
 */
- (void)noticeDelegateWithType:(BarrageAttributeType)type value:(CGFloat)value {
    if ([self.settingScrollViewDelegate respondsToSelector:@selector(settingScrollView:didChangeBarrageAttributeType:value:)]) {
        [self.settingScrollViewDelegate settingScrollView:self didChangeBarrageAttributeType:type value:value];
    }
}

- (IBAction)barrageTopBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.lastSelectedBarrageBtn.selected = NO;
    self.lastSelectedBarrageBtn = sender;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"barrageLocation"];
    [self noticeDelegateWithLocationID:1];
}

- (IBAction)barragebottomBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.lastSelectedBarrageBtn.selected = NO;
    self.lastSelectedBarrageBtn = sender;
    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"barrageLocation"];
    [self noticeDelegateWithLocationID:2];
}

- (IBAction)barrageFullBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.lastSelectedBarrageBtn.selected = NO;
    self.lastSelectedBarrageBtn = sender;
    [[NSUserDefaults standardUserDefaults] setObject:@(3) forKey:@"barrageLocation"];
    [self noticeDelegateWithLocationID:3];
}

/**
 *  通知代理，改变弹幕的位置
 */
- (void)noticeDelegateWithLocationID:(int)locationID {
    if ([self.settingScrollViewDelegate respondsToSelector:@selector(settingScrollView:changeBarrageLocationID:)]) {
        [self.settingScrollViewDelegate settingScrollView:self changeBarrageLocationID:locationID];
    }
}

@end
