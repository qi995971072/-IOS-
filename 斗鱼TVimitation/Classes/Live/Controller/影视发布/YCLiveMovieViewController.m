//
//  YCLiveMovieViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/18.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveMovieViewController.h"

@interface YCLiveMovieViewController ()

@end

@implementation YCLiveMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 设置cell的类型
    self.cellType = LiveCellTypeNormal;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)refreshData {
    self.ofset = 0;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/getColumnRoom/11?aid=ios&client_sys=ios&limit=20&offset=%d&time=1469015520&auth=19d9ee69d294976b98b90b67a2ca9f94", self.ofset];
    self.lastUrl = url;
    [self.collectionView.mj_footer resetNoMoreData];
    [[YCHttpManager sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        if (![self.lastUrl isEqualToString:url]) {
            return ;
        }
        // 删除之前的所有元素
        [self.rooms removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *rooms = [YCRoom mj_objectArrayWithKeyValuesArray:roomsDict];
        [self.rooms addObjectsFromArray:rooms];
        
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    self.ofset += 20;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/getColumnRoom/11?aid=ios&client_sys=ios&limit=20&offset=%d&time=1469015520&auth=19d9ee69d294976b98b90b67a2ca9f94", self.ofset];
    self.lastUrl = url;
    
    [[YCHttpManager sharedInstance] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        if (![self.lastUrl isEqualToString:url]) {
            return ;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *newRooms = [YCRoom mj_objectArrayWithKeyValuesArray:roomsDict];
        [self.rooms addObjectsFromArray:newRooms];
        [self.collectionView reloadData];
        if (newRooms.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        self.ofset -= 20;
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.rooms[indexPath.item] room_name]);
    // 播放视频
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

@end
