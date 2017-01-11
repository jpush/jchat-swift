//
//  JChatInvitationModel.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/4.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JChatInvitationModel: NSObject {
  open var user:JMSGUser?
  var reason:String?
  var type:JChatFriendEventNotificationType?
  
  func setData(_ reason: String, type: JChatFriendEventNotificationType) {
    self.reason = reason
    self.type = type
  }
  
  
}
