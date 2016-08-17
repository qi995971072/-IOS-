//
//  YCLivePlayViewController.m
//  斗鱼TVimitation
//
//  Created by xiaochong on 16/7/22.
//  Copyright © 2016年 尹冲. All rights reserved.
//

#import "YCLivePlayViewController.h"
#import "IJKMediaFramework/IJKMediaFramework.h"
#import <Masonry.h>
#import "YCLodingView.h"
#import "YCPortraitControlView.h"
#import "YCLandScapeControlView.h"
#import "YCChannelSelectScrollView.h"
#import "YCSettingScrollView.h"
#import "BarrageRenderer.h"
#import "BarrageDescriptor.h"
#import "BarrageWalkImageTextSprite.h"
#import "NSSafeObject.h"
#import "YCRoomListView.h"
#import "YCRoom.h"

@interface YCLivePlayViewController () <YCPortraitControlViewDelegate, YCLandScapeControlViewDelegate, YCSettingScrollViewDelegate, YCRoomListViewDelegate>
{
    BarrageRenderer *_renderer; // 弹幕
    NSTimer *_spriteTimer;      // 弹幕定时器
    NSTimer *_lockBtnTimer;     // 锁屏按钮自动隐藏定时器
}
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;

/**
 *  提示正在加载的View
 */
@property (nonatomic,strong) YCLodingView *loadingView;

/**
 *  遮盖View
 */
@property (nonatomic,strong) UIView *blackCoverView;

/**
 *  是否是全屏
 */
@property (nonatomic,assign) BOOL isFullScreen;

/**
 *  竖屏的控制view
 */
@property (nonatomic,strong) YCPortraitControlView *portControlView;

/**
 *  横屏的控制view
 */
@property (nonatomic,strong) YCLandScapeControlView *landScapeControlView;
/**
 *  控制的遮盖view
 */
@property (nonatomic,weak) UIView *controlCoverView;
/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer *timer;

/**
 *  频道选择的view
 */
@property (nonatomic,strong) YCChannelSelectScrollView *channelScrolView;

/**
 *  设置的view
 */
@property (nonatomic,strong) YCSettingScrollView *settingScrollView;

/**
 *  展示房间列表的view
 */
@property (nonatomic,strong) YCRoomListView *roomListView;

/**
 *  共有的遮盖view
 */
@property (nonatomic,strong) UIView *commonCoverView;

/**
 *  锁屏btn
 */
@property (nonatomic,strong) UIButton *lockBtn;

@end

@implementation YCLivePlayViewController

+ (instancetype)sharedLivePlayViewController{
    static YCLivePlayViewController *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCLivePlayViewController alloc] init];
    });
    return _instance;
}

#pragma mark - 懒加载
/**
 *  竖屏下的控制view
 */
- (YCPortraitControlView *)portControlView {
    if (!_portControlView) {
        _portControlView = [[YCPortraitControlView alloc] init];
        _portControlView.delegate = self;
    }
    return _portControlView;
}

/**
 *  横屏下的控制的view
 */
- (YCLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        _landScapeControlView = [YCLandScapeControlView landScapeControlView];
        _landScapeControlView.delegate = self;
    }
    return _landScapeControlView;
}

/**
 *  加载动画的view
 */
- (YCLodingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[YCLodingView alloc] init];
        _loadingView.backgroundColor = [UIColor blackColor];
        _loadingView.frame = CGRectMake(0, 20, self.view.width, self.view.width * 9 / 16);
    }
    return _loadingView;
}

/**
 *  播放器
 */
- (IJKFFMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {
        self.liveUrl = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
        _moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.liveUrl withOptions:nil];
    }
    return _moviePlayer;
}
/**
 *  频道选择的view
 */
- (YCChannelSelectScrollView *)channelScrolView {
    if (!_channelScrolView) {
        _channelScrolView = [[YCChannelSelectScrollView alloc] init];
        _channelScrolView.channels = @[@"主线路", @"备用线路5", @"备用线路2", @"备用线路3"];
    }
    return _channelScrolView;
}

/**
 *  设置的view
 */
- (YCSettingScrollView *)settingScrollView {
    if (!_settingScrollView) {
        _settingScrollView = [YCSettingScrollView settingScrollView];
    }
    return _settingScrollView;
}
/**
 *  房间列表view
 */
- (YCRoomListView *)roomListView {
    if (!_roomListView) {
        _roomListView = [[YCRoomListView alloc] init];
    }
    return _roomListView;
}
/**
 *  共有的遮盖，点击这个遮盖将会隐藏横屏下，显示的频道选择、设置、房间列表的view
 */
- (UIView *)commonCoverView {
    if (!_commonCoverView) {
        _commonCoverView = [[UIView alloc] init];
        _commonCoverView.frame = self.view.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commonCoverTaped:)];
        [_commonCoverView addGestureRecognizer:tap];
    }
    return _commonCoverView;
}

/**
 *  隐藏 频道选择、设置、房间列表的view
 */
- (void)commonCoverTaped:(UITapGestureRecognizer *)tapGest {
    [self.commonCoverView removeFromSuperview];
    
    [self.channelScrolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(260);
    }];

    [self.settingScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(260);
    }];
    
    [self.roomListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(260);
    }];

    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.channelScrolView.hidden = YES;
        self.settingScrollView.hidden = YES;
        self.roomListView.hidden = YES;
    }];
}

/**
 *  锁屏按钮
 */
- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [[UIButton alloc] init];
        [_lockBtn addTarget:self action:@selector(lockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lockBtn setImage:[UIImage imageNamed:@"btn_player_unLock_29x29_"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"btn_locking_29x29_"] forState:UIControlStateSelected];
        
    }
    return _lockBtn;
}

/**
 *  点击了锁屏按钮
 */
- (void)lockBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    _isLock = btn.selected;
    if (btn.selected) {
        // 移除自动隐藏控制view的定时器
        [self deleteTimer];
        // 隐藏控制的view
        self.landScapeControlView.hidden = YES;
        // 隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        // 添加自动隐藏锁屏按钮的定时器
        [self addLockBtnTimer];
    } else {
        // 移除自动隐藏锁屏按钮的定时器
        [self deleteLockBtnTimer];
        // 显示控制的view
        self.landScapeControlView.hidden = NO;
        // 显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        // 添加自动隐藏控制view的定时器
        [self addTimer];
    }
    
    btn.hidden = NO;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view的背景
    self.view.backgroundColor = [UIColor whiteColor];

    // 添加子控件及设置约束
    [self setup];
    
    // 添加点击了输入弹幕文本的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTimer) name:@"deleteTimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTimer) name:@"addTimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBarrage:) name:@"sendBarrage" object:nil];
    
    // 监听设备的旋转
    [self listeningRotating];
    
    // 监听播放和暂停
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayOrPause) name:@"PlayStateShouldChanged" object:nil];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 设置状态栏的样式
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 设置回状态栏的样式
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.moviePlayer shutdown];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    
    // 清空所有属性
    self.landScapeControlView = nil;
    self.portControlView = nil;
    self.loadingView = nil;
    self.blackCoverView = nil;
    [self deleteTimer];
    [self deleteSpriteTimer];
    [self deleteLockBtnTimer];
}

/**
 *  添加子控件及设置约束
 */
- (void)setup {
    // 在顶部添加一个黑色的遮盖
    UIView *blackCoverView = [[UIView alloc] init];
    blackCoverView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackCoverView];
    self.blackCoverView = blackCoverView;
    // 设置黑色遮盖view的约束
    [self.blackCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(self.view.width * 9 / 16 + 20);
    }];
    
    // 添加一个竖屏下控制的View
    [self.blackCoverView addSubview:self.portControlView];
    // 设置竖屏控制view的约束
    [self.portControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top).offset(20);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.right.equalTo(self.blackCoverView.mas_right);
        make.bottom.equalTo(self.blackCoverView.mas_bottom);
    }];
    
    
    // 设置播放控制器view的位置
    [self setupMoviePlayerViewWithTopMargin:20];
    
    
    // 添加一个横屏下控制的view
    [self.blackCoverView addSubview:self.landScapeControlView];
    self.landScapeControlView.hidden = YES;
    
    // 添加一个controlCoverView，来控制控制view显示和隐藏
    UIView *controlCoverView = [[UIView alloc] init];
    [self.blackCoverView insertSubview:controlCoverView belowSubview:self.portControlView];
    self.controlCoverView = controlCoverView;
    
    // 添加一个手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapControlView:)];
    [self.controlCoverView addGestureRecognizer:tap];
    [self.controlCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top).offset(20);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.right.equalTo(self.blackCoverView.mas_right);
        make.bottom.equalTo(self.blackCoverView.mas_bottom);
    }];
    
    // 添加一个频道选择的view
    [self.view addSubview:self.channelScrolView];
    [self.channelScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right).offset(260);
        make.height.offset(self.view.width);
        make.width.offset(260);
    }];
    self.channelScrolView.hidden = YES;
    
    __weak YCLivePlayViewController *weakSelf = self;
    self.channelScrolView.selectedChannel = ^(NSString *title, NSString *channelString) {
        NSLog(@"%@, %@", title, channelString);
        [weakSelf commonCoverTaped:nil];
    };
    
    // 添加一个设置的view
    [self.view addSubview:self.settingScrollView];
    self.settingScrollView.settingScrollViewDelegate = self;
    [self.settingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right).offset(260);
        make.height.offset(self.view.width);
        make.width.offset(260);
    }];
    self.settingScrollView.hidden = YES;
    
    // 添加一个展示房间列表的view
    [self.view addSubview:self.roomListView];
    self.roomListView.delegate = self;
    [self.roomListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right).offset(260);
        make.height.offset(self.view.width);
        make.width.offset(260);
    }];
    self.roomListView.hidden = YES;
    
    // 添加弹幕
    _renderer = [[BarrageRenderer alloc] init];
    NSNumber *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"barrageLocation"];
    switch (locationID.intValue) {
        case 1:
            _renderer.canvasMargin = UIEdgeInsetsMake(0, 0, self.view.width / 2, 0);
            break;
        case 2:
            _renderer.canvasMargin = UIEdgeInsetsMake(self.view.width / 2, 0, 0, 0);
            break;
        case 3:
            _renderer.canvasMargin = UIEdgeInsetsMake(1, 0, 0, 0);
            break;
        default:
            break;
    }
    [self.blackCoverView insertSubview:_renderer.view belowSubview:self.landScapeControlView];
    
    // 添加锁屏按钮
    [self.view addSubview:self.lockBtn];
    self.lockBtn.hidden = YES;
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(44);
        make.height.offset(44);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.75);
    }];
}

/**
 *  发送一个弹幕
 */
- (void)sendBarrage:(NSNotification *)note {
    NSString *text = note.userInfo[@"text"];
    [_renderer receive:[self walkImageTextSpriteDescriptorAWithText:text textColor:[UIColor redColor]]];
}

/**
 *  图文混排精灵弹幕 - 过场图文弹幕A
 */
- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithText:(NSString *)text textColor:(UIColor *)color {
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.params[@"text"] = text;
    descriptor.spriteName = NSStringFromClass([BarrageWalkImageTextSprite class]);
    descriptor.params[@"textColor"] = color;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    // 字体最大可以为 25   15
    CGFloat fontsize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"barrageTextFontSize"] floatValue];
    if (fontsize == 0) {
        fontsize = 15;
    }
    descriptor.params[@"fontSize"] = @(fontsize);
    return descriptor;
}

/**
 *  自己设置的弹幕文字
 */
- (NSArray *)spriteTexts {
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sprite.plist" ofType:nil]];
}

/**
 *  自动发送一个弹幕
 */
- (void)autoSendBarrage {
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 30) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkImageTextSpriteDescriptorAWithText:self.spriteTexts[arc4random_uniform((uint32_t)self.spriteTexts.count)] textColor:[UIColor whiteColor]]];
    }
}

#pragma mark - 定时器相关
/** 添加自动隐藏控制view定时器 */
- (void)addTimer {
    [self deleteTimer];
    self.lockBtn.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(autoHideControlView) userInfo:nil repeats:NO];
    // 共享主线程
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  自动隐藏控制的view
 */
- (void)autoHideControlView {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (!(interfaceOrientation == UIInterfaceOrientationPortrait)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    // 隐藏竖屏的控制view
    self.portControlView.hidden = YES;
    // 隐藏横屏的控制view
    self.landScapeControlView.hidden = YES;
    // 隐藏锁屏按钮
    self.lockBtn.hidden = YES;
    
    [self deleteTimer];
}

/** 移除自动隐藏控制view定时器 */
- (void)deleteTimer {
    self.lockBtn.hidden = YES;
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  添加自动发送弹幕的定时器
 */
- (void)addSpriteTimer {
    NSSafeObject * safeObj = [[NSSafeObject alloc] initWithObject:self withSelector:@selector(autoSendBarrage)];
    _spriteTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    [_renderer start];
}

/**
 *  移除自动发送弹幕的定时器
 */
- (void)deleteSpriteTimer {
    [_spriteTimer invalidate];
    _spriteTimer = nil;
    [_renderer stop];
}

/**
 *  添加自动隐藏锁屏btn的定时器
 */
- (void)addLockBtnTimer {
    _lockBtnTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoHideLockBtn) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_lockBtnTimer forMode:NSRunLoopCommonModes];
}

- (void)autoHideLockBtn {
    self.lockBtn.hidden = YES;
}

/**
 *  移除自动隐藏锁屏btn的定时器
 */
- (void)deleteLockBtnTimer {
    [_lockBtnTimer invalidate];
    _lockBtnTimer = nil;
}

/**
 *  设置播放器的约束
 */
- (void)setupMoviePlayerViewWithTopMargin:(CGFloat)margin {
    // 16 : 9 = self.view.width : height
    [self.blackCoverView insertSubview:self.moviePlayer.view atIndex:0];
    [self.moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top).offset(margin);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.right.equalTo(self.blackCoverView.mas_right);
        make.bottom.equalTo(self.blackCoverView.mas_bottom);
    }];
    
    
    // 添加一个加载动画的ImageView
    [self.blackCoverView insertSubview:self.loadingView atIndex:0];
    [self.loadingView starAnim];
    
    // 注册监听
    [self setupMovieNotifications];
    
    // 开始播放
    [self.moviePlayer prepareToPlay];
    
    // 设置自动隐藏控制的view
    [self addTimer];
}

/**
 *  点击了控制view的遮盖view，用来显示和隐藏控制的view
 */
- (void)tapControlView:(UITapGestureRecognizer *)tapGest {
    
    if (self.isLock) {
        if (self.lockBtn.hidden) {
            self.lockBtn.hidden = NO;
            [self addLockBtnTimer];
        } else {
            [self deleteLockBtnTimer];
            self.lockBtn.hidden = YES;
        }
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        if (self.portControlView.hidden) {
            // 显示竖屏的控制view
            self.portControlView.hidden = NO;
            // 设置自动隐藏
            [self addTimer];
        } else {
            // 取消自动隐藏
            [self deleteTimer];
            // 隐藏竖屏的控制view
            self.portControlView.hidden = YES;
        }
        // 始终隐藏锁屏按钮
        self.lockBtn.hidden = YES;
    } else {
        if (self.landScapeControlView.hidden) {
            // 显示横屏的控制view
            self.landScapeControlView.hidden = NO;
            // 显示状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            // 设置自动隐藏控制view
            [self addTimer];
            // 显示锁屏按钮
            self.lockBtn.hidden = NO;
        } else {
            // 取消自动隐藏控制view
            [self deleteTimer];
            // 隐藏横屏的控制view
            self.landScapeControlView.hidden = YES;
            // 隐藏状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            // 隐藏锁屏按钮
            self.lockBtn.hidden = YES;
        }
    }
}


#pragma mark - 监听方法
/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

/**
 *  设置播放和暂停
 */
- (void)setPlayOrPause {
   IJKMPMovieLoadState loadState = self.moviePlayer.loadState;
    if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        return;
    }
    if (self.moviePlayer.isPlaying) {
        [self.moviePlayer pause];
        [self.portControlView setIsPlaying:NO];
        [self.landScapeControlView setIsPlaying:NO];
        
    } else {
        [self.moviePlayer play];
        [self.portControlView setIsPlaying:YES];
        [self.landScapeControlView setIsPlaying:YES];
    }
}
/**
 *  设置的方向改变了
 */
- (void)deviceOrientationChanged {
    if (self.lockBtn.isSelected) {
        return;
    }
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            NSLog(@"竖屏");
            // 设置竖屏
            [self setOrientationPortrait];
        }
        break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"横屏");
            // 设置横屏
            [self setOrientationLandscape];
        }
        break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"横屏");
            // 设置横屏
            [self setOrientationLandscape];
        }
        break;
        default:
            break;
    }
}

/**
 *  程序进入后台
 */
- (void)appDidEnterBackground {
    [self.moviePlayer pause];
    [self.portControlView setIsPlaying:NO];
    [self.landScapeControlView setIsPlaying:NO];}

/**
 *  程序进入前台
 */
- (void)appDidEnterPlayGround {
    [self.moviePlayer play];
    [self.portControlView setIsPlaying:YES];
    [self.landScapeControlView setIsPlaying:YES];
}

/**
 准备播放             IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification;
 尺寸改变发出的通知     IJKMPMoviePlayerScalingModeDidChangeNotification;
 播放完成后者用户退出   IJKMPMoviePlayerPlaybackDidFinishNotification;
 播放完成后者用户退出的原因（key） IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (IJKMPMovieFinishReason)
 播放状态改变了        IJKMPMoviePlayerPlaybackStateDidChangeNotification;
 加载状态改变了        IJKMPMoviePlayerLoadStateDidChangeNotification;
 目前不知道这个代表啥          IJKMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;
 * */

/**
 *  注册监听
 */
- (void)setupMovieNotifications {
    // 监听加载状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.moviePlayer];
    
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"准备播放了");
}

/**
 *  视频加载状态改变了
 IJKMPMovieLoadStateUnknown == 0
 IJKMPMovieLoadStatePlayable == 1
 IJKMPMovieLoadStatePlaythroughOK == 2
 IJKMPMovieLoadStateStalled == 4
 */
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.moviePlayer.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        // 加载完成，即将播放，停止加载的动画，并将其移除
        [self.loadingView stopAnim];
        [self.loadingView removeFromSuperview];
        NSLog(@"加载完成, 自动播放了 LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
        NSLog(@"自动暂停了，loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        [self.blackCoverView insertSubview:self.loadingView aboveSubview:self.moviePlayer.view];
        [self.loadingView starAnim];
    } else if ((loadState & IJKMPMovieLoadStatePlayable) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlayable: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: %d\n", (int)loadState);
    }
    
}

#pragma mark - 设置强制屏幕转屏
/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  设置横屏的控件的位置
 */
- (void)setOrientationLandscape {

    [self deleteTimer];
    
    [self.blackCoverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(self.view.height);
    }];
    [self.moviePlayer.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.right.equalTo(self.blackCoverView.mas_right);
        make.bottom.equalTo(self.blackCoverView.mas_bottom);
    }];
    [self.blackCoverView layoutIfNeeded];
    // 隐藏竖屏的控制view
    self.portControlView.hidden = YES;
    // 隐藏横屏的控制view
    self.landScapeControlView.hidden = YES;
    // 隐藏锁屏按钮
    self.lockBtn.hidden = YES;
    // 设置横屏的控制约束
    [self.landScapeControlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.width.offset(self.view.width);
        make.height.offset(self.view.height);
    }];
    
    self.loadingView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    // 显示弹幕
    [self addSpriteTimer];
    // 设置横屏的弹幕为打开模式
    [self.landScapeControlView setIsOpenBarrage:YES];
}

/**
 *  设置竖屏的控件的约束
 */
- (void)setOrientationPortrait {
    // 添加自动隐藏的定时器
    [self addTimer];
    
    [self.blackCoverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(self.view.width * 9 / 16 + 20);
    }];
    [self.moviePlayer.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top).offset(20);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.right.equalTo(self.blackCoverView.mas_right);
        make.bottom.equalTo(self.blackCoverView.mas_bottom);
    }];
    self.landScapeControlView.hidden = YES;
    [self.landScapeControlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackCoverView.mas_top);
        make.left.equalTo(self.blackCoverView.mas_left);
        make.width.offset(600);
        make.height.offset(600);
    }];
    
    self.portControlView.hidden = NO;
    self.loadingView.frame = CGRectMake(0, 20, self.view.width, self.view.width * 9 / 16);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    

    // 如果是自动转屏，就需要手动请求正在显示的设置和视频选择的view
    [self.commonCoverView removeFromSuperview];
    [self.channelScrolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(260);
    }];
    
    [self.settingScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(260);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    self.channelScrolView.hidden = YES;
    self.settingScrollView.hidden = YES;
    self.roomListView.hidden = YES;
    self.lockBtn.hidden = YES;
    
    // 隐藏弹幕
    [self deleteSpriteTimer];

}

#pragma mark - YCPortraitControlViewDelegate
/**
 *  返回
 */
- (void)portControlViewDidClickBackBtn:(YCPortraitControlView *)portControlView {
    // 如果是横屏就换成竖屏
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  全屏
 */
- (void)portControlView:(YCPortraitControlView *)portControlView setLandScape:(UIInterfaceOrientation)interfaceOrientation {
    [self interfaceOrientation:interfaceOrientation];
}

#pragma mark - YCLandScapeControlViewDelegate
/**
 *  退出全屏
 */
- (void)landScapeControlViewDidClickBackBtn:(YCLandScapeControlView *)landScapeControlView {
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

/**
 *  刷新播放
 */
- (void)landScapeControllViewDidClickRefreshBtn:(YCLandScapeControlView *)landScapeControlView {
    // 清空所有的设置
    [self.moviePlayer shutdown];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    [self.loadingView removeFromSuperview];
    
    [self.portControlView setIsPlaying:YES];
    [self.landScapeControlView setIsPlaying:YES];
    
    [self setupMoviePlayerViewWithTopMargin:0];

}
/**
 *  关注和取消关注
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didAttention:(BOOL)isAttention {
    NSString *attentionStr = isAttention ? @"关注" : @"取消关注";
    NSLog(@"%@", attentionStr);
}

/**
 *  打开或关闭礼物
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didCliciGiftBtn:(BOOL)isOpenGift {
    NSString *giftStr = isOpenGift ? @"打开gift" : @"关闭gift";
    NSLog(@"%@", giftStr);
}
/**
 *  分享
 */
- (void)landScapeControlViewDidClickShareBtn:(YCLandScapeControlView *)landScapeControlView {
    NSLog(@"分享");
}

/**
 *  频道选择
 */
- (void)landScapeControlViewDidClickChannelSelectBtn:(YCLandScapeControlView *)landScapeControlView {
    
    self.channelScrolView.hidden = NO;
    
    [self deleteTimer];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.landScapeControlView.hidden = YES;
    
    [self.view insertSubview:self.commonCoverView belowSubview:self.channelScrolView];
    
    [self.channelScrolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  点击了设置
 */
- (void)landScapeControlViewDidClickSettingBtn:(YCLandScapeControlView *)landScapeControlView {
    self.settingScrollView.hidden = NO;
    
    [self deleteTimer];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.landScapeControlView.hidden = YES;
    
    [self.view insertSubview:self.commonCoverView belowSubview:self.settingScrollView];

    [self.settingScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
/**
 *  点击了弹幕
 */
- (void)landScapeControllView:(YCLandScapeControlView *)landScapeControlView didCliciBarrageBtn:(BOOL)isOpenBarrage {
    if (isOpenBarrage) {
        [self addSpriteTimer];
    } else {
        [self deleteSpriteTimer];
    }
}

/**
 *  点击了房间列表
 */
- (void)landScapeControllViewdidClickRoomListBtn:(YCLandScapeControlView *)landScapeControlView {
    self.roomListView.hidden = NO;
    
    [self deleteTimer];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.landScapeControlView.hidden = YES;
    
    [self.view insertSubview:self.commonCoverView belowSubview:self.roomListView];
    
    [self.roomListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - YCSettingScrollViewDelegate
/**
 *  修改了弹幕的属性
 */
- (void)settingScrollView:(YCSettingScrollView *)settingScrollView didChangeBarrageAttributeType:(BarrageAttributeType)type value:(CGFloat)value {
    switch (type) {
        case BarrageAttributeTypeAlpha: {
                CGFloat alpha = 0.3 + 0.7 * value;
                [[NSUserDefaults standardUserDefaults] setObject:@(alpha) forKey:@"barrageTextAlpha"];
            }
            break;
        case BarrageAttributeTypeFont: {
                CGFloat fontSize = 15 + value * 10;
                [[NSUserDefaults standardUserDefaults] setObject:@(fontSize) forKey:@"barrageTextFontSize"];
            }
            break;
        case BarrageAttributeTypeBrightness:{
                [[UIScreen mainScreen] setBrightness:value];
            }
            break;
        case BarrageAttributeTypeSoftDecodingPerformance:
            NSLog(@"修改了  软解码程度  value 为 ： %f", value);
            break;
        default:
            break;
    }
}

/**
 *  修改弹幕的位置
 */
- (void)settingScrollView:(YCSettingScrollView *)settingScrollView changeBarrageLocationID:(int)locationID {
    switch (locationID) {
        case 1:
            _renderer.canvasMargin = UIEdgeInsetsMake(0, 0, self.view.height / 2, 0);
            break;
        case 2:
            _renderer.canvasMargin = UIEdgeInsetsMake(self.view.height / 2, 0, 0, 0);
            break;
        case 3:
#warning 如果都为0的话，将不能修改，可以点击去canvasMargin查看
            _renderer.canvasMargin = UIEdgeInsetsMake(1, 0, 0, 0);
            break;
        default:
            break;
    }
}

#pragma mark - YCRoomListViewDelegate
- (void)roomListView:(YCRoomListView *)roolListView didSelectRoom:(YCRoom *)room {
    NSLog(@"选中了id为 %@ 的房间", room.room_id);
    [self commonCoverTaped:nil];
}

- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
