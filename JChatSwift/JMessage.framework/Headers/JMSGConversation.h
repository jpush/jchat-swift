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

@class JMSGMessage;
@class JMSGAbstractContent;
@class JMSGImageContent;


/*!
 * 会话
 *
 * 会话是整个 IM 的核心. 所有的消息行为都是基于"会话"的.
 *
 * 会话由会话类型, 会话对象组成. 比如: 与某username的单聊, 某个groupId的群聊.
 *
 * 几乎所有的消息行为, 都是由本类 JMSGConversation 提供的.
 * 而聊天对象的信息, 则通过 [target] 来直接访问到.
 *
 * JMSGMessage 上提供了部分消息相关 API, 是快捷方式的概念, 其背后还是依赖于会话的.
 * 提供这个快捷方式的目的在于: 某些聊天场景简单的应用, 可能不必去理解"会话"这个概念, 只是简单地收发消息即可.
 *
 * 本类主要提供两类 API: 会话类, 消息类.
 *
 *    设计提示: 考虑到会话列表性能问题, SDK 把一些会话信息冗余到了会话数据库表里, 从而只需要读取一张表.
 *    设计上准备, 在会话列表时, 不要访问会话对象的 target 对象. 只是进入一个会话(聊天界面)时, 才会访问 target 对象.
 *
 */
@interface JMSGConversation : NSObject

JMSG_ASSUME_NONNULL_BEGIN


///----------------------------------------------------
/// @name Conversation Operations 会话相关操作
///----------------------------------------------------

/*!
 * @abstract 获取单聊会话
 *
 * @param username 单聊对象 username
 *
 * @discussion 如果会话还不存在，则返回 nil
 */
+ (JMSGConversation * JMSG_NULLABLE)singleConversationWithUsername:(NSString *)username;

/*!
 * @abstract 获取群聊会话
 *
 * @param groupId 群聊群组ID。此 ID 由创建群组时返回的。
 *
 * @discussion 如果会话还不存在，则返回 nil
 */
+ (JMSGConversation * JMSG_NULLABLE)groupConversationWithGroupId:(NSString *)groupId;

/*!
 * @abstract 创建单聊会话
 *
 * @param username 单聊对象 username
 * @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。
 *
 * @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 * 创建会话时如果发现该 username 的信息本地还没有，则需要从服务器上拉取。
 * 服务器端如果找不到该 username，或者某种原因查找失败，则创建会话失败。
 */
+ (void)createSingleConversationWithUsername:(NSString *)username
                           completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 创建群聊会话
 *
 * @param groupId 群聊群组ID。由创建群组时返回。
 * @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。
 *
 * @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 * 创建会话时如果发现该 groupId 的信息本地还没有，则需要从服务器端上拉取。
 * 如果从服务器上获取 groupId 的信息不存在或者失败，则创建会话失败。
 */
+ (void)createGroupConversationWithGroupId:(NSString *)groupId
                         completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 删除单聊会话
 *
 * @param username 单聊用户名
 *
 * @discussion 除了删除会话本身，还会删除该会话下所有的聊天消息。
 */
+ (BOOL)deleteSingleConversationWithUsername:(NSString *)username;

/*!
 * @abstract 删除群聊会话
 *
 * @param groupId 群聊群组ID
 *
 * @discussion 除了删除会话本身，还会删除该会话下所有的聊天消息。
 */
+ (BOOL)deleteGroupConversationWithGroupId:(NSString *)groupId;

/*!
 * @abstract 返回 conversation 列表（异步）
 *
 * @param handler 结果回调。正常返回时 resultObject 的类型为 NSArray，数组里成员的类型为 JMSGConversation
 *
 * @discussion 当前是返回所有的 conversation 列表。
 * 我们设计上充分考虑到性能问题，数据库无关联表查询，性能应该不会差。
 * 但考虑到潜在的性能问题可能，此接口还是异步返回
 */
+ (void)allConversations:(JMSGCompletionHandler)handler;



///----------------------------------------------------------
/// @name Conversation Basic Properties 会话基本属性：用于会话列表
///----------------------------------------------------------

/*!
 * @abstract 会话标题
 * @discussion 会话头像没有属性字段, 应通过 avatarData: 方法异步去获取。
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE title;

/*!
 * @abstract 最后一条消息
 */
@property(nonatomic, strong, readonly) JMSGMessage * JMSG_NULLABLE latestMessage;

/*!
 * @abstract 未读数
 * @discussion 有新消息来时, SDK 会对未读数自动加 1
 */
@property(nonatomic, strong, readonly) NSNumber * JMSG_NULLABLE unreadCount;


///--------------------------------------------------------
/// @name Conversation Extend Properties 会话扩展属性：用于聊天
///--------------------------------------------------------

/*!
 * @abstract 会话类型 - 单聊，群聊
 * @discussion 详细定义见 JMSGConversationType
 */
@property(nonatomic, assign, readonly) JMSGConversationType conversationType;

/*!
 * @abstract 聊天对象
 *
 * @discussion 需要根据会话类型转型。单聊时转型为 JMSGUser，群聊时转型为 JMSGGroup
 *
 *    注意: 在会话列表上, 请不要使用此属性, 否则有性能问题. 只在进入聊天界面(单个会话) 时使用此属性.
 *
 * 进入会话(聊天界面)后, 访问会话对象的各种信息, 包括群聊的群组成员, 都应使用此属性,
 * 而没有必要再通过接口查询 UserInfo / GroupInfo.
 */
@property(nonatomic, strong, readonly) id target;



///----------------------------------------------------
/// @name Message Operations 消息相关操作
///----------------------------------------------------

/*!
 * @abstract 获取某条消息
 *
 * @param msgId 本地消息ID
 *
 * @discussion 这个接口在正常场景下不需要单独使用到. 获取消息一般应使用 [JSMGConversation messageArrayFromNewestWithOffset::]
 *
 * 注意: 这里的 msgId 概念同 [JMSGMessage msgId], 是本地生成的消息ID, 而非 [JMSGMessage serverMessageId]
 */
- (JMSGMessage * JMSG_NULLABLE)messageWithMessageId:(NSString *)msgId;

/*!
 * @abstract 同步分页获取最新的消息
 *
 * @param offset 开始的位置。nil 表示从最初开始。
 * @param limit 获取的数量。nil 表示不限。
 *
 * @return 返回消息列表（数组）。数组成员的类型是 JMSGMessage*
 *
 * @discussion 排序规则是：最新
 *
 * 参数举例：
 *
 * - offset = nil, limit = nil，表示获取全部。相当于 allMessages。
 * - offset = nil, limit = 100，表示从最新开始取 100 条记录。
 * - offset = 100, limit = nil，表示从最新第 100 条开始，获取余下所有记录。
 */
- (NSArray JMSG_GENERIC(__kindof JMSGMessage *) *)messageArrayFromNewestWithOffset:(NSNumber *JMSG_NULLABLE)offset
                                                                             limit:(NSNumber *JMSG_NULLABLE)limit;

/*!
 * @abstract 异步获取所有消息记录
 *
 * @param handler 结果回调。正常返回时 resultObject 类型为 NSArray，数据成员类型为 JMSGMessage。
 *
 * @discussion 排序规则：最新
 */
- (void)allMessages:(JMSGCompletionHandler)handler;

/*!
 * @abstract 删除一条消息
 *
 * @param msgId 本地消息ID
 */
- (BOOL)deleteMessageWithMessageId:(NSString *)msgId;

/*!
 * @abstract 删除全部消息
 *
 * @discussion 清空当前会话的所有消息。
 */
- (BOOL)deleteAllMessages;

/*!
 * @abstract 创建消息对象
 *
 * @param content 消息的内容对象。当前直接的内容对象有:
 * JMSGTextContent, JMSGImageContent, JMSGVoiceContent, JMSGCustomContent
 *
 * @return JMSGMessage对象。该对象里包含了 content。
 *
 * @discussion 这是推荐的创建新的消息拿到 JMSGMessage 对象接口。
 *
 * 此接口创建消息后, SDK 会进行落地, 包括: 消息保存数据库, 媒体文件保存到文件系统.
 * 这意味着, 这个创建后的消息对象, App 可以用来放到 UI 上展示.
 *
 * 新创建的消息对象, 其消息状态 status 为: kJMSGMessageStatusSendDraft
 *
 * 调用此接口前需要先创建消息内容，以作为 content 参数传入。举例：
 *
 *    ```
 *    NSData *imageData = … // 可能来自拍照或者相册
 *    JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:imageData];
 *    ```
 *
 * 另外更快捷的作法是，不通过此接口创建 JMSGMessage 而是直接调用具体的发送接口，如 sendSingleTextMessage.
 *
 * 通过此接口先创建 JMSGMessage 的好处是，可以对 JMSGMessage 做更多的定制控制，比如加附加字段。举例：
 *
 *    ```
 *    [imageContent addExtraValue:@"extra_value" forKey:@"extra_key"]
 *    ```
 *
 * 注意：如果创建消息的内容是图片，并且图片可能比较大，则建议不要使用这个同步接口，
 * 改用 createMessageAsyncWithImageContent:completionHandler: 方法。
 */
- (JMSGMessage * JMSG_NULLABLE)createMessageWithContent:(JMSGAbstractContent *)content;

/*!
 * @abstract 创建消息对象（图片，异步）
 *
 * @param content 准备好的图片内容
 * @param handler 结果回调. 正常返回时 resultObject 类型为 JMSGMessage.
 *
 * @discussion 对于图片消息，因为 SDK 要做缩图有一定的性能损耗，图片文件很大时存储落地也会较慢。
 * 所以创建图片消息，建议使用这个异步接口。
 */
- (void)createMessageAsyncWithImageContent:(JMSGImageContent *)content
                         completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 发送消息（已经创建好对象的）
 *
 * @param message 通过消息创建类接口，创建好的消息对象
 *
 * @discussion 发送消息的多个接口，都未在方法上直接提供回调。你应通过 xxx 方法来注册消息发送结果。
 */
- (void)sendMessage:(JMSGMessage *)message;

/*!
 * @abstract 发送文本消息
 * @param text 文本消息内容
 * @discussion 快捷发消息接口。如果发送文本消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendTextMessage:(NSString *)text;

/*!
 * @abstract 发送图片消息
 * @param imageData 图片消息数据
 * @discussion 快捷发送消息接口。如果发送图片消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendImageMessage:(NSData *)imageData;

/*!
 * @abstract 发送语音消息
 * @param voiceData 语音消息数据
 * @param duration 语音消息时长（秒）. 长度必须大于 0.
 * @discussion 快捷发送消息接口。如果发送语音消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendVoiceMessage:(NSData *)voiceData
                duration:(NSNumber *)duration;

/*!
 * @abstract 异步获取会话头像
 *
 * @param handler 结果回调。回调参数:
 *
 * - data 头像数据;
 * - objectId 为 targetId_conversationType 的组合, 用下划线隔开.
 *    其中 targetId 单聊时为 username, 群聊时为 groupId
 * - error 不为nil表示出错;
 *
 * 如果 error 为 ni, data 也为 nil, 表示没有数据.
 *
 * @discussion 会话的头像来自于聊天对象, 单聊就是用户的头像, 群聊是群组头像.
 * 建议在会话列表时, 使用此接口来显示会话的头像, 而不要使用 target 属性里的用户头像.
 */
- (void)avatarData:(JMSGAsyncDataHandler)handler;


///----------------------------------------------------
/// @name Conversation State Maintenance 会话状态维护
///----------------------------------------------------

/*!
 * @abstract 清除会话未读数
 *
 * @discussion 把未读数设置为 0
 */
- (void)clearUnreadCount;

/*!
 * @abstract 获取最后一条消息的内容文本
 *
 * @discussion 通常用来展示在会话列表的第 2 行. 如果是图片消息,通常是文本 [图片] 之类. CustomContent 可以定制这个文本.
 */
- (NSString *)latestMessageContentText;

/*!
 * @abstract 判断消息是否属于这个 Conversation
 *
 * @param message 待判断的消息对象
 *
 * @discussion 当前在聊天界面时，接收到消息通知，需要通过这个接口判断该消息是否属于当前这个会话，从而做不同的动作
 *
 * 如果注册消息接收事件时，只注册接收当前会话的消息，则不需要用此接口判断.
 */
- (BOOL)isMessageForThisConversation:(JMSGMessage *)message;

/*!
 * @abstract 从服务器端刷新会话信息
 *
 * @param handler 结果回调。返回正常时 resultObject 为当前 conversation 对象.
 *
 * @discussion 会话信息的 title/avatar 信息, 单聊来自于 UserInfo，对于群聊来自于 GroupInfo。
 * 建议在进入聊天界面时，调用此接口，来更新会话属性。
 * 典型的情况是, 此接口返回时, 刷新单聊界面顶部的会话标题. (有可能聊天对方昵称改变了, 或者群组名称改变了, 聊天标题需要刷新)
 *
 * 此接口供暂时使用。JMessage 整体的 Sync 机制生效后，将不需要客户端主动去刷新信息。
 */
- (void)refreshTargetInfoFromServer:(JMSGCompletionHandler)handler;


///----------------------------------------------------
/// @name Class Normal 类基本方法
///----------------------------------------------------

- (BOOL)isEqualToConversation:(JMSGConversation * JMSG_NULLABLE)conversation;


JMSG_ASSUME_NONNULL_END
@end
