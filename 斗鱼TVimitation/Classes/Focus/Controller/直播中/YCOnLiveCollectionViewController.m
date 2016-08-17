//
//  YCOnLiveCollectionViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/22.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCOnLiveCollectionViewController.h"


@interface YCOnLiveCollectionViewController ()

@end

@implementation YCOnLiveCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)refreshData {
    [self.collectionView.mj_header endRefreshing];
}

- (void)loadMoreData {
    [self.collectionView.mj_footer endRefreshing];
}

@end
