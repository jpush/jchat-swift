//
//  NSString+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/25.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

extension NSString {  
  class func getTodayYesterdayString(theDate:NSDate) -> String {
    let formatter = NSDateFormatter()
    let locale:NSLocale = NSLocale(localeIdentifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter.stringFromDate(theDate)
  }
  
  class func getPastDateString(theDate:NSDate) -> String {
    let formatter = NSDateFormatter()
    let locale:NSLocale = NSLocale(localeIdentifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter.stringFromDate(theDate)
  }

  class func getFriendlyDateString(timeInterval:NSTimeInterval, forConversation isShort:Bool) -> String {
    let theDate:NSDate = NSDate(timeIntervalSince1970: timeInterval)
    var output = ""
    let theDiff = -theDate.timeIntervalSinceNow
    switch theDiff {
    case theDiff where theDiff < 60.0:
      output = "刚刚"
      break
    case theDiff where theDiff < 60 * 60:
      let minute:Int = Int(theDiff/60)
      output = "\(minute)分钟前"
      break
    default:
      let formatter:NSDateFormatter = NSDateFormatter()
      let locale:NSLocale = NSLocale(localeIdentifier: "zh")
      formatter.locale = locale
      var isTodayYesterday = false
      var isPastLong = false
      
      if theDate.isToday() {
        formatter.dateFormat = FORMAT_TODAY
      } else if theDate.isYesterday() {
        formatter.dateFormat = FORMAT_YESTERDAY
        isTodayYesterday = true
      } else if theDate.isThisWeek() {
        if isShort {
          formatter.dateFormat = FORMAT_THIS_WEEK_SHORT
        } else {
          formatter.dateFormat = FORMAT_THIS_WEEK
        }
      } else {
        if isShort {
          formatter.dateFormat = FORMAT_PAST_SHORT
        } else {
          formatter.dateFormat = FORMAT_PAST_TIME
          isPastLong = true
        }
      }
      
      if isTodayYesterday {
        let todayYesterday = NSString.getTodayYesterdayString(theDate)
        if isShort {
          output = todayYesterday
        } else {
          output = formatter.stringFromDate(theDate)
          output = "\(todayYesterday) \(output)"
        }
      } else {
        output = formatter.stringFromDate(theDate)
        if isPastLong {
          let thePastDate = NSString.getPastDateString(theDate)
          output = "\(thePastDate) \(output)"
        }
      }
      
      break
    }
    return output
  }
  
  class func conversationIdWithConversation(conversation:JMSGConversation) -> String {
    var conversationId = ""
    if conversation.conversationType == .Single {
      let user = conversation.target as! JMSGUser
      conversationId = "\(user.username)_0"
    } else {
      let group = conversation.target as! JMSGGroup
      conversationId = "\(group.gid)_1"
    }
    return conversationId
  }
}

extension NSString {
  class func errorAlert(error :NSError) -> String {
    var errorAlert:String = ""
    return errorAlert
    
    switch error.code as! JMSGSDKErrorCode {
    case .JMSGErrorSDKNetworkDownloadFailed:
      errorAlert = "下载失败"
      break
      
    case .JMSGErrorSDKNetworkUploadFailed:
      errorAlert = "上传资源文件失败"
      break
    case .JMSGErrorSDKNetworkUploadTokenVerifyFailed:
      errorAlert = "上传资源文件Token验证失败"
      break
    case .JMSGErrorSDKNetworkUploadTokenGetFailed:
      errorAlert = "获取服务器Token失败"
      break
    case .JMSGErrorSDKDBDeleteFailed:
      errorAlert = "数据库删除失败"
      break
    case .JMSGErrorSDKDBUpdateFailed:
      errorAlert = "数据库更新失败"
      break
    case .JMSGErrorSDKDBSelectFailed:
      errorAlert = "数据库查询失败"
      break
    case .JMSGErrorSDKDBInsertFailed:
      errorAlert = "数据库插入失败"
      break
    case .JMSGErrorSDKParamAppkeyInvalid:
      errorAlert = "appkey不合法"
      break
    case .JMSGErrorSDKParamUsernameInvalid:
      errorAlert = "用户名不合法"
      break
    case .JMSGErrorSDKParamPasswordInvalid:
      errorAlert = "用户密码不合法"
      break
    case .JMSGErrorSDKUserNotLogin:
      errorAlert = "用户没有登录"
      break
    case .JMSGErrorSDKNotMediaMessage:
      errorAlert = "这不是一条媒体消息"
      break
    case .JMSGErrorSDKMediaResourceMissing:
      errorAlert = "下载媒体资源路径或者数据意外丢失"
      break
    case .JMSGErrorSDKMediaCrcCodeIllegal:
      errorAlert = "媒体CRC码无效"
      break
    case .JMSGErrorSDKMediaCrcVerifyFailed:
      errorAlert = "媒体CRC校验失败"
      break
    case .JMSGErrorSDKMediaUploadEmptyFile:
      errorAlert = "上传媒体文件时, 发现文件不存在"
      break
    case .JMSGErrorSDKParamContentInvalid:
      errorAlert = "无效的消息内容"
      break
    case .JMSGErrorSDKParamMessageNil:
      errorAlert = "空消息"
      break
    case .JMSGErrorSDKMessageNotPrepared:
      errorAlert = "消息不符合发送的基本条件检查"
      break
    case .JMSGErrorSDKParamConversationTypeUnknown:
      errorAlert = "未知的会话类型"
      break
    case .JMSGErrorSDKParamConversationUsernameInvalid:
      errorAlert = "会话 username 无效"
      break
    case .JMSGErrorSDKParamConversationGroupIdInvalid:
      errorAlert = "会话 groupId 无效"
      break
    case .JMSGErrorSDKParamGroupGroupIdInvalid:
      errorAlert = "groupId 无效"
      break
    case .JMSGErrorSDKParamGroupGroupInfoInvalid:
      errorAlert = "group 相关字段无效"
      break
    case .JMSGErrorSDKMessageNotInGroup:
      errorAlert = "你已不在该群，无法发送消息"
      break
      //      case 810009:
      //      errorAlert = "超出群上限"
      //      break
    default:
      break
    }
    
    switch error as! JMSGTcpErrorCode {
    case .ErrorTcpUserNotRegistered:
      errorAlert = "用户名还没有被注册过"
      break
    case .ErrorTcpUserPasswordError:
      errorAlert = "密码错误"
      break
    default:
      break
    }
    
    switch error as! JMSGHttpErrorCode {
    case .ErrorHttpServerInternal:
      errorAlert = "服务器端内部错误"
      break
    case .ErrorHttpUserExist:
      errorAlert = "用户已经存在"
      break
    case .ErrorHttpUserNotExist:
      errorAlert = "用户不存在"
      break
    case .ErrorHttpPrameterInvalid:
      errorAlert = "参数无效"
      break
    case .ErrorHttpPasswordError:
      errorAlert = "密码错误"
      break
    case .ErrorHttpUidInvalid:
      errorAlert = "内部UID 无效"
      break
    case .ErrorHttpMissingAuthenInfo:
      errorAlert = "Http 请求没有验证信息"
      break
    case .ErrorHttpAuthenticationFailed:
      errorAlert = "Http 请求验证失败"
      break
    case .ErrorHttpAppkeyNotExist:
      errorAlert = "Appkey 不存在"
      break
    case .ErrorHttpTokenExpired:
      errorAlert = "Http 请求 token 过期"
      break
    case .ErrorHttpServerResponseTimeout:
      errorAlert = "服务器端响应超时"
      break
    default:
      break
    }
    if errorAlert == "" {
      errorAlert = "未知错误"
    }
    return errorAlert
  }
}