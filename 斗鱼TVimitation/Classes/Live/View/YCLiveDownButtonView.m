//
//  YCLiveDownButtonView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveDownButtonView.h"

@interface YCLiveDownButtonView ()

@end

@implementation YCLiveDownButtonView

+ (instancetype)downButtonView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YCLiveDownButtonView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    self.tagIconView.userInteractionEnabled = YES;
    self.tagNameLabel.userInteractionEnabled = YES;
    self.checkIconView.userInteractionEnabled = YES;
    
    self.tagIconView.layer.cornerRadius = self.tagIconView.width / 2;
    self.tagIconView.layer.masksToBounds = YES;
}

@end
