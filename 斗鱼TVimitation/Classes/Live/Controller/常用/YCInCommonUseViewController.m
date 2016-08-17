//
//  YCInCommonUseViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/18.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCInCommonUseViewController.h"
#import "YCTag.h"
#import "YCLiveDownButtonView.h"
#import "YCLivePlayViewController.h"


#define TagsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tags.data"]

@interface YCInCommonUseViewController ()

@property (nonatomic,strong) NSMutableArray *inCommonTags;

@property (nonatomic,weak) UIScrollView *baseScrollView;

@end

@implementation YCInCommonUseViewController
- (NSMutableArray *)inCommonTags {
    if (!_inCommonTags) {
        _inCommonTags = [NSMutableArray array];
    }
    return _inCommonTags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建一个scrollView
    UIScrollView *baseScrollView = [[UIScrollView alloc] init];
    baseScrollView.frame = self.view.bounds;
    [self.view addSubview:baseScrollView];
    self.baseScrollView = baseScrollView;
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTag:) name:@"addTag" object:nil];

    [self addTag:nil];
}

/**
 *  监听方法
 */
- (void)addTag:(NSNotification *)note {
   YCTag *tag = note.userInfo[@"tag"];
    NSMutableArray *tags = [NSKeyedUnarchiver unarchiveObjectWithFile:TagsPath];
    if (tags == nil) {
        tags = [NSMutableArray array];
        if (tag) {
            [tags addObject:tag];
        }
        [NSKeyedArchiver archiveRootObject:tags toFile:TagsPath];
    } else {
        for (YCTag *tag2 in tags) {
            if ([tag2 isEqual:tag]) {
                [tags removeObject:tag2];
                break;
            }
        }
        if (tag) {
            [tags insertObject:tag atIndex:0];
        }
        [NSKeyedArchiver archiveRootObject:tags toFile:TagsPath];
    }
    
    [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < tags.count; i++) {
        YCTag *tag = tags[i];
        YCLiveDownButtonView *btn = [YCLiveDownButtonView downButtonView];
        [btn.tagIconView sd_setImageWithURL:[NSURL URLWithString:tag.icon_url]];
        btn.tagNameLabel.text = tag.tag_name;
        [self.baseScrollView addSubview:btn];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClick:)];
        [btn addGestureRecognizer:tap];
    }
}

- (void)buttonViewClick:(UITapGestureRecognizer *)tapGest {
    YCLivePlayViewController *playVc = [[YCLivePlayViewController alloc] init];
    [self.navigationController pushViewController:playVc animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < self.baseScrollView.subviews.count; i++) {
        YCLiveDownButtonView *btn = self.baseScrollView.subviews[i];
        btnX = (i) % 3 * btnW;
        btnY = (i) / 3 * btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    self.baseScrollView.contentSize = CGSizeMake(0, (self.baseScrollView.subviews.count + 3 - 1) / 3 * btnH);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
