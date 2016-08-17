//
//  YCLiveViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/12.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveViewController.h"
#import "YCInCommonUseViewController.h"
#import "YCLiveAllViewController.h"
#import "YCLiveGameViewController.h"
#import "YCPhoneGameViewController.h"
#import "YCLiveFishHappyViewController.h"
#import "YCFaceLevelViewController.h"
#import "YCLiveFishShowViewController.h"
#import "YCLiveTecViewController.h"
#import "YCLiveMovieViewController.h"

@interface YCLiveViewController ()

@end

@implementation YCLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScrollContent];
    
    [self setupChildVc];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setupScrollContent {
    // 设置下划线
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        
        *isShowUnderLine = YES;
        
        *underLineColor = [UIColor colorWithRed:YCRSLlRed green:YCRSLGreen blue:YCRSLBlue alpha:1.0];
        
    }];
    
    // 设置标题的颜色
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
    
    // 常用
    YCInCommonUseViewController *inCommonUseVc = [[YCInCommonUseViewController alloc] init];
    inCommonUseVc.title = @"常用";
    [self addChildViewController:inCommonUseVc];
    
    // 全部
    [self addChildVc:[YCLiveAllViewController class] title:@"全部"];

    // 游戏
    [self addChildVc:[YCLiveGameViewController class] title:@"游戏"];

    // 手机游戏
    [self addChildVc:[YCPhoneGameViewController class] title:@"手机游戏"];
    
    // 鱼乐星天地
    [self addChildVc:[YCLiveFishHappyViewController class] title:@"鱼乐星天地"];
    
    // 颜值
    [self addChildVc:[YCFaceLevelViewController class] title:@"颜值"];
    
    // 鱼秀
    [self addChildVc:[YCLiveFishShowViewController class] title:@"鱼秀"];
    
    // 科技
    [self addChildVc:[YCLiveTecViewController class] title:@"科技"];
    
    // 影视发布
    [self addChildVc:[YCLiveMovieViewController class] title:@"影视发布"];
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
