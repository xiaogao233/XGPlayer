//
//  XGPlayerControlView.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/11.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayerControlView.h"

@interface XGPlayerControlView ()

/* <#注释#> */
@property(nonatomic, strong)UIView *view1;
@property(nonatomic, strong)UIView *view2;
@property(nonatomic, strong)UIView *view3;
@property(nonatomic, strong)UIView *view4;

@end

@implementation XGPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
    self.view1.frame = CGRectMake(20, 20, 40, 40);
    self.view2.frame = CGRectMake(CGRectGetWidth(self.frame)-60, 20, 40, 40);
    self.view3.frame = CGRectMake(20, CGRectGetHeight(self.frame)-60, 40, 40);
    self.view4.frame = CGRectMake(CGRectGetWidth(self.frame)-60, CGRectGetMinY(self.view3.frame), 40, 40);
}

- (void)initLayout
{
    [self addSubview:self.view1];
    [self addSubview:self.view2];
    [self addSubview:self.view3];
    [self addSubview:self.view4];
}

#pragma mark - lazy
- (UIView *)view1
{
    if (!_view1) {
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor redColor];
    }
    return _view1;
}

- (UIView *)view2
{
    if (!_view2) {
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor orangeColor];
    }
    return _view2;
}

- (UIView *)view3
{
    if (!_view3) {
        _view3 = [[UIView alloc] init];
        _view3.backgroundColor = [UIColor grayColor];
    }
    return _view3;
}

- (UIView *)view4
{
    if (!_view4) {
        _view4 = [[UIView alloc] init];
        _view4.backgroundColor = [UIColor grayColor];
    }
    return _view4;
}

@end
