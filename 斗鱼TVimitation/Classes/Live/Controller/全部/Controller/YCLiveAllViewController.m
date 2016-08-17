//
//  YCLiveAllViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/18.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLiveAllViewController.h"
#import "YCAdModel.h"
#import "YCAdCollectionViewCell.h"
#import "YCWebViewCoontroller.h"

@interface YCLiveAllViewController ()

@property (nonatomic,strong) YCAdModel *ad;

@end

@implementation YCLiveAllViewController
- (YCAdModel *)ad {
    if (!_ad) {
        _ad = [[YCAdModel alloc] init];
        _ad.link = @"http://e.cn.miaozhen.com/r/k=2023817&p=71DPr&dx=0&rt=2&ns=__IP__&ni=__IESID__&v=__LOC__&ro=sm&vo=38949ffde&vr=2&o=http%3A%2F%2Fwww.adidas.com.cn%2Fm%2Fzx_family@dy_url@http://g.cn.miaozhen.com/x/k=2023817&p=71DPr&dx=0&rt=2&ns=__IP__&ni=__IESID__&v=__LOC__&mo=__OS__&m0=__OPENUDID__&m0a=__DUID__&m1=__ANDROIDID1__&m1a=__ANDROIDID__&m2=__IMEI__&m4=__AAID__&m5=__IDFA__&m6=__MAC1__&m6a=__MAC__&o=";
        _ad.srcid = @"http://staticlive.douyucdn.cn/upload/signs/201607071710446345.jpg";
        _ad.proname = @"阿迪达斯";
    }
    return _ad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YCAdCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"adCell"];
    
    // 设置cell的类型
    self.cellType = LiveCellTypeNormal;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)refreshData {
    self.ofset = 0;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/live?aid=ios&client_sys=ios&limit=20&offset=%d&time=1468894680&auth=848c60f9ab96f0ee866a8ab588f2e2b6", self.ofset];
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
        
        if(rooms.count == 0) {
            return;
        }
        [self.rooms addObjectsFromArray:rooms];
        
        // 额外添加一个广告的模型
        [self.rooms insertObject:self.ad atIndex:6];
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    self.ofset += 20;
    __block NSString *url = [NSString stringWithFormat:@"http://capi.douyucdn.cn/api/v1/live?aid=ios&client_sys=ios&limit=20&offset=%d&time=1468894680&auth=848c60f9ab96f0ee866a8ab588f2e2b6", self.ofset];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 6) {
        YCAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"adCell" forIndexPath:indexPath];
        cell.ad = self.rooms[indexPath.item];
        return cell;
    }
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

/**
 *  返回每个item的尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 6) {
        return CGSizeMake(self.view.width - 2 * ItemMargin, NormalItemH);
    } else {
        return CGSizeMake(NormalItemW, NormalItemH);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 6) {
        NSLog(@"%@", [self.rooms[indexPath.item] proname]);
        YCWebViewCoontroller *webVc = [[YCWebViewCoontroller alloc] init];
        webVc.url = self.ad.link;
        [self.navigationController pushViewController:webVc animated:YES];
    } else {
        NSLog(@"%@", [self.rooms[indexPath.item] room_name]);
        // 播放视频
        [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}


@end
