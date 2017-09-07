//
//  XGPlayerHeader.h
//  XGPlayer-master
//
//  Created by 高昇 on 2017/8/9.
//  Copyright © 2017年 高昇. All rights reserved.
//

#ifndef XGPlayerHeader_h
#define XGPlayerHeader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

static CGFloat const kAnimationTime = 0.35;

/**
 视频填充方式

 - XGVideoGravityResizeAspect: 按原比例拉伸视频，直到任一边占满，存在黑边
 - XGVideoGravityResizeAspectFill: 按原比例拉伸视频，直到两边屏幕都占满，会切割视频
 - XGVideoGravityResize: 拉伸视频内容，直到边框都占满，视频会被拉伸
 */
typedef NS_ENUM(NSInteger, XGVideoGravity) {
    XGVideoGravityResizeAspect,
    XGVideoGravityResizeAspectFill,
    XGVideoGravityResize
};

#define XGWS(weakSelf) __weak __typeof(&*self) weakSelf = self

/* 系统版本 */
#define kXG_SystemVersion [[UIDevice currentDevice].systemVersion floatValue]
/* iOS8-iOS8.3，屏幕旋转异常版本 */
#define kXG_SystemVersion_RotateAbnormal kXG_SystemVersion>=8&&kXG_SystemVersion<=8.3
/* iOS7 */
#define kIOS7 kXG_SystemVersion>6&&kXG_SystemVersion<8

#endif /* XGPlayerHeader_h */
