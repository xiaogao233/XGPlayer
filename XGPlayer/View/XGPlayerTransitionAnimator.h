//
//  XGPlayerTransitionAnimator.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XGPlayerView.h"

@interface XGPlayerTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

/* 图片原位置 */
@property(nonatomic, assign)CGRect originFrame;
/* 展示或消失 */
@property(nonatomic, assign)BOOL presenting;
/* 视频播放器 */
@property(nonatomic, weak)XGPlayerView *playerView;
/* 旋转方向 */
@property(nonatomic, assign)UIInterfaceOrientation orientation;
/* 视屏填充模式 */
@property(nonatomic, assign)XGVideoGravity videoGravity;
/* 是否全屏相互切换 */
@property(nonatomic, assign)BOOL isFullScreenMutualSwitch;

@end
