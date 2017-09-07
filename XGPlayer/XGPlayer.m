//
//  XGPlayer.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayer.h"
#import "XGPlayerFullScreenController.h"
#import "XGPlayerTransitionAnimator.h"
#import "XGPlayerHeader.h"
#import "XGPlayerView.h"

@interface XGPlayer ()<UIViewControllerTransitioningDelegate>

/* 全屏控制器 */
@property(nonatomic, strong)XGPlayerFullScreenController *fullScreenPlayerVC;
/* 旋转方向 */
@property(nonatomic, assign)UIInterfaceOrientation orientation;
/* 禁用系统旋转 */
@property(nonatomic, assign)BOOL disableSystemRotate;
/* 视频播放视图 */
@property(nonatomic, strong)XGPlayerView *playerView;
/* 视屏填充模式 */
@property(nonatomic, assign)XGVideoGravity videoGravity;


@end

@implementation XGPlayer

- (instancetype)initWithFrame:(CGRect)frame videoGravity:(XGVideoGravity)videoGravity
{
    if (self = [super initWithFrame:frame])
    {
        _videoGravity = videoGravity;
        [self initLayout];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@%@",[self class],NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)playerWillAppear
{
    self.disableSystemRotate = NO;
}

- (void)playerWillDisAppear
{
    self.disableSystemRotate = YES;
    [self exitFullScreen];
}

- (void)initLayout
{
    [self initNotification];
    [self addSubview:self.playerView];
}

- (void)initNotification
{
    /* 监测设备方向 */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)deviceOrientationChange
{
    if (self.disableSystemRotate) return;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) return;
    
    if (YES)
    {
        /* 当前屏幕方向 */
        UIInterfaceOrientation curOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (curOrientation == interfaceOrientation) return;
        if (interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            if (self.fullScreenPlayerVC)
            {
                [self.fullScreenPlayerVC exitFullScreen:YES];
            }
        }
        else
        {
            if (curOrientation != UIInterfaceOrientationPortrait)
            {
                if (self.fullScreenPlayerVC)
                {
                    /* 全屏相互切换 */
                    self.orientation = interfaceOrientation;
                    self.fullScreenPlayerVC.orientation = interfaceOrientation;
                    [self.fullScreenPlayerVC switchFullScreen];
                }
            }
            else
            {
                [self enterIntoFullScreen:interfaceOrientation];
            }
        }
    }
}

- (void)enterIntoFullScreen:(UIInterfaceOrientation)orientation
{
    self.orientation = orientation;
    
    XGPlayerFullScreenController *vc = [[XGPlayerFullScreenController alloc] init];
    vc.playerView = self.playerView;
    vc.orientation = self.orientation;
    XGWS(weakSelf);
    vc.dismissVCBlock = ^{
        [weakSelf.playerView removeFromSuperview];
        [weakSelf addSubview:self.playerView];
        weakSelf.fullScreenPlayerVC = nil;
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.transitioningDelegate = self;
    /* 使用该模式，当前控制器生命周期将不执行 */
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [_controller presentViewController:nav animated:YES completion:^{
        weakSelf.fullScreenPlayerVC = vc;
    }];
}

- (void)enterFullScreen
{
    [self enterIntoFullScreen:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullScreen
{
    if (self.fullScreenPlayerVC)
    {
        [self.fullScreenPlayerVC exitFullScreen:NO];
        [self.playerView exitFullScreenWithOutAnimation];
    }
}

#pragma mark - Notification
- (void)appWillResignActive
{
    self.disableSystemRotate = YES;
}

- (void)appDidEnterBackground
{
//    NSLog(@"appDidEnterBackground");
}

- (void)appWillEnterForeground
{
//    NSLog(@"appWillEnterForeground");
}

- (void)appDidBecomeActive
{
    self.disableSystemRotate = NO;
}

#pragma mark - lazy
- (XGPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[XGPlayerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _playerView.videoGravity = self.videoGravity;
    }
    return _playerView;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [self generateAnimatorWithPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [self generateAnimatorWithPresenting:NO];
}

- (XGPlayerTransitionAnimator *)generateAnimatorWithPresenting:(BOOL)presenting
{
    XGPlayerTransitionAnimator *animator = [[XGPlayerTransitionAnimator alloc] init];
    animator.playerView = self.playerView;
    animator.presenting = presenting;
    animator.orientation = self.orientation;
    animator.videoGravity = self.videoGravity;
    animator.isFullScreenMutualSwitch = self.fullScreenPlayerVC?self.fullScreenPlayerVC.isMutualSwitch:NO;
    animator.originFrame = [self.superview convertRect:self.frame toView:nil];
    return animator;
}

@end
