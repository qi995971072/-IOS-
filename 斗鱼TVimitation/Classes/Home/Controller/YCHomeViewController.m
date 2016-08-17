//
//  YCHomeViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/12.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCHomeViewController.h"
#import "UIBarButtonItem+YC.h"
#import "YCRecommendViewController.h"
#import "YCGameViewController.h"
#import "YCEntainmentViewController.h"
#import "YCFunToPlayViewController.h"


@interface YCHomeViewController ()

@end

@implementation YCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YCColor(223, 223, 223);
    
    // 设置导航栏
    [self setupNav];
    
    // 添加子控制器
    [self setupChildVc];
    
    // 设置滚动的内容
    [self setupScrollContent];
}

/**
 *  设置导航栏
 */
- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"logo_66x26_" highIcon:nil target:self action:@selector(updateHomeData)];
    
    UIBarButtonItem *itemScan = [UIBarButtonItem itemWithIcon:@"Image_scan_22x22_" highIcon:@"Image_scan_click_22x22_" target:self action:@selector(scan)];
    
    UIBarButtonItem *itemMargin1 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)]];
    
    UIBarButtonItem *itemSearch = [UIBarButtonItem itemWithIcon:@"btn_search_22x22_" highIcon:@"btn_search_clicked_22x22_" target:self action:@selector(search)];
    
    UIBarButtonItem *itemMargin2 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)]];
    
    UIBarButtonItem *itemHistory = [UIBarButtonItem itemWithIcon:@"image_my_history_26x26_" highIcon:@"Image_my_history_click_22x22_" target:self action:@selector(history)];
    
    self.navigationItem.rightBarButtonItems = @[ itemScan, itemMargin1, itemSearch, itemMargin2, itemHistory ];
}

/**
 *  添加子控制器
 */
- (void)setupChildVc {
    // 推荐
    YCRecommendViewController *recommendVc = [[YCRecommendViewController alloc] initWithStyle:UITableViewStyleGrouped];
    recommendVc.title = @"推荐";
    [self addChildViewController:recommendVc];
    
    // 游戏
    YCGameViewController *gameVc = [[YCGameViewController alloc] init];
    gameVc.title = @"游戏";
    [self addChildViewController:gameVc];
    
    // 娱乐
    YCEntainmentViewController *entainmentVc = [[YCEntainmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
    entainmentVc.title = @"娱乐";
    [self addChildViewController:entainmentVc];
    
    // 趣玩
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = ItemMargin;
    flowLayout.minimumInteritemSpacing = ItemMargin;
    flowLayout.itemSize = CGSizeMake(NormalItemW, NormalItemH);
    YCFunToPlayViewController *funToPlayVc = [[YCFunToPlayViewController alloc] initWithCollectionViewLayout:flowLayout];
    funToPlayVc.title = @"趣玩";
    [self addChildViewController:funToPlayVc];
}

- (void)setupScrollContent {
    self.customLabelsWidth = [NSNumber numberWithFloat:self.view.width / self.childViewControllers.count];
    self.customMargin = [NSNumber numberWithFloat:0.00001];
    
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

- (void)updateHomeData {
    NSLog(@"首页更新");
}

- (void)scan {
    NSLog(@"扫描");
}

- (void)search {
    NSLog(@"搜索");
}

- (void)history {
    NSLog(@"历史");
}
@end
