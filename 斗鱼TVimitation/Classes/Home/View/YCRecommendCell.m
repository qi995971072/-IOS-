//
//  YCRecommendCell.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/16.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCRecommendCell.h"
#import "YCCollectionViewCell.h"
#import "YCFaceCollectionViewCell.h"

@interface YCRecommendCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation YCRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = ItemMargin;
    flowLayout.minimumInteritemSpacing = ItemMargin;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.contentInset = UIEdgeInsetsMake(5, 10, 0, 10);
    collectionView.scrollEnabled = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"YCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"YCFaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"faceCollectionViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {

    self.collectionView.frame = self.bounds;
}

- (void)setGroupName:(NSString *)groupName {
    _groupName = groupName;
    if ([groupName isEqualToString:@"颜值"]) {
        // 重新设置itemSize
        CGFloat itemSizeW = NormalItemW;
        CGFloat itemSizeH = FaceItemH;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    } else {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(NormalItemW, NormalItemH);

    }
    [self.collectionView reloadData];
}

- (void)setRooms:(NSArray *)rooms {
    _rooms = rooms;
    
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.groupName isEqualToString:@"颜值"]) {
        YCFaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCollectionViewCell" forIndexPath:indexPath];
        cell.room = self.rooms[indexPath.item];
        return cell;
    } else {
        YCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
        cell.room = self.rooms[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", self.groupName);
    if (self.block) {
        self.block((YCRoom *)self.rooms[indexPath.item]);
    }
}

@end
