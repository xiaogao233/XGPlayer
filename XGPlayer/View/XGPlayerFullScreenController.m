//
//  XGPlayerFullScreenController.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayerFullScreenController.h"
#import "XGPlayerHeader.h"

@interface XGPlayerFullScreenController ()

/* 不使用自动旋转 */
@property(nonatomic, assign)BOOL disableAutorotate;
/* 是否全屏相互切换 */
@property(nonatomic, assign)BOOL isFullScreenMutualSwitch;

@end

@implementation XGPlayerFullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)dealloc
{
    NSLog(@"");
}

- (BOOL)shouldAutorotate
{
    if (_disableAutorotate) return NO;
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.orientation == UIInterfaceOrientationLandscapeLeft) return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationLandscapeLeft;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    [self.playerView removeFromSuperview];
    [self.view addSubview:self.playerView];
}

- (void)exitFullScreen:(BOOL)animation
{
    __weak __typeof(&*self) weakSelf = self;
    [self dismissViewControllerAnimated:animation completion:^{
        if (weakSelf.dismissVCBlock) weakSelf.dismissVCBlock();
    }];
}

- (void)switchFullScreen:(dispatch_block_t)completion
{
    _disableAutorotate = YES;
    _isFullScreenMutualSwitch = !_isFullScreenMutualSwitch;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (_isFullScreenMutualSwitch)
    {
        transform = CGAffineTransformRotate(self.view.transform, -M_PI);
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:self.orientation animated:NO];
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.view.transform = transform;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
    _disableAutorotate = NO;
}

- (void)switchFullScreen
{
    [self switchFullScreen:nil];
}

- (void)tapAction:(UIGestureRecognizer *)gest
{
    [self exitFullScreen:YES];
}

#pragma mark - getting方法
- (BOOL)isMutualSwitch
{
    return _isFullScreenMutualSwitch;
}

@end
