//
//  YCGameCenterViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/8/14.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCGameCenterViewController.h"

@interface YCGameCenterViewController ()

@end

@implementation YCGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"游戏中心";
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
