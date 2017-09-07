//
//  XGPlayerView.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/13.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayerView.h"
#import "XGPlayerControlView.h"
#import "XGPlayerHandler.h"

@interface XGPlayerView ()

/* 视频播放相关 */
@property(nonatomic, strong)AVPlayer *avPlayer;
@property(nonatomic, strong)AVPlayerItem *avItem;
@property(nonatomic, strong)AVURLAsset *videoAsset;
/* 初始frame */
@property(nonatomic, assign)CGRect initialFrame;
/* 初始avplayer的frame */
@property(nonatomic, assign)CGRect initialPlayerFrame;
/* 控制视图 */
@property(nonatomic, strong)XGPlayerControlView *controllView;

@end

@implementation XGPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _initialFrame = frame;
        [self initLayout];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.controllView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)initLayout
{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    
    self.videoAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"http://221.228.226.18/9/u/i/v/m/uivmcmiiwgddknrpltuvfepmvgijlz/he.yinyuetai.com/88CE01595A940BC83C7AB2C616308D62.mp4?sc%5Cu003d4999706d372aec6b%5Cu0026br%5Cu003d3099%5Cu0026vid%5Cu003d2763591%5Cu0026aid%5Cu003d25339%5Cu0026area%5Cu003dKR%5Cu0026vst%5Cu003d0"]];
    /* 初始化playerItem */
    self.avItem = [AVPlayerItem playerItemWithAsset:self.videoAsset];
    /* 创建player */
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avItem];
    /* 初始化playerLayer */
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    /* 设置比例 */
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self addSubview:self.controllView];
    
    [self fetchVideoSizeInfo];
    [self.avPlayer play];
}

- (void)fetchVideoSizeInfo
{
    XGWS(weakSelf);
    /* 获取视频尺寸 */
    [self.videoAsset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = weakSelf.videoAsset.tracks;
            for (AVAssetTrack *track in array) {
                if ([track.mediaType isEqualToString:AVMediaTypeVideo])
                {
                    /* 设置playerlayer的frame */
                    weakSelf.initialPlayerFrame = [XGPlayerHandler fetchPlayerLayerFrameWithVideoGravity:weakSelf.videoGravity videoSize:[XGPlayerHandler fetchAccuracyVideoSize:track] superSize:weakSelf.frame.size];
                    weakSelf.playerLayer.frame = weakSelf.playerFrame;
                    /* 添加到layer */
                    [weakSelf.layer insertSublayer:weakSelf.playerLayer atIndex:0];
                    [weakSelf.avPlayer play];
                }
            }
        });
    }];
}

/**
 没有动画的退出全屏，需要重新设置frame
 */
- (void)exitFullScreenWithOutAnimation
{
    self.frame = self.initialFrame;
    [self.playerLayer removeAllAnimations];
    self.playerLayer.frame = self.playerFrame;
}

#pragma mark - lazy
- (XGPlayerControlView *)controllView
{
    if (!_controllView) {
        _controllView = [[XGPlayerControlView alloc] init];
    }
    return _controllView;
}

- (CGRect)playerFrame
{
    return self.initialPlayerFrame;
}

@end
