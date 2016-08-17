//
//  YCEntainmentViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCEntainmentViewController.h"
#import "YCRoom.h"
#import "YCTag.h"
#import "YCRoomGroup.h"
#import "YCRecommendCell.h"
#import "YCRecommendHeaderView.h"
#import "YCGameVerticalButton.h"
#import "YCLivePlayViewController.h"

@interface YCEntainmentViewController () <UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *topScrollView;

@property (nonatomic,strong) NSMutableArray *tags;

@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation YCEntainmentViewController

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, self.view.width, 210);
    baseView.backgroundColor = YCColor(233, 233, 233);
    
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.pagingEnabled = YES;
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.frame = CGRectMake(0, 0, self.view.width, 200);
    topScrollView.delegate = self;
    [baseView addSubview:topScrollView];
    self.topScrollView = topScrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.frame = CGRectMake(0, 185, self.view.width, 10);
    [baseView addSubview:pageControl];
    self.pageControl = pageControl;
    
    self.tableView.tableHeaderView = baseView;
    
    [self setupRefresh];
    
    [self.tableView registerClass:[YCRecommendCell class] forCellReuseIdentifier:@"recommendCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
    
    [self.tableView.mj_header beginRefreshing];
    
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
    [self loadAllData];
}

- (void)loadAllData {
    [[YCHttpManager sharedInstance] GET:@"http://capi.douyucdn.cn/api/v1/getHotRoom/2?aid=ios&client_sys=ios&time=1468825800&auth=94d0ae945c16542cc6dee7fe031f1316" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        
        [self.tags removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *roomsDict = dict[@"data"];
        NSArray *tags = [YCTag mj_objectArrayWithKeyValuesArray:roomsDict];
        
        for (int i = 0; i < tags.count; i++) {
            YCTag *tag = tags[i];
            if ([tag.tag_name isEqualToString:@"最热"]) {
                tag.groupImageName = @"home_header_hot_18x18_";
            } else {
                tag.groupImageName = @"home_header_normal_18x18_";
            }
            [self.tags addObject:tag];
        }
        
        [self setupScrollViewData];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupScrollViewData {
    CGFloat btnW = 70;
    CGFloat btnH = 80;
    CGFloat leftMargin = 10;
    CGFloat btnMargin = (self.view.width - 4 * btnW - 2 * leftMargin) / 3;
    NSArray *newTags = [self.tags subarrayWithRange:NSMakeRange(1, self.tags.count - 1)];
    for (int i = 0; i < newTags.count; i++) {
        YCTag *tag = newTags[i];
        int j = i / 8;
        YCGameVerticalButton *btn = [[YCGameVerticalButton alloc] init];
        CGFloat btnX = j * self.view.width + 10 + (i % 4 * (btnW + btnMargin));
        CGFloat btnY = 10 + (i / 4 * (btnH + 10)) - j * 2 * (btnH + 10);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:tag.tag_name forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:tag.icon_url] forState:UIControlStateNormal];
        [self.topScrollView addSubview:btn];
    }
    
    self.pageControl.numberOfPages = (newTags.count + 8 - 1) / 8;
    self.pageControl.currentPage = 0;
    
    self.topScrollView.contentSize = CGSizeMake(self.view.width * ((newTags.count + 8 - 1) / 8), 0);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
    cell.rooms = [self.tags[indexPath.section] room_list];
    // 用来判断是不是颜值分组
    cell.groupName = [self.tags[indexPath.section] groupImageName];
    __weak YCEntainmentViewController *weakSelf = self;
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
    view.tagName = [self.tags[section] tag_name];
    view.imageName = [self.tags[section] groupImageName];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 房间的总数量
    int count = (int)[self.tags[indexPath.section] room_list].count;
    // 判断有多少行
    int rols = (count + 2 - 1) / 2;
    // cell的高度
    CGFloat height = 0;
    height = rols * NormalItemH + (rols) * ItemMargin + 5;
    return height;
}

#pragma mark UIScrolViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrolW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrolW * 0.5) / scrolW;
    self.pageControl.currentPage = page;
}

@end
