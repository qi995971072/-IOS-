//
//  YCSettingScrollView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/26.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BarrageAttributeTypeAlpha,                     // 弹幕透明度
    BarrageAttributeTypeFont,                      // 弹幕字体
    BarrageAttributeTypeBrightness,                // 弹幕亮度
    BarrageAttributeTypeSoftDecodingPerformance    // 软解码的性能
} BarrageAttributeType;

@class YCSettingScrollView;
@protocol YCSettingScrollViewDelegate <NSObject>

@optional
/**
 *  改变了弹幕的基本属性
 */
- (void)settingScrollView:(YCSettingScrollView *)settingScrollView didChangeBarrageAttributeType:(BarrageAttributeType)type value:(CGFloat)value;
/**
 *  改变弹幕的位置
 */
- (void)settingScrollView:(YCSettingScrollView *)settingScrollView changeBarrageLocationID:(int)locationID;
@end

@interface YCSettingScrollView : UIScrollView

+ (instancetype)settingScrollView;

@property (nonatomic,weak) id<YCSettingScrollViewDelegate> settingScrollViewDelegate;

@end
