//
//  XGPlayerFullScreenController.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGPlayerView.h"

typedef void(^dismissVCBlock)(void);

@interface XGPlayerFullScreenController : UIViewController

/* 播放器 */
@property(nonatomic, weak)XGPlayerView *playerView;
/* 旋转方向 */
@property(nonatomic, assign)UIInterfaceOrientation orientation;
/* 是否全屏相互切换 */
@property(nonatomic, assign, readonly)BOOL isMutualSwitch;
/* 消失回调 */
@property(nonatomic, copy)dismissVCBlock dismissVCBlock;

- (void)exitFullScreen:(BOOL)animation;

- (void)switchFullScreen;

- (void)switchFullScreen:(dispatch_block_t)completion;

@end
