//
//  YCLiveDownButtonView.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTag.h"

@interface YCLiveDownButtonView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tagIconView;

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkIconView;


+ (instancetype)downButtonView;


@end
