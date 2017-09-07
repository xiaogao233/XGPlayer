//
//  XGPlayerHandler.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/14.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XGPlayerHeader.h"
#import <AVFoundation/AVFoundation.h>

@interface XGPlayerHandler : NSObject

/**
 获取AVplayer的frame

 @param videoGravity 视频填充模式
 @param videoSize 视频大小
 @param superSize 父视图size
 @return CGRect
 */
+ (CGRect)fetchPlayerLayerFrameWithVideoGravity:(XGVideoGravity)videoGravity videoSize:(CGSize)videoSize superSize:(CGSize)superSize;

/**
 获取视频真是尺寸
 
 @param track AVAssetTrack
 @return CGSize
 */
+ (CGSize)fetchAccuracyVideoSize:(AVAssetTrack *)track;

@end
