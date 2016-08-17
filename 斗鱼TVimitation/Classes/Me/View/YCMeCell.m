//
//  YCMeCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/8/14.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCMeCell.h"

@interface YCMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation YCMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.iconView.image = [UIImage imageNamed:dict[@"image"]];
    self.titleLabel.text = dict[@"title"];
    if (dict[@"subtitle"]) {
        self.subtitleLabel.text = dict[@"subtitle"];
    }
    
    if (dict[@"class"]) {
        self.targetClass = NSClassFromString(dict[@"class"]);
    }
}

@end
