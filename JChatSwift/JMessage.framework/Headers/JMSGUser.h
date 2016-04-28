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

/*!
 * @abstract 更新用户字段
 */
typedef NS_ENUM(NSUInteger, JMSGUserField) {
  /// 用户信息字段: 用户名
  kJMSGUserFieldsNickname = 0,
  /// 用户信息字段: 生日
  kJMSGUserFieldsBirthday = 1,
  /// 用户信息字段: 签名
  kJMSGUserFieldsSignature = 2,
  /// 用户信息字段: 性别
  kJMSGUserFieldsGender = 3,
  /// 用户信息字段: 区域
  kJMSGUserFieldsRegion = 4,
  /// 用户信息字段: 头像 (内部定义的 media_id)
  kJMSGUserFieldsAvatar = 5,
};

/*!
 * @abstract 用户性别
 */
typedef NS_ENUM(NSUInteger, JMSGUserGender) {
  /// 用户性别类型: 未知
  kJMSGUserGenderUnknown = 0,
  /// 用户性别类型: 男
  kJMSGUserGenderMale,
  /// 用户性别类型: 女
  kJMSGUserGenderFemale,
};


/*!
 * 用户
 */
@interface JMSGUser : NSObject <NSCopying>

JMSG_ASSUME_NONNULL_BEGIN


///----------------------------------------------------
/// @name Class Methods 类方法
///----------------------------------------------------

/*!
 * @abstract 新用户注册
 *
 * @param username 用户名. 长度 4~128 位.
 *                 支持的字符: 字母,数字,下划线,英文减号,英文点,@邮件符号. 首字母只允许是字母或者数字.
 * @param password 用户密码. 长度 4~128 位.
 * @param handler 结果回调. 返回正常时 resultObject 为 nil.
 */
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
           completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 用户登录
 *
 * @param username 登录用户名. 规则与注册接口相同.
 * @param password 登录密码. 规则与注册接口相同.
 * @param handler 结果回调. 正常返回时 resultOjbect 为 nil.
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 当前用户退出登录
 *
 * @param handler 结果回调。正常返回时 resultObject 也是 nil。
 *
 * @discussion 这个接口一般总是返回成功，即使背后与服务器端通讯失败，SDK 也总是会退出登录的。
 * 建议 App 也不必确认 SDK 返回, 就实际退出登录状态.
 */
+ (void)logout:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 批量获取用户信息
 *
 * @param usernameArray 用户名列表。NSArray 里的数据类型为 NSString
 * @param handler 结果回调。正常返回时 resultObject 的类型为 NSArray，数组里的数据类型为 JMSGUser
 *
 * @discussion 这是一个批量接口。
 */
+ (void)userInfoArrayWithUsernameArray:(NSArray JMSG_GENERIC(__kindof NSString *)*)usernameArray
                     completionHandler:(JMSGCompletionHandler)handler;


/*!
 * @abstract 获取用户本身个人信息接口
 *
 * @return 当前登陆账号个人信息
 */
+ (JMSGUser *)myInfo;

/*!
 * @abstract 更新用户信息接口
 *
 * @param parameter     新的属性值
 *        Birthday&&Gender 是NSNumber类型, Avatar NSData类型 其他 NSString
 * @param type          更新属性类型
 * @param handler       用户注册回调接口函数
 */
+ (void)updateMyInfoWithParameter:(id)parameter
                    userFieldType:(JMSGUserField)type
                completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 更新密码接口
 *
 * @param newPassword   用户新的密码
 * @param oldPassword   用户旧的密码
 * @param handler       用户注册回调接口函数
 */
+ (void)updateMyPasswordWithNewPassword:(NSString *)newPassword
                            oldPassword:(NSString *)oldPassword
                      completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;


///----------------------------------------------------
/// @name Basic Fields 基本属性
///----------------------------------------------------

/*!
 * @abstract 用户名
 *
 * @discussion 这是用户帐号，注册后不可变更。App 级别唯一。这是所有用户相关 API 的用户标识。
 */
@property(nonatomic, copy, readonly) NSString *username;

/*!
 * @abstract 用户昵称
 *
 * @discussion 用户自定义的昵称，可任意定义。
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE nickname;

/*!
 * @abstract 用户头像（媒体文件ID）
 *
 * @discussion 此文件ID仅用于内部更新，不支持外部URL。
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE avatar;

/*!
 * @abstract 性别
 *
 * @discussion 这是一个 enum 类型，支持 3 个选项：未知，男，女
 */
@property(nonatomic, assign, readonly) JMSGUserGender gender;

/*!
 * @abstract 生日
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE birthday;

@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE region;

@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE signature;


/*!
 * @abstract 获取头像缩略图文件数据
 *
 * @param handler 结果回调。回调参数:
 *
 * - data 头像数据;
 * - objectId 用户username;
 * - error 不为nil表示出错;
 *
 * 如果 error 为 ni, data 也为 nil, 表示没有头像数据.
 *
 * @discussion 需要展示缩略图时使用。
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
- (void)thumbAvatarData:(JMSGAsyncDataHandler)handler;

/*!
 * @abstract 获取头像大图文件数据
 *
 * @param handler 结果回调。回调参数:
 *
 * - data 头像数据;
 * - objectId 用户username;
 * - error 不为nil表示出错;
 *
 * 如果 error 为 ni, data 也为 nil, 表示没有头像数据.
 *
 * @discussion 需要展示大图图时使用
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
- (void)largeAvatarData:(JMSGAsyncDataHandler)handler;

/*!
 * @abstract 用户展示名
 *
 * @discussion 如果 nickname 存在则返回 nickname，否则返回 username
 */
- (NSString *)displayName;

- (BOOL)isEqualToUser:(JMSGUser * JMSG_NULLABLE)user;

JMSG_ASSUME_NONNULL_END

@end
