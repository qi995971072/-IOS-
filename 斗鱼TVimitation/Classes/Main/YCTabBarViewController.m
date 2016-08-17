
//
//  YCTabBarViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/12.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCTabBarViewController.h"
#import "YCNavgationController.h"
#import "YCHomeViewController.h"
#import "YCLiveViewController.h"
#import "YCFocusOnViewController.h"
#import "YCMeViewController.h"
#import "YCLivePlayViewController.h"


#define TabBarTintColor YCColor(244, 89, 27)

@interface YCTabBarViewController ()

@end

@implementation YCTabBarViewController

+ (void)initialize {
    [UITabBar appearance].tintColor = TabBarTintColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化子控制器
    [self setupChildViewControllers];
    
    self.selectedIndex = 0;
}

- (void)setupChildViewControllers {
    
    // 首页
    YCHomeViewController *homeVc = [[YCHomeViewController alloc] init];
    [self addChileVcWithTitle:@"首页" vc:homeVc imageName:@"btn_home_normal_24x24_" selImageName:@"btn_home_selected_24x24_"];
    
    // 直播
    YCLiveViewController *liveVc = [[YCLiveViewController alloc] init];
    [liveVc setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    }];
    [self addChileVcWithTitle:@"直播" vc:liveVc imageName:@"btn_column_normal_24x24_" selImageName:@"btn_column_selected_24x24_"];
    
    // 关注
    YCFocusOnViewController *focusOnVc = [[YCFocusOnViewController alloc] init];
    [self addChileVcWithTitle:@"关注" vc:focusOnVc imageName:@"btn_live_normal_30x24_" selImageName:@"btn_live_selected_30x24_"];
    
    // 我的
    YCMeViewController *meVc = [[YCMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChileVcWithTitle:@"我的" vc:meVc imageName:@"btn_user_normal_24x24_" selImageName:@"btn_user_selected_24x24_"];
}

- (void)addChileVcWithTitle:(NSString *)title vc:(UIViewController *)vc imageName:(NSString *)imageName selImageName:(NSString *)selImageName {
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selImageName]];
    YCNavgationController *navVc = [[YCNavgationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    if ([nav.topViewController isKindOfClass:[YCLivePlayViewController class]]) {
        return YES;
    }
    return NO;
}

/**
 *  viewcontroller支持哪些转屏方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    if ([nav.topViewController isKindOfClass:[YCLivePlayViewController class]]) {
        YCLivePlayViewController *liveVc = (YCLivePlayViewController *)nav.topViewController;
        // 判断如果直播控制器点击了，锁定屏幕的话，就禁止竖屏
        if (liveVc.isLock) {
            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
        }
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}

@end
