//
//  XGPlayerTransitionAnimator.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayerTransitionAnimator.h"
#import "CALayer+XGRotateAnimation.h"
#import "XGPlayerHeader.h"
#import "XGPlayerHandler.h"

@implementation XGPlayerTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.presenting = YES;
        self.originFrame = CGRectZero;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimationTime;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)])
    {
        /* iOS8以上用此方法准确获取 */
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else
    {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    
    UIView *container = [transitionContext containerView];
    container.backgroundColor = [UIColor clearColor];
    
    UIView *pictureView = self.presenting ? toView : fromView;
    
    if (self.presenting)
    {
        pictureView.frame = container.frame;
    }
    else
    {
        toView.frame = container.frame;
    }
    
    [container addSubview:toView];
    [container bringSubviewToFront:pictureView];
    
    if (self.presenting)
    {
        if (self.orientation == UIInterfaceOrientationLandscapeLeft)
        {
            pictureView.frame = self.originFrame;
            pictureView.transform = CGAffineTransformTranslate(pictureView.transform, CGRectGetWidth(container.frame)-CGRectGetMaxY(self.originFrame)+CGRectGetHeight(self.originFrame)/2-(CGRectGetMinX(self.originFrame)+CGRectGetWidth(self.originFrame)/2), CGRectGetMinX(self.originFrame)+CGRectGetWidth(self.originFrame)/2-(CGRectGetMinY(self.originFrame)+CGRectGetHeight(self.originFrame)/2));
            pictureView.transform = CGAffineTransformRotate(pictureView.transform, M_PI_2);
        }
        else
        {
            pictureView.frame = self.originFrame;
            pictureView.transform = CGAffineTransformTranslate(pictureView.transform, -(CGRectGetMinX(self.originFrame)+CGRectGetWidth(self.originFrame)/2-(CGRectGetMinY(self.originFrame)+CGRectGetHeight(self.originFrame)/2)), CGRectGetHeight(container.frame)-CGRectGetMaxX(self.originFrame)+CGRectGetWidth(self.originFrame)/2-(CGRectGetMinY(self.originFrame)+CGRectGetHeight(self.originFrame)/2));
            pictureView.transform = CGAffineTransformRotate(pictureView.transform, -M_PI_2);
        }
        
        [UIView animateWithDuration:kAnimationTime animations:^{
            pictureView.transform = CGAffineTransformIdentity;
            pictureView.frame = container.frame;
            self.playerView.frame = container.frame;
        } completion:^(BOOL finished) {
            container.backgroundColor = [UIColor blackColor];
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
        }];
        
        XGWS(weakSelf);
        
        CGRect toFrame = [XGPlayerHandler fetchPlayerLayerFrameWithVideoGravity:weakSelf.videoGravity videoSize:weakSelf.playerView.playerFrame.size superSize:container.frame.size];
        
        [self.playerView.playerLayer animateWithType:XGAnimationTypeFullScreen duration:kAnimationTime fromFrame:self.playerView.playerFrame toFrame:toFrame superFrame:container.frame completion:^{
            weakSelf.playerView.playerLayer.frame = toFrame;
            [weakSelf.playerView.playerLayer removeAllAnimations];
        }];
    }
    else
    {
        /* 先朝左再朝右 -M_PI_2，先朝右再朝左 M_PI_2，竖屏切换横屏 CGAffineTransformIdentity */
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (self.isFullScreenMutualSwitch)
        {
            if (kXG_SystemVersion_RotateAbnormal)
            {
                pictureView.transform = CGAffineTransformRotate(pictureView.transform, M_PI);
            }
            /* 方向发生变化 */
            transform = CGAffineTransformRotate(pictureView.transform, M_PI_2);
            if (self.orientation == UIInterfaceOrientationLandscapeRight)
            {
                /* 先朝左再朝右 */
                transform = CGAffineTransformRotate(pictureView.transform, -M_PI_2);
            }
        }
        
        [UIView animateWithDuration:kAnimationTime animations:^{
            pictureView.transform = transform;
            pictureView.frame = self.originFrame;
            self.playerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.originFrame), CGRectGetHeight(self.originFrame));
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
            pictureView.transform = CGAffineTransformIdentity;
        }];
        
        XGWS(weakSelf);
        
        CGRect fromeFrame = [XGPlayerHandler fetchPlayerLayerFrameWithVideoGravity:weakSelf.videoGravity videoSize:weakSelf.playerView.playerFrame.size superSize:CGSizeMake(CGRectGetHeight(container.frame), CGRectGetWidth(container.frame))];
        
        [self.playerView.playerLayer animateWithType:XGAnimationTypeSmallScreen duration:kAnimationTime fromFrame:fromeFrame toFrame:self.playerView.playerFrame superFrame:self.originFrame completion:^{
            weakSelf.playerView.playerLayer.frame = weakSelf.playerView.playerFrame;
            [weakSelf.playerView.playerLayer removeAllAnimations];
        }];
    }
}

@end
