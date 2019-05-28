//
//  Array+JChat.swift
//  JChat
//
//  Created by JIGUANG on 2017/10/11.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

// MARK: - JCMessageType
extension Array where Element: JCMessageType {

    func index(_ message: JMSGMessage) -> Int? {
        return self.index(where: { (m) -> Bool in
            m.msgId == message.msgId
        })
    }

    func index(_ message: JCMessageType) -> Int? {
        return self.index(where: { (m) -> Bool in
            m.msgId == message.msgId
        })
    }
}

// MARK: - String
extension Array where Element == String {
    func sortedKeys() -> [Element] {
        var array = self.sorted(by: { (str1, str2) -> Bool in
            return str1 < str2
        })
        if let first = array.first {
            if first == "#" {
                array.removeFirst()
                array.append(first)
            }
        }
        return array
    }

}
