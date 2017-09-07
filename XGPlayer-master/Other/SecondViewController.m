//
//  SecondViewController.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "SecondViewController.h"
#import "XGPlayer.h"
#import "ViewController.h"

@interface SecondViewController ()<UIAlertViewDelegate>

/* 视频播放器 */
@property(nonatomic, strong)XGPlayer *player;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)dealloc
{
    NSLog(@"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.player playerWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.player playerWillDisAppear];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.player];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-80)/2, CGRectGetHeight(self.view.frame)-80, 80, 40)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"旋转" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    __block typeof(*&self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试" message:@"这是一段详细文字" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)btnAction:(UIButton *)sender
{
    [self.player enterFullScreen];
}

#pragma mark - lazy
- (XGPlayer *)player
{
    if (!_player) {
        _player = [[XGPlayer alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 200) videoGravity:XGVideoGravityResizeAspect];
        _player.controller = self;
    }
    return _player;
}

@end
