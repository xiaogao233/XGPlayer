//
//  XGPlayerHandler.m
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/14.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGPlayerHandler.h"

@implementation XGPlayerHandler

/**
 获取AVplayer的frame
 
 @param videoGravity 视频填充模式
 @param videoSize 视频大小
 @param superSize 父视图size
 @return CGRect
 */
+ (CGRect)fetchPlayerLayerFrameWithVideoGravity:(XGVideoGravity)videoGravity videoSize:(CGSize)videoSize superSize:(CGSize)superSize
{
    if (videoGravity == XGVideoGravityResize) return CGRectMake(0, 0, superSize.width, superSize.height);
    if (videoSize.height/videoSize.width>superSize.height/superSize.width)
    {
        /* 高先占满 */
        if (videoGravity == XGVideoGravityResizeAspect)
        {
            /* 已高为主 */
            /* 计算宽度 */
            CGFloat width = videoSize.width*superSize.height/videoSize.height;
            return CGRectMake((superSize.width-width)/2, 0, width, superSize.height);
        }
        else
        {
            /* 已宽为主 */
            /* 计算高度 */
            CGFloat height = superSize.width*videoSize.height/videoSize.width;
            return CGRectMake(0, (superSize.height-height)/2, superSize.width, height);
        }
    }
    else
    {
        /* 宽先占满 */
        if (videoGravity == XGVideoGravityResizeAspect)
        {
            /* 已宽为主 */
            CGFloat height = superSize.width*videoSize.height/videoSize.width;
            return CGRectMake(0, (superSize.height-height)/2, superSize.width, height);
        }
        else
        {
            /* 已高为主 */
            /* 计算宽度 */
            CGFloat width = videoSize.width*superSize.height/videoSize.height;
            return CGRectMake((superSize.width-width)/2, 0, width, superSize.height);
        }
    }
}

/**
 获取视频真是尺寸

 @param track AVAssetTrack
 @return CGSize
 */
+ (CGSize)fetchAccuracyVideoSize:(AVAssetTrack *)track
{
    CGSize videoSize = track.naturalSize;
    NSUInteger degress = [self fetchVideoRotationAngle:track];
    if (degress == 90 || degress == 270)
    {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    return videoSize;
}

/**
 获取视频旋转角度

 @param track AVAssetTrack
 @return 旋转角度
 */
+ (CGFloat)fetchVideoRotationAngle:(AVAssetTrack *)track
{
    NSUInteger degress = 0;
    
    CGAffineTransform t = track.preferredTransform;
    
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
    {
        /* Portrait */
        degress = 90;
    }
    else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)
    {
        /* PortraitUpsideDown */
        degress = 270;
    }
    else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
    {
        /* LandscapeRight */
        degress = 0;
    }
    else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
    {
        /* LandscapeLeft */
        degress = 180;
    }
    
    return degress;
}

@end
