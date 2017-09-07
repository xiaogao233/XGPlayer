//
//  CALayer+XGRotateAnimation.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, XGAnimationType) {
    XGAnimationTypeFullScreen,
    XGAnimationTypeSmallScreen
};

typedef void(^animationCompleted)(void);

@interface CALayer (XGRotateAnimation)<CAAnimationDelegate>

/* 动画结束回调 */
@property(nonatomic, copy)animationCompleted completion;

- (void)animateWithType:(XGAnimationType)type duration:(CGFloat)duration fromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame superFrame:(CGRect)superFrame completion:(animationCompleted)completion;

@end
