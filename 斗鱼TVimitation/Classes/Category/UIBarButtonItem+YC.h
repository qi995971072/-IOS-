//
//  UIBarButtonItem+YC.h
//  aiWeiBo
//
//  Created by xiaochong on 15/9/4.
//  Copyright (c) 2015年 xiaochong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YC)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end
