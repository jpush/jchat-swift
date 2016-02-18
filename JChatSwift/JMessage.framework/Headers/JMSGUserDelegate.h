/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class JMSGGroup;


/*!
 * User 相关变更通知
 */
@protocol JMSGUserDelegate <NSObject>

/*!
 * @abstract 当前登录用户被踢下线通知
 *
 * @discussion 一般可能是, 该用户在其他设备上登录, 把当前设备的登录踢出登录.
 *
 * SDK 收到服务器端下发事件后, 会内部退出登录.
 * App 也应该退出登录. 否则所有的 SDK API 调用将失败, 因为 SDK 已经退出登录了.
 */
@optional
- (void)onLoginUserKicked;

@end
