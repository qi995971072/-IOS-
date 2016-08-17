//
//  YCGameViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/13.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCGameViewController.h"
#import "YCRecommendHeaderView.h"
#import "YCTag.h"
#import "YCGameVerticalButton.h"
#import "YCGameCell.h"

@interface YCGameViewController ()

@property (nonatomic,strong) UIScrollView *topScrollView;

@property (nonatomic,strong) NSArray *allTags;

@end

@implementation YCGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加顶部的常用控件
    [self setupHeaderView];
    
    // 添加刷新控件
    [self setupRefresh];
    
    [self.tableView registerClass:[YCGameCell class] forCellReuseIdentifier:@"gameCell"];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;

    [self.tableView.mj_header beginRefreshing];
}

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.bounds = CGRectMake(0, 0, self.view.width, 140);
    headerView.backgroundColor = YCColor(233, 233, 233);
    
    YCRecommendHeaderView *tagView = [[YCRecommendHeaderView alloc] init];
    tagView.frame = CGRectMake(0, 0, self.view.width, 30);
    tagView.tagName = @"常用";
    tagView.imageName = @"Img_orange_3x14_";
    tagView.hideMoreBtn = YES;
    [headerView addSubview:tagView];
    
    // 添加一个scrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.width, 100)];
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.showsHorizontalScrollIndicator = NO;
    [headerView addSubview:topScrollView];
    self.topScrollView = topScrollView;
    
    self.tableView.tableHeaderView = headerView;
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
    [self loadScrollViewData];
    
    [self loadAllGameData];
}

- (void)loadScrollViewData {
    [[YCHttpManager sharedInstance] GET:@"http://capi.douyucdn.cn/api/v1/getHotCate?aid=ios&client_sys=ios&time=1468636740&auth=a326ef2a1a645e479a853e9486878776" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *tagsDict = dict[@"data"];
        NSArray *tags = [YCTag mj_objectArrayWithKeyValuesArray:tagsDict];
        CGFloat leftMargin = 10;
        CGFloat btnMargin = 15;
        CGFloat btnY = 10;
        CGFloat btnW = 70;
        CGFloat btnH = 80;
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
        
        self.topScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + leftMargin, 0);
        [self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadAllGameData {
    [[YCHttpManager sharedInstance] GET:@"http://capi.douyucdn.cn/api/v1/getColumnDetail?aid=ios&client_sys=ios&shortName=game&time=1468640760&auth=73e5e04ce9fc4eef33036c56707f53c5" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSData *responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject.mj_JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *tagsDict = dict[@"data"];
        NSArray *tags = [YCTag mj_objectArrayWithKeyValuesArray:tagsDict];
        self.allTags = tags;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCGameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gameCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.allTags = self.allTags;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCRecommendHeaderView *view = [[YCRecommendHeaderView alloc] init];
    view.tagName = @"全部";
    view.hideMoreBtn = YES;
    view.imageName = @"Img_orange_3x14_";
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 房间的总数量
    int count = (int)self.allTags.count;
    // 判断有多少行
    int rols = (count + 3 - 1) / 3;
    // 计算 cell的高度
    CGFloat height = rols * (GameBtnH + 2 * GameBtnMargin);
    return height;
}


@end
