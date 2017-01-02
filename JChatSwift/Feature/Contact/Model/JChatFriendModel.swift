//
//  JChatFriendModel.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/22.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatFriendModel: NSObject {
  
  var user:JMSGUser?
  var isSelected = false
  
  func setData(_ user: JMSGUser!) {
    self.user = user
  }
}
