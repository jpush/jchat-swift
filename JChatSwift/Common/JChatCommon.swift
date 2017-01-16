//
//  JChatCommon.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/5.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import Foundation

typealias CompletionBlock = (_ result: Any) -> Void
typealias ClickBlock = () -> Void
//typealias SendMessageCallback = () -> ()

// friend notification
let kDeleteFriendNotificaion = "kDeleteFriendNotificaion"
let kAcceptFriendNotification = "kAcceptFriendNotification"
let kContactDataReadyNotification = "kContactDataReadyNotification"

// account notification
let kAccountChangeNotification = "kAccountChangeNotification"

public enum JChatFriendEventNotificationType : NSInteger {
  // 自己发送的好友请求 等待被验证
  case waitingVerification

  //  自己人的好友请求 已同意
  case acceptedFriendInvitation
  
  //  自己的好友请求被拒绝
  case declinedFriendInvitation
  
  
  //  收到陌生人的好友请求
  case receiveFriendInvitation
  
  // 陌生人的好友请求 已拒绝
  case rejectedOtherFriendInvitation
  
  // 陌生人的好友请假 已同意
  case accptedOtherFriendInvitation
  
}
