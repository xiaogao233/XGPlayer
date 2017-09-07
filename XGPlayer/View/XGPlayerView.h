//
//  XGPlayerView.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/13.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XGPlayerHeader.h"

@interface XGPlayerView : UIView

@property(nonatomic, strong)AVPlayerLayer *playerLayer;
/* avplayer的初始frame */
@property(nonatomic, assign, readonly)CGRect playerFrame;
/* 视屏填充模式 */
@property(nonatomic, assign)XGVideoGravity videoGravity;

/**
 没有动画的退出全屏，需要重新设置frame
 */
- (void)exitFullScreenWithOutAnimation;

@end
