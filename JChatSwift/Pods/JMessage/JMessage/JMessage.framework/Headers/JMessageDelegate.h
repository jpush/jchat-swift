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
#import <JMessage/JMSGMessageDelegate.h>
#import <JMessage/JMSGConversationDelegate.h>
#import <JMessage/JMSGGroupDelegate.h>
#import <JMessage/JMSGUserDelegate.h>
#import <JMessage/JMSGDBMigrateDelegate.h>

/*!
 * 全局代理协议
 *
 * 一般情况下, App 只需要注册这个全局代理, 则 3 个类别里的代理都注册到.
 * 由于回调方法都是可选, 你可以根据需要实现一个或者多个回调, 在你实现的方法里, 有事件时就会回调.
 *
 * 以下代码, 假设当前类是 ChatViewController, 要完成这样的功能:
 * 接收当前聊天所在的会话的 - 发出的消息的返回, 以及服务器端下发的消息.
 *
 *    ```
 *    // 通过你的方式取到了 Conversation 实例
 *    JMSGConversation *theConversation = ...;
 *
 *    // 在类的初始化代码里, 注册代理, 指定 Conversation.
 *    [JMessage addDelegate:self withConversation:theConversation];
 *
 *    // 实现 JMSGMessageDelegate 里的发送消息返回的回调方法
 *    - (void)onSendMessageResponse:(JMSGMessage *)message
 *                            error:(NSError *)error {
 *                            // 这里处理发送消息返回
 *                            // message 对象是你原本发出的消息对象
 *    }
 *
 *    // 实现 JMSGMessageDelegate 里的接收消息回调方法
 *    - (void)onReceiveMessage:(JMSGMessage *)message
 *                       error:(NSError *)error {
 *                       // 这里处理收到的消息
 *    }
 *    ```
 *
 * 有一类特殊的系统事件, 需要特别提示: 如果当前用户在其他设备上登录, 本设备会收到一个下发通知.
 * 思路上, 需要先从 onReceiveMessage 上收到事件类型的消息, 判断 JMSGEventContent 里的
 * eventType = kJMSGEventNotificationLoginKicked 表示这是一个用户被踢出登录的事件.
 *
 * 以下示例代码在上述 onReceiveMessage 监听里:
 *
 *    ```
 *    if (message.contentType == kJMSGContentTypeEventNotification) {
 *      JMSGEventContent *eventContent = (JMSGEventContent) message.content;
 *      if (eventContent.eventType == kJMSGEventNotificationLoginKicked) {
 *        // 这里做用户被踢处理. 一般的作法应该是: 弹出提示信息,告诉用户在其他设备登录了;
 *        // 弹窗关闭后界面切换到用户登录界面
 *      }
 *    }
 *    ```
 */
@protocol JMessageDelegate <JMSGMessageDelegate,
                            JMSGConversationDelegate,
                            JMSGGroupDelegate,
                            JMSGUserDelegate,
                            JMSGDBMigrateDelegate>

@end
