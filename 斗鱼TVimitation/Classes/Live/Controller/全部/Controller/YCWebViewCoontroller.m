//
//  YCWebViewCoontroller.m
//  众商生活
//
//  Created by xiaochong on 16/7/10.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCWebViewCoontroller.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UIBarButtonItem+YC.h"

@interface YCWebViewCoontroller ()<UIWebViewDelegate, NJKWebViewProgressDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) NJKWebViewProgressView *progressView;

@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

@property (nonatomic,weak) UIWebView *webView;

@property (nonatomic,strong) UIBarButtonItem *item;

@property (nonatomic,strong) UIBarButtonItem *goItem;

@property (nonatomic,strong) UIBarButtonItem *backItem;

@end

@implementation YCWebViewCoontroller

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    webView.frame = self.view.bounds;
    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    [self.progressView setProgress:0];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    

    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"dyla_刷新pressed_22x22_" highIcon:nil target:self action:@selector(refresh)];
    
    self.item = self.navigationItem.leftBarButtonItem;
    UIButton *btn = self.item.customView;
    [btn removeTarget:self.navigationController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加一个toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.frame = CGRectMake(0, self.view.height - 49, self.view.width, 49);
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"←" style:UIBarButtonItemStyleDone target:self action:@selector(backToLastInterface)];
    backItem.enabled = NO;
    self.backItem = backItem;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *goItem = [[UIBarButtonItem alloc] initWithTitle:@"→" style:UIBarButtonItemStyleDone target:self action:@selector(goToNewInterface)];
    goItem.enabled = NO;
    self.goItem = goItem;
    toolBar.items = @[backItem, item2, goItem];
    
}

- (void)backToLastInterface {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        self.backItem.enabled = NO;
        self.goItem.enabled = YES;
    }
}

- (void)goToNewInterface {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    } else {
        self.goItem.enabled = NO;
        self.backItem.enabled = YES;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
}

- (void)refresh {
    [self.webView reload];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.backItem.enabled = [self.webView canGoBack];
    self.goItem.enabled = [self.webView canGoForward];
}


@end
