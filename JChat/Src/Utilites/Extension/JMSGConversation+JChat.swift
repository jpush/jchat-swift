//
//  JMSGConversation+JChat.swift
//  JChat
//
//  Created by deng on 2017/7/21.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension JMSGConversation {
    var isGroup: Bool {
        get {
            return self.conversationType == .group
        }
    }
}
