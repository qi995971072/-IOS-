//
//  YCLiveCollectionViewController.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/18.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCRoom.h"
#import "YCCollectionViewCell.h"
#import "YCFaceCollectionViewCell.h"

typedef enum {
    LiveCellTypeNormal,
    LiveCellTypeFaceLevel
} LiveCellType;

@interface YCLiveCollectionViewController : UICollectionViewController

@property (nonatomic,assign) LiveCellType cellType;

@property (nonatomic,strong) NSMutableArray *rooms;

@property (nonatomic,assign) int ofset;

@property (nonatomic,copy) NSString *lastUrl;

@end
