//
//  YCLiveTopView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCLiveTopView;
@protocol YCLiveTopViewDelegate <NSObject>

@optional
- (void)liveTopView:(YCLiveTopView *)topView didClickButtonTagNumber:(NSInteger)tagNumber;

- (void)liveTopView:(YCLiveTopView *)topView didClickButtonTitle:(NSString *)title;
@end

@interface YCLiveTopView : UIView

@property (nonatomic,strong) NSArray *tags;

@property (nonatomic,weak) id<YCLiveTopViewDelegate> delegate;

@end
