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
#import <JMessage/JMSGConstants.h>
#import <JMessage/JPUSHService.h>
#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGGroup.h>
#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGConversation.h>
#import <JMessage/JMSGAbstractContent.h>
#import <JMessage/JMSGMediaAbstractContent.h>
#import <JMessage/JMSGCustomContent.h>
#import <JMessage/JMSGEventContent.h>
#import <JMessage/JMSGImageContent.h>
#import <JMessage/JMSGTextContent.h>
#import <JMessage/JMSGVoiceContent.h>
#import <JMessage/JMessageDelegate.h>

@protocol JMSGMessageDelegate;
@protocol JMessageDelegate;
@class JMSGConversation;


/*!
 * JMessage核心头文件
 *
 * 这是唯一需要导入到你的项目里的头文件，它引用了内部需要用到的头文件。
 */
@interface JMessage : NSObject

/*! JMessage SDK 版本号。用于展示 SDK 的版本信息 */
#define JMESSAGE_VERSION @"2.0.0"

/*! JMessage SDK 构建ID. 每次构建都会增加 */
#define JMESSAGE_BUILD 1064

/*! API Version - int for program logic. SDK API 有变更时会增加 */
extern NSInteger const JMESSAGE_API_VERSION;


/*!
 * @abstract 初始化 JMessage SDK
 *
 * @param launchOptions    AppDelegate启动函数的参数launchingOption(用于推送服务)
 * @param appKey           appKey(应用Key值,通过JPush官网可以获取)
 * @param channel          应用的渠道名称
 * @param isProduction     是否为生产模式
 * @param category         iOS8新增通知快捷按钮参数
 *
 * @discussion 此方法必须被调用, 以初始化 JMessage SDK
 *
 * 如果未调用此方法, 本 SDK 的所有功能将不可用.
 */
+ (void)setupJMessage:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
              channel:(NSString *)channel
     apsForProduction:(BOOL)isProduction
             category:(NSSet *)category;

/*!
 * @abstract 增加回调(delegate protocol)监听
 *
 * @param delegate 需要监听的 Delegate Protocol
 * @param conversation 允许为nil.
 *
 * - 为 nil, 表示接收所有的通知, 不区分会话.
 * - 不为 nil，表示只接收指定的 conversation 相关的通知.
 *
 * @discussion 默认监听全局 JMessageDelegate 即可.
 *
 * 这个调用可以在任何地方, 任何时候调用, 可以在未进行 SDK
 * 启动 setupJMessage:appKey:channel:apsForProduction:category: 时就被调用.
 *
 * 并且, 如果你有必要接收数据库升级通知 [JMSGDBMigrateDelegate](建议要做这一步),
 * 就应该在 SDK 启动前就调用此方法, 来注册通知接收.
 * 这样, SDK启动过程中发现需要进行数据库升级, 给 App 发送数据库升级通知时,
 * App 才可以收到并进行处理.
 */
+ (void)addDelegate:(id <JMessageDelegate>)delegate
   withConversation:(JMSGConversation *)conversation;

/*!
 * @abstract 删除Delegate监听
 *
 * @param delegate 监听的 Delegate Protocol
 * @param conversation 基于某个会话的监听. 允许为 nil.
 *
 * - 为 nil, 表示全局的监听, 即所有会话相关.
 * - 不为 nil, 表示特定的会话.
 */
+ (void)removeDelegate:(id <JMessageDelegate>)delegate
      withConversation:(JMSGConversation *)conversation;

/*!
 * @abstract 删除全部监听
 */
+ (void)removeAllDelegates;

/*!
 * @abstract 打开日志级别到 Debug
 *
 * @discussion JMessage iOS 的日志系统参考 Android 设计了级别.
 * 从低到高是: Verbose, Debug, Info, Warning, Error.
 * 对日志级别的进一步理解, 请参考 Android 相关的说明.
 *
 * SDK 默认开启的日志级别为: Info. 只显示必要的信息, 不打印调试日志.
 *
 * 调用本接口可打开日志级别为: Debug, 打印调试日志.
 *
 * 本接口与 [JPUSHService setDebugMode] 效果是相同的, 只需要调用一个即可.
 */
+ (void)setDebugMode;

/*!
 * @abstract 关闭日志
 *
 * @discussion 关于日志级别的说明, 参考 [JMessage setDebugMode]
 *
 * 虽说是关闭日志, 但还是会打印 Warning, Error 日志. 这二种日志级别, 在程序运行正常时, 不应有打印输出.
 *
 * 建议在发布的版本里, 调用此接口, 关闭掉日志打印.
 *
 * 本接口与 [JPUSHService setLogOff] 效果是相同的, 只需要调用一个即可.
 */
+ (void)setLogOFF;

/*!
 * @abstract 获取当前服务器端时间
 *
 * @discussion 可用于纠正本地时间。
 */
+ (NSTimeInterval)currentServerTime;

/*!
 * @abstract 发起数据库升级测试
 *
 * @discussion 这是一个专用于测试时使用到的接口.
 *
 * 关于数据库升级相关, 参考这个 [JMSGDBMigrateDelegate] 类里的说明.
 *
 * 调用此接口后, App 会收到一个升级开始通知, 30s 后再收到一个升级结束通知.
 *
 * 本接口内部并不会真实地发起数据库升级操作, 而仅用于发出开始与完成的通知, 以方便 App 来测试处理流程. 
 */
+ (void)testDBMigrating;

@end

