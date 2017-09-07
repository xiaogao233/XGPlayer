//
//  XGPlayer.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGPlayerHeader.h"

@interface XGPlayer : UIView

/* 控制器 */
@property(nonatomic, weak)UIViewController *controller;

- (instancetype)initWithFrame:(CGRect)frame videoGravity:(XGVideoGravity)videoGravity;

- (void)playerWillAppear;

- (void)playerWillDisAppear;

- (void)enterFullScreen;

- (void)exitFullScreen;

@end
