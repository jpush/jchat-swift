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

@class JMSGUser;


/*!
 * 群组
 *
 * 群组表示一组用户, 是群组聊天的聊天对象.
 *
 * 主要包含两类 API: 群组信息维护, 群组成员变更.
 */
@interface JMSGGroup : NSObject

JMSG_ASSUME_NONNULL_BEGIN


///----------------------------------------------------
/// @name Group Info Maintenance 群组信息维护
///----------------------------------------------------

/*!
 * @abstract 创建群组
 *
 * @param groupName 群组名称
 * @param groupDesc 群组描述信息
 * @param usernameArray 初始成员列表。NSArray 里的类型是 NSString
 * @param handler 结果回调。正常返回 resultObject 的类型是 JMSGGroup。
 *
 * @discussion 向服务器端提交创建群组请求，返回生成后的群组对象.
 * 返回群组对象, 群组ID是App 需要关注的, 是后续各种群组维护的基础.
 */
+ (void)createGroupWithName:(NSString * JMSG_NULLABLE )groupName
                       desc:(NSString *JMSG_NULLABLE)groupDesc
                memberArray:(NSArray JMSG_GENERIC(__kindof NSString *) *JMSG_NULLABLE)usernameArray
          completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 更新群组信息
 *
 * @param groupId 待更新的群组ID
 * @param groupName 新名称
 * @param groupDesc 新描述
 * @param handler 结果回调. 正常返回时, resultObject 为 nil.
 */
+ (void)updateGroupInfoWithGroupId:(NSString *)groupId
                              name:(NSString *)groupName
                              desc:(NSString *)groupDesc
                 completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 获取群组信息
 *
 * @param groupId 待获取详情的群组ID
 * @param handler 结果回调. 正常返回时 resultObject 类型是 JMSGGroup.
 *
 * @discussion 该接口总是向服务器端发起请求, 即使本地已经存在.
 * 如果考虑性能损耗, 在群聊时获取群组信息, 可以获取 JMSGConversation -> target 属性.
 */
+ (void)groupInfoWithGroupId:(NSString *)groupId
           completionHandler:(JMSGCompletionHandler)handler;

/*!
 * @abstract 获取我的群组列表
 *
 * @param handler 结果回调。正常返回时 resultObject 的类型是 NSArray，数组里的成员类型是 JMSGGroup
 *
 * @discussion 该接口总是向服务器端发起请求。
 */
+ (void)myGroupArray:(JMSGCompletionHandler)handler;


///----------------------------------------------------
/// @name Group basic fields 群组基本属性
///----------------------------------------------------


/*!
 * @abstract 群组ID
 *
 * @discussion 该ID由服务器端生成，全局唯一。可以用于服务器端 API。
 */
@property(nonatomic, strong, readonly) NSString *gid;

/*!
 * @abstract 群组名称
 *
 * @discussion 可用于群组聊天的展示名称
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE name;

/*!
 * @abstract 群组描述信息
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE desc;

/*!
 * @abstract 群组等级
 *
 * @discussion 不同等级的群组，人数上限不同。当前默认等级 4，人数上限 200。客户端不可更改。
 */
@property(nonatomic, strong, readonly) NSNumber *level;

/*!
 * @abstract 群组设置标志位
 *
 * @discussion 这是一个内部状态标志，对外展示仅用于调试目的。客户端不可更改。
 */
@property(nonatomic, strong, readonly) NSNumber *flag;

/*!
 * @abstract 群主（用户的 username）
 *
 * @discussion 有一套确认群主的策略。简单地说，群创建人是群主；如果群主退出，则是第二个加入的人，以此类似。客户端不可更改。
 */
@property(nonatomic, copy, readonly) NSString *owner;


///----------------------------------------------------
/// @name Group members maintenance 群组成员维护
///----------------------------------------------------


/*!
 * @abstract 获取群组成员列表
 *
 * @return 成员列表. NSArray 里成员类型是 JMSGUser.
 *
 * @discussion 一般在群组详情界面调用此接口，展示群组的所有成员列表。
 * 本接口只是在本地请求成员列表，不会发起服务器端请求。
 */
- (NSArray JMSG_GENERIC(__kindof JMSGUser *)*)memberArray;

/*!
 * @abstract 添加群组成员
 *
 * @param usernameArray 用户名数组。数组里的成员类型是 NSString
 * @param handler 结果回调。正常返回时 resultObject 为 nil.
 */
- (void)addMembersWithUsernameArray:(NSArray JMSG_GENERIC(__kindof NSString *) *)usernameArray
                  completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 删除群组成员
 *
 * @param usernameArray 用户名数据. 数组里的成员类型是 NSString
 * @param handler 结果回调。正常返回时 resultObject 为 nil.
 */
- (void)removeMembersWithUsernameArray:(NSArray JMSG_GENERIC(__kindof NSString *) *)usernameArray
                     completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 退出当前群组(当前用户)
 *
 * @param handler 结果回调。正常返回时 resultObject 为 nil。
 */
- (void)exit:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 获取群组的展示名
 *
 * @discussion 如果 group.name 为空, 则此接口会拼接群组前 5 个成员的展示名返回.
 */
- (NSString *)displayName;

- (BOOL)isMyselfGroupMember;

- (BOOL)isEqualToGroup:(JMSGGroup * JMSG_NULLABLE)group;

JMSG_ASSUME_NONNULL_END

@end


