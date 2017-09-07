//
//  CALayer+XGRotateAnimation.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/8.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "CALayer+XGRotateAnimation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "XGPlayerHeader.h"

/* 属性标识 */
static char kCompletion;

@implementation CALayer (XGRotateAnimation)

- (void)animateWithType:(XGAnimationType)type duration:(CGFloat)duration fromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame superFrame:(CGRect)superFrame completion:(animationCompleted)completion
{
    self.completion = completion;
    
    if (type == XGAnimationTypeFullScreen)
    {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        animation1.toValue = [NSNumber numberWithFloat:CGRectGetWidth(toFrame)/CGRectGetWidth(fromFrame)];
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        animation2.toValue = [NSNumber numberWithFloat:CGRectGetHeight(toFrame)/CGRectGetHeight(fromFrame)];
        CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"position"];
        animation3.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(superFrame)/2, CGRectGetHeight(superFrame)/2)];
        
        CAAnimationGroup *anis = [CAAnimationGroup animation];
        anis.animations = @[animation1,animation2,animation3];
        anis.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anis.duration = duration;
        anis.removedOnCompletion = NO;
        anis.fillMode = kCAFillModeForwards;
        anis.delegate = self;
        [self addAnimation:anis forKey:nil];
    }
    else
    {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        animation1.toValue = [NSNumber numberWithFloat:CGRectGetWidth(toFrame)/CGRectGetWidth(fromFrame)];
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        animation2.toValue = [NSNumber numberWithFloat:CGRectGetHeight(toFrame)/CGRectGetHeight(fromFrame)];
        CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"position"];
        animation3.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(superFrame)/2, CGRectGetHeight(superFrame)/2)];
        
        CAAnimationGroup *anis = [CAAnimationGroup animation];
        anis.animations = @[animation1,animation2,animation3];
        anis.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anis.duration = duration;
        anis.removedOnCompletion = NO;
        anis.fillMode = kCAFillModeForwards;
        anis.delegate = self;
        [self addAnimation:anis forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && self.completion)
    {
        self.completion();
    }
}

- (void)setCompletion:(animationCompleted)completion
{
    objc_setAssociatedObject(self, &kCompletion, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (animationCompleted)completion
{
    return objc_getAssociatedObject(self, &kCompletion);
}

@end
