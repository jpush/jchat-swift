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

    var stickyTime: Int {
        if let extras = self.getExtras() {
            if extras[kConversationSticky] != nil {
                let value = extras[kConversationSticky] as! String
                if !value.isEmpty {
                    return Int(value) ?? 0
                }
            }
        }
        return 0
    }

    var isSticky: Bool {
        get {
            if let extras = self.getExtras() {
                if extras[kConversationSticky] != nil {
                    let value = extras[kConversationSticky] as! String
                    if !value.isEmpty {
                        return true
                    }
                }
            }
            return false
        }
        set {
            if newValue {
                let date = Date(timeIntervalSinceNow: 0)
                let time = String(Int(date.timeIntervalSince1970))
                self.setExtraValue(time, forKey: kConversationSticky)
            } else {
                self.setExtraValue(nil, forKey: kConversationSticky)
            }
        }
    }
}
