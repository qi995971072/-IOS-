//
//  YCAdCollectionViewCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/19.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCAdCollectionViewCell.h"

@interface YCAdCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation YCAdCollectionViewCell

- (void)awakeFromNib {
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setAd:(YCAdModel *)ad {
    _ad = ad;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:ad.srcid]];
}

@end
