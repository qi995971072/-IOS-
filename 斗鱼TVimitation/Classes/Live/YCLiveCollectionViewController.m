//
//  YCLiveCollectionViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/18.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveCollectionViewController.h"
#import "YCNoDataView.h"
#import "YCLivePlayViewController.h"

@interface YCLiveCollectionViewController ()

@property (nonatomic,strong) YCNoDataView *noDataView;

@end

@implementation YCLiveCollectionViewController

- (YCNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [YCNoDataView noDataView];
        _noDataView.frame = self.view.bounds;
    }
    return _noDataView;
}

- (NSMutableArray *)rooms {
    if (!_rooms) {
        _rooms = [NSMutableArray array];
    }
    return _rooms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCFaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"faceCollectionViewCell"];
    
    [self setupRefresh];

    [self.collectionView addSubview:self.noDataView];
}

- (void)setupRefresh {
#pragma mark 留给子类实现 refreshData 和 loadMoreData方法
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [header setImages:@[[UIImage imageNamed:@"dyla_img_mj_stateIdle_64x66_"]] forState:MJRefreshStateIdle];
    [header setImages:@[[UIImage imageNamed:@"dyla_img_mj_statePulling_64x66_"]] forState:MJRefreshStatePulling];
    [header setImages:@[[UIImage imageNamed:@"dyla_img_mj_stateRefreshing_01_135x66_"],
                        [UIImage imageNamed:@"dyla_img_mj_stateRefreshing_02_135x66_"],
                        [UIImage imageNamed:@"dyla_img_mj_stateRefreshing_03_135x66_"],
                        [UIImage imageNamed:@"dyla_img_mj_stateRefreshing_04_135x66_"]] duration:0.5 forState:MJRefreshStateRefreshing];
    [header setTimeLabelHidden:YES forState:MJRefreshStateRefreshing];
    self.collectionView.mj_header = header;
    
   self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.noDataView.hidden = !(self.rooms.count == 0);
    return self.rooms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.cellType == LiveCellTypeFaceLevel) {
        YCFaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCollectionViewCell" forIndexPath:indexPath];
        cell.room = self.rooms[indexPath.item];
        return cell;
    } else {
        YCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        cell.room = self.rooms[indexPath.item];
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCLivePlayViewController *playVc = [[YCLivePlayViewController alloc] init];
    [self.navigationController pushViewController:playVc animated:YES];
}
/**
 *  返回每个item的尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellType == LiveCellTypeFaceLevel) {
        return CGSizeMake(NormalItemW, FaceItemH);
    } else {
        return CGSizeMake(NormalItemW, NormalItemH);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(ItemMargin, ItemMargin, -44 + ItemMargin, ItemMargin);
}
@end
