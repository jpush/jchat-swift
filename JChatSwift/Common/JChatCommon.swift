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
  
  case waitingVerification
  
  case receiveFriendInvitation
  
  case acceptedFriendInvitation
  
  case declinedFriendInvitation
  
}
