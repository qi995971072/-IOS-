//
//  YCNoDataView.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/22.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCNoDataView.h"

@implementation YCNoDataView

+ (instancetype)noDataView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YCNoDataView" owner:nil options:nil] lastObject];
}
@end
