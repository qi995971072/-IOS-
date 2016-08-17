//
//  YCLandScapeControlView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/25.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCLandScapeControlView;
@protocol YCLandScapeControlViewDelegate <NSObject>

@optional
/**
 *  点击了返回
 */
- (void)landScapeControlViewDidClickBackBtn:(YCLandScapeControlView *)landScapeControlView;
/**
 *  点击了刷新
 */
- (void)landScapeControllViewDidClickRefreshBtn:(YCLandScapeControlView *)landScapeControlView;
/**
 *  点击了关注
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didAttention:(BOOL)isAttention;
/**
 *  点击了礼物
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didCliciGiftBtn:(BOOL)isOpenGift;
/**
 *  点击了分享
 */
- (void)landScapeControlViewDidClickShareBtn:(YCLandScapeControlView *)landScapeControlView;
/**
 *  点击了频道选择
 */
- (void)landScapeControlViewDidClickChannelSelectBtn:(YCLandScapeControlView *)landScapeControlView;
/**
 *  点击了设置
 */
- (void)landScapeControlViewDidClickSettingBtn:(YCLandScapeControlView *)landScapeControlView;
/**
 *  点击了弹幕
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didCliciBarrageBtn:(BOOL)isOpenBarrage;
/**
 *  点击了房间列表
 */
- (void)landScapeControllViewdidClickRoomListBtn:(YCLandScapeControlView *)landScapeControlView;
@end

@interface YCLandScapeControlView : UIView

+ (instancetype)landScapeControlView;

@property (nonatomic,weak) id<YCLandScapeControlViewDelegate> delegate;
/**
 *  设置是否在播放
 */
- (void)setIsPlaying:(BOOL)isPlaying;
/**
 *  设置弹幕按钮的状态
 */
- (void)setIsOpenBarrage:(BOOL)isOpenBarrage;
@end
