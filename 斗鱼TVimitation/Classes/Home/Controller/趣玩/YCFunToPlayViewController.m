//
//  YCFunToPlayViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCFunToPlayViewController.h"
#import "YCCollectionViewCell.h"
#import "YCRoom.h"
#import "YCLivePlayViewController.h"

@interface YCFunToPlayViewController ()

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,assign) int ofset;

@property (nonatomic,copy) NSString *lastUrl;

@end

@implementation YCFunToPlayViewController

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"funToPlayCell"];
    
    [self setupRefresh];
    
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, ItemMargin, -44 + ItemMargin, ItemMargin);
    
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupRefresh {
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

- (void)refreshData {
    self.ofset = 0;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/getColumnRoom/3?aid=ios&client_sys=ios&limit=20&offset=%d&time=1468825860&auth=4832d19a1c06d9deb24ae2449226422d", self.ofset];
    self.lastUrl = url;
    [self.collectionView.mj_footer resetNoMoreData];
    [[YCHttpManager sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        if (![self.lastUrl isEqualToString:url]) {
            return ;
        }
        // 删除之前的所有元素
        [self.datas removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *rooms = [YCRoom mj_objectArrayWithKeyValuesArray:roomsDict];
        [self.datas addObjectsFromArray:rooms];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    self.ofset += 20;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/getColumnRoom/3?aid=ios&client_sys=ios&limit=20&offset=%d&time=1468825860&auth=4832d19a1c06d9deb24ae2449226422d", self.ofset];
    self.lastUrl = url;

    [[YCHttpManager sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        if (![self.lastUrl isEqualToString:url]) {
            return ;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *rooms = [YCRoom mj_objectArrayWithKeyValuesArray:roomsDict];
        [self.datas addObjectsFromArray:rooms];
        [self.collectionView reloadData];
        if (rooms.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        self.ofset -= 20;
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"funToPlayCell" forIndexPath:indexPath];
    cell.room = self.datas[indexPath.item];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(ItemMargin, ItemMargin, -44 + ItemMargin, ItemMargin);
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCLivePlayViewController *playVc = [[YCLivePlayViewController alloc] init];
    [self.navigationController pushViewController:playVc animated:YES];
}
@end
