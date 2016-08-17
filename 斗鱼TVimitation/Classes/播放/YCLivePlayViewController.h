//
//  YCLivePlayViewController.h
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/22.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCLivePlayViewController : UIViewController
/**
 *  直播的地址
 */
@property (nonatomic,copy) NSString *liveUrl;

/**
 *  是否锁屏
 */
@property (nonatomic,assign,readonly) BOOL isLock;
@end
