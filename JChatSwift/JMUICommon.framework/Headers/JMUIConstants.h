//
//  JMUIConstants.h
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#ifndef JMUIConstants_h
#define JMUIConstants_h

#import <Foundation/Foundation.h>
/*========================================屏幕适配============================================*/

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  (kIOSVersions>=7.0 ? [[UIScreen mainScreen] bounds].size.height + 64 : [[UIScreen mainScreen] bounds].size.height)
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)

#define kApplicationSize      [UIScreen mainScreen].bounds.size       //(e.g. 320,460)
#define kApplicationWidth     [UIScreen mainScreen].bounds.size.width //(e.g. 320)
#define kApplicationHeight    [UIScreen mainScreen].bounds.size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             170

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.7]


#endif /* JMUIConstants_h */
// color
#define kSeparationLineColor UIColorFromRGB(0xd0d0d0)


#define kuserName @"userName"

static NSInteger const st_toolBarTextSize = 17.0f;
static NSInteger const crossgrap = 10; //聊天泡泡尖椒的宽度

static NSString * const st_receiveUnknowMessageDes = @"收到新消息类型无法解析的数据，请升级查看";
static NSString * const st_receiveErrorMessageDes = @"接收消息错误";

// Notification
#define kDeleteMessage @"DeleteMessage"
