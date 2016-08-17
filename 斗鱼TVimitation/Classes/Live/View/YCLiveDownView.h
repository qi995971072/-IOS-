//
//  YCLiveDownView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCLiveDownView;
@protocol YCLiveDownViewDelegate <NSObject>

@optional

- (void)liveDownView:(YCLiveDownView *)downView DidClickDownButtonViewName:(NSString *)name;

@end

@interface YCLiveDownView : UIScrollView

@property (nonatomic,strong) NSArray *tags;

@property (nonatomic,weak) id<YCLiveDownViewDelegate> downViewDelegate;
/**
 *  重新设置下拉列表选中的按钮
 */
- (void)selectButtonViewName:(NSString *)btnName;

@end
