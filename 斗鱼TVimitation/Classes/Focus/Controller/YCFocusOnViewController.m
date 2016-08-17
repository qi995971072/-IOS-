//
//  YCFocusOnViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/12.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCFocusOnViewController.h"
#import "YCOnLiveCollectionViewController.h"
#import "YCHasNotStartedCollectionViewController.h"

@interface YCFocusOnViewController ()

@end

@implementation YCFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关注";
    
    [self setupScrollContent];
    
    [self setupChildVc];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupScrollContent {
    
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        
        *isShowUnderLine = YES;
        
        *underLineColor = [UIColor colorWithRed:YCRSLlRed green:YCRSLGreen blue:YCRSLBlue alpha:1.0];
        
    }];
    
    [self setUpTitleGradient:^(BOOL *isShowTitleGradient, YZTitleColorGradientStyle *titleColorGradientStyle, CGFloat *startR, CGFloat *startG, CGFloat *startB, CGFloat *endR, CGFloat *endG, CGFloat *endB) {
        *startR = NormalColorRGB;
        *startG = NormalColorRGB;
        *startB = NormalColorRGB;
        
        *endR = YCRSLlRed;
        *endG = YCRSLGreen;
        *endB = YCRSLBlue;
        
        // 不需要设置的属性，可以不管
        *isShowTitleGradient = YES;
        
        *titleColorGradientStyle = YZTitleColorGradientStyleRGB;
    }];
}
/**
 *  添加子控制器
 */
- (void)setupChildVc {
    // 直播中
    [self addChildVc:[YCOnLiveCollectionViewController class] title:@"直播中"];
    
    // 未开播
    [self addChildVc:[YCHasNotStartedCollectionViewController class] title:@"未开播"];
}

- (void)addChildVc:(Class)vcClass title:(NSString *)title {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = ItemMargin;
    layout.minimumInteritemSpacing = ItemMargin;
    
    UICollectionViewController *vc = [[vcClass alloc] initWithCollectionViewLayout:layout];
    vc.title = title;
    [self addChildViewController:vc];
}

@end
