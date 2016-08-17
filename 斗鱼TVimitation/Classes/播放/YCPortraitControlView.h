//
//  YCPortraitControlView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/24.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCPortraitControlView;
@protocol YCPortraitControlViewDelegate <NSObject>

@optional
- (void)portControlViewDidClickBackBtn:(YCPortraitControlView *)portControlView;

- (void)portControlView:(YCPortraitControlView *)portControlView setLandScape:(UIInterfaceOrientation)interfaceOrientation;

@end

@interface YCPortraitControlView : UIView

@property (nonatomic,weak) id<YCPortraitControlViewDelegate> delegate;

- (void)setIsPlaying:(BOOL)isPlaying;

@end
