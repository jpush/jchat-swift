//
//  NSString+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/25.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

extension NSString {  
  class func getTodayYesterdayString(_ theDate:Date) -> String {
    let formatter = DateFormatter()
    let locale:Locale = Locale(identifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    formatter.doesRelativeDateFormatting = true
    return formatter.string(from: theDate)
  }
  
  class func getPastDateString(_ theDate:Date) -> String {
    let formatter = DateFormatter()
    let locale:Locale = Locale(identifier: "zh")
    formatter.locale = locale
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.doesRelativeDateFormatting = true
    return formatter.string(from: theDate)
  }

  class func getFriendlyDateString(_ timeInterval:TimeInterval, forConversation isShort:Bool) -> String {
    let theDate:Date = Date(timeIntervalSince1970: timeInterval)
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
      let formatter:DateFormatter = DateFormatter()
      let locale:Locale = Locale(identifier: "zh")
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
          output = formatter.string(from: theDate)
          output = "\(todayYesterday) \(output)"
        }
      } else {
        output = formatter.string(from: theDate)
        if isPastLong {
          let thePastDate = NSString.getPastDateString(theDate)
          output = "\(thePastDate) \(output)"
        }
      }
      
      break
    }
    return output
  }
  
  class func conversationIdWithConversation(_ conversation:JMSGConversation) -> String {
    var conversationId = ""
    if conversation.conversationType == .single {
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
  class func errorAlert(_ error :NSError) -> String {
    var errorAlert:String = ""
    
    if error.code > 860000 {
      let  errorcode = JMSGSDKErrorCode(rawValue: Int(error.code))
      switch errorcode! as JMSGSDKErrorCode{
        
      case .jmsgErrorSDKNetworkDownloadFailed:
        errorAlert = "下载失败"
        break
      
      case .jmsgErrorSDKNetworkUploadFailed:
        errorAlert = "上传资源文件失败"
        break
      case .jmsgErrorSDKNetworkUploadTokenVerifyFailed:
        errorAlert = "上传资源文件Token验证失败"
        break
      case .jmsgErrorSDKNetworkUploadTokenGetFailed:
        errorAlert = "获取服务器Token失败"
        break
      case .jmsgErrorSDKDBDeleteFailed:
        errorAlert = "数据库删除失败"
        break
      case .jmsgErrorSDKDBUpdateFailed:
        errorAlert = "数据库更新失败"
        break
      case .jmsgErrorSDKDBSelectFailed:
        errorAlert = "数据库查询失败"
        break
      case .jmsgErrorSDKDBInsertFailed:
        errorAlert = "数据库插入失败"
        break
      case .jmsgErrorSDKParamAppkeyInvalid:
        errorAlert = "appkey不合法"
        break
      case .jmsgErrorSDKParamUsernameInvalid:
        errorAlert = "用户名不合法"
        break
      case .jmsgErrorSDKParamPasswordInvalid:
        errorAlert = "用户密码不合法"
        break
      case .jmsgErrorSDKUserNotLogin:
        errorAlert = "用户没有登录"
        break
      case .jmsgErrorSDKNotMediaMessage:
        errorAlert = "这不是一条媒体消息"
        break
      case .jmsgErrorSDKMediaResourceMissing:
        errorAlert = "下载媒体资源路径或者数据意外丢失"
        break
      case .jmsgErrorSDKMediaCrcCodeIllegal:
        errorAlert = "媒体CRC码无效"
        break
      case .jmsgErrorSDKMediaCrcVerifyFailed:
        errorAlert = "媒体CRC校验失败"
        break
      case .jmsgErrorSDKMediaUploadEmptyFile:
        errorAlert = "上传媒体文件时, 发现文件不存在"
        break
      case .jmsgErrorSDKParamContentInvalid:
        errorAlert = "无效的消息内容"
        break
      case .jmsgErrorSDKParamMessageNil:
        errorAlert = "空消息"
        break
      case .jmsgErrorSDKMessageNotPrepared:
        errorAlert = "消息不符合发送的基本条件检查"
        break
      case .jmsgErrorSDKParamConversationTypeUnknown:
        errorAlert = "未知的会话类型"
        break
      case .jmsgErrorSDKParamConversationUsernameInvalid:
        errorAlert = "会话 username 无效"
        break
      case .jmsgErrorSDKParamConversationGroupIdInvalid:
        errorAlert = "会话 groupId 无效"
        break
      case .jmsgErrorSDKParamGroupGroupIdInvalid:
        errorAlert = "groupId 无效"
        break
      case .jmsgErrorSDKParamGroupGroupInfoInvalid:
        errorAlert = "group 相关字段无效"
        break
      case .jmsgErrorSDKMessageNotInGroup:
        errorAlert = "你已不在该群，无法发送消息"
        break
        //      case 810009:
        //      errorAlert = "超出群上限"
        //      break
      default:
        break
      }
    }
    
    if error.code > 800000 && error.code < 820000  {
      let errorcode = JMSGTcpErrorCode(rawValue: UInt(error.code))
      switch errorcode! {
      case .errorTcpUserNotRegistered:
        errorAlert = "用户名还没有被注册过"
        break
      case .errorTcpUserPasswordError:
        errorAlert = "密码错误"
        break
      default:
        break
      }
    }
    
    if error.code < 600 {
      let errorcode = JMSGHttpErrorCode(rawValue: UInt(error.code))
      switch errorcode! {
        case .errorHttpServerInternal:
          errorAlert = "服务器端内部错误"
          break
        case .errorHttpUserExist:
          errorAlert = "用户已经存在"
          break
        case .errorHttpUserNotExist:
          errorAlert = "用户不存在"
          break
        case .errorHttpPrameterInvalid:
          errorAlert = "参数无效"
          break
        case .errorHttpPasswordError:
          errorAlert = "密码错误"
          break
        case .errorHttpUidInvalid:
          errorAlert = "内部UID 无效"
          break
        case .errorHttpMissingAuthenInfo:
          errorAlert = "Http 请求没有验证信息"
          break
        case .errorHttpAuthenticationFailed:
          errorAlert = "Http 请求验证失败"
          break
        case .errorHttpAppkeyNotExist:
          errorAlert = "Appkey 不存在"
          break
        case .errorHttpTokenExpired:
          errorAlert = "Http 请求 token 过期"
          break
        case .errorHttpServerResponseTimeout:
          errorAlert = "服务器端响应超时"
          break
        default:
          break
        }
    }
    
    if errorAlert == "" {
      errorAlert = "未知错误"
    }
    return errorAlert
  }
}
