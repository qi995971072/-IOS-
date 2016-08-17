//
//  YCRecommendViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCRecommendViewController.h"
#import "SDCycleScrollView.h"
#import "YCHttpManager.h"
#import "NSString+Extension.h"
#import "YCScrollModel.h"
#import "YCTag.h"
#import "YCVerticalButton.h"
#import "MJRefresh.h"
#import <UIButton+WebCache.h>
#import "YCRoomGroup.h"
#import "YCRecommendCell.h"
#import "YCRecommendHeaderView.h"
#import "YCGameVerticalButton.h"
#import "YCLivePlayViewController.h"

#define CyrcleViewH 160
#define BaseViewH 260


@interface YCRecommendViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,weak) SDCycleScrollView *cycleScrollView;

@property (nonatomic,weak) UIScrollView *topScrollView;

@property (nonatomic,strong) NSArray *scrollModels;

@property (nonatomic,strong) NSMutableArray *roomGroups;

@property (nonatomic,strong) YCRecommendHeaderView *sectionHeaderView;

@end

@implementation YCRecommendViewController

- (YCRecommendHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[YCRecommendHeaderView alloc] init];
        _sectionHeaderView.bounds = CGRectMake(0, 0, self.view.width, 30);
    }
    return _sectionHeaderView;
}

#pragma mark - 由于我无法获得斗鱼返回的所有分组的信息，所以目前就自己先创建了所有的分组，然后再往分组里添加数据
- (NSMutableArray *)roomGroups {
    if (!_roomGroups) {
        _roomGroups = [NSMutableArray array];
    }
    return _roomGroups;
}

- (NSArray *)createAllGroups {
    YCRoomGroup *roomGroup1 = [[YCRoomGroup alloc] init];
    roomGroup1.groupName = @"最热";
    roomGroup1.groupImage = @"home_header_hot_18x18_";
    
    YCRoomGroup *roomGroup2 = [[YCRoomGroup alloc] init];
    roomGroup2.groupName = @"颜值";
    roomGroup2.groupImage = @"home_header_phone_18x18_";
    
    YCRoomGroup *roomGroup3 = [[YCRoomGroup alloc] init];
    roomGroup3.groupName = @"全民星秀";
    roomGroup3.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup4 = [[YCRoomGroup alloc] init];
    roomGroup4.groupName = @"主机游戏";
    roomGroup4.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup5 = [[YCRoomGroup alloc] init];
    roomGroup5.groupName = @"英雄联盟";
    roomGroup5.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup6 = [[YCRoomGroup alloc] init];
    roomGroup6.groupName = @"鱼行天下";
    roomGroup6.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup7 = [[YCRoomGroup alloc] init];
    roomGroup7.groupName = @"小鲜肉";
    roomGroup7.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup8 = [[YCRoomGroup alloc] init];
    roomGroup8.groupName = @"皇室战争";
    roomGroup8.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup9 = [[YCRoomGroup alloc] init];
    roomGroup9.groupName = @"元气领域";
    roomGroup9.groupImage = @"home_header_normal_18x18_";
    
    YCRoomGroup *roomGroup10 = [[YCRoomGroup alloc] init];
    roomGroup10.groupName = @"鱼秀";
    roomGroup10.groupImage = @"home_header_normal_18x18_";

    YCRoomGroup *roomGroup11 = [[YCRoomGroup alloc] init];
    roomGroup11.groupName = @"鱼教鱼乐";
    roomGroup11.groupImage = @"home_header_normal_18x18_";

    YCRoomGroup *roomGroup12 = [[YCRoomGroup alloc] init];
    roomGroup12.groupName = @"炉石传说";
    roomGroup12.groupImage = @"home_header_normal_18x18_";
    
    return @[ roomGroup1,
              roomGroup2,
              roomGroup3,
              roomGroup4,
              roomGroup5,
              roomGroup6,
              roomGroup7,
              roomGroup8,
              roomGroup9,
              roomGroup10,
              roomGroup11,
              roomGroup12 ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YCColor(233, 233, 233);
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
    // 设置顶部
    [self setupTop];
    
    [self.tableView registerClass:[YCRecommendCell class] forCellReuseIdentifier:@"recommendCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加刷新控件
    [self setupRefresh];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTop {
    // 顶部控件的父View
    UIView *topBaseView = [[UIView alloc] init];
    topBaseView.backgroundColor = YCColor(233, 233, 233);
    topBaseView.frame = CGRectMake(0, 0, self.view.width, BaseViewH);
    
    // 添加一个轮播的View
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, CyrcleViewH) delegate:self placeholderImage:[UIImage imageNamed:@"live_cell_default_phone_103x103_"]];
    cycleScrollView.currentPageDotColor = [UIColor orangeColor];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [topBaseView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    // 添加一个scrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CyrcleViewH, self.view.width, BaseViewH - CyrcleViewH - 10)];
    topScrollView.backgroundColor = [UIColor whiteColor];
    [topBaseView addSubview:topScrollView];
    topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView = topScrollView;
    
    self.tableView.tableHeaderView = topBaseView;
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
    self.tableView.mj_header = header;
}

- (void)refreshData {
    // 加载轮播View的信息
    [self loadCyrcleViewData];
    
    // 加载轮播下面的滚动视图的数据
    [self loadScrollViewData];
    
    // 加载最热
    [self loadHotData];
}

- (void)loadHotData {
    [[YCHttpManager sharedInstance] GET:@"http://capi.douyucdn.cn/api/v1/getbigDataRoom?aid=ios&client_sys=ios&time=1468636740&token=30890623_1b036814902f6451&auth=7d7026a323e09dd55c71ca215fc9d4b2" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        
        [self.roomGroups removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *rooms = [YCRoom mj_objectArrayWithKeyValuesArray:roomsDict];
        [self.roomGroups addObjectsFromArray:[self createAllGroups]];
        for (int i = 0; i < self.roomGroups.count; i++) {
            YCRoomGroup *rg = self.roomGroups[i];
            if (rooms.count == 0) {
                continue;
            }
            if (i == 0) {
                rg.rooms = [rooms objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 8)]];
            } else {
                rg.rooms = [rooms objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)]];
            }
        }
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 停止刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadCyrcleViewData {
    NSDictionary *params = @{ @"aid" : @"ios",
                                    @"auth" : @"97d9e4d3e9dfab80321d11df5777a107",
                                    @"client_sys" : @"ios",
                                    @"time" : [NSString GetNowTimes]
                                   };
    [[YCHttpManager sharedInstance] GET:@"http://www.douyutv.com/api/v1/slide/6" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *topModels = [YCScrollModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        NSMutableArray *titles = [NSMutableArray array];
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (int i = 0; i < topModels.count; i++) {
            [titles addObject:[topModels[i] title]];
            [imageUrls  addObject:[topModels[i] pic_url]];
        }
        
        self.cycleScrollView.titlesGroup = titles;
        self.cycleScrollView.imageURLStringsGroup = imageUrls;
        self.scrollModels = topModels;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}

- (void)loadScrollViewData {
    
    [[YCHttpManager sharedInstance] GET:@"http://capi.douyucdn.cn/api/v1/getHotCate?aid=ios&client_sys=ios&time=1468824780&auth=76ce7ef9dbe73bd8a52c20bc43bd017f" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *tagsDict = dict[@"data"];
        NSArray *tags = [YCTag mj_objectArrayWithKeyValuesArray:tagsDict];
        CGFloat leftMargin = 10;
        CGFloat btnMargin = 10;
        CGFloat btnY = 10;
        CGFloat btnW = 70;
        CGFloat btnH = 70;
        YCGameVerticalButton *lastBtn = nil;
        for (int i = 0; i < tags.count; i++) {
            YCTag *tag = tags[i];
            YCGameVerticalButton *btn = [[YCGameVerticalButton alloc] init];
            lastBtn = btn;
            CGFloat btnX = leftMargin + (i * (btnW + btnMargin));
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [btn setTitle:tag.tag_name forState:UIControlStateNormal];
            [btn sd_setImageWithURL:[NSURL URLWithString:tag.icon_url] forState:UIControlStateNormal];
            [self.topScrollView addSubview:btn];
        }
        
        YCGameVerticalButton *moewBtn = [[YCGameVerticalButton alloc] init];
        CGFloat btnX = CGRectGetMaxX(lastBtn.frame) + btnMargin;
        moewBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [moewBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moewBtn setImage:[UIImage imageNamed:@"btn_v_more_34x34_"] forState:UIControlStateNormal];
        [self.topScrollView addSubview:moewBtn];
        
        self.topScrollView.contentSize = CGSizeMake(CGRectGetMaxX(moewBtn.frame) + leftMargin, 0);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.roomGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
    cell.rooms = [self.roomGroups[indexPath.section] rooms];
    cell.backgroundColor = [UIColor orangeColor];
    // 用来判断是不是颜值分组
    cell.groupName = [self.roomGroups[indexPath.section] groupName];
    __weak YCRecommendViewController *weakSelf = self;
    // 播放视频
    cell.block = ^(YCRoom *room) {
        YCLivePlayViewController *playVc = [[YCLivePlayViewController alloc] init];
        [weakSelf.navigationController pushViewController:playVc animated:YES];
    };
    return cell;
}

/**
 *  必须返回高度，headerInsection方法才会调用
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCRecommendHeaderView *view = [[YCRecommendHeaderView alloc] init];
    view.tagName = [self.roomGroups[section] groupName];
    view.imageName = [self.roomGroups[section] groupImage];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 房间的总数量
    int count = (int)[self.roomGroups[indexPath.section] rooms].count;
    // 判断有多少行
    int rols = (count + 2 - 1) / 2;
    // cell的高度
    CGFloat height = 0;
    if ([[self.roomGroups[indexPath.section] groupName] isEqualToString:@"颜值"]) {
        height = rols * FaceItemH + (rols) * ItemMargin + 5;
    } else {
        height = rols * NormalItemH + (rols) * ItemMargin + 5;
    }
    return height;
}


#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YCLivePlayViewController *playVc = [[YCLivePlayViewController alloc] init];
    [self.navigationController pushViewController:playVc animated:YES];
}

@end
