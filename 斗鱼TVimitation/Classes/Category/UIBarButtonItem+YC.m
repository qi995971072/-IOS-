//
//  UIBarButtonItem+YC.m
//  aiWeiBo
//
//  Created by xiaochong on 15/9/4.
//  Copyright (c) 2015年 xiaochong. All rights reserved.
//

#import "UIBarButtonItem+YC.h"

@implementation UIBarButtonItem (YC)


+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    if (highIcon) {
        [btn setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    btn.frame = (CGRect){CGPointZero,btn.currentBackgroundImage.size};
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    btn.frame = CGRectMake(0, 0, title.length * 18, 30);
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
