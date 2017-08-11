//
//  JMSGMessage+JChat.swift
//  JChat
//
//  Created by deng on 2017/6/23.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension JMSGMessage {
    var state: JCMessageState {
        get {
            var state: JCMessageState!
            switch self.status {
            case .sendFailed, .sendUploadFailed:
                state = .sendError
            case .sending:
                state = .sending
            default:
                state = .sendSucceed
            }
            return state
        }
    }
    
    var isFile: Bool {
        get {
            if let content = self.content as? JMSGFileContent {
                if let extras = content.extras {
                    if extras.keys.contains(where: { (key) -> Bool in
                        if let key = key as? String {
                            return key == kFileType || key == kFileSize
                        }
                        return false
                    }) {
                        return true
                    }
                }
            }
            return false
        }
        set {
            if let content = self.content as? JMSGFileContent {
                content.addStringExtra("mov", forKey: kShortVideo)
            }
        }
    }
    
    var fileType: String? {
        get {
            if !self.isFile {
                return nil
            }
            guard let extras = self.content?.extras else {
                return nil
            }
            return extras[kFileType] as? String
        }
    }
    
    var fileSize: String? {
        get {
            if !self.isFile {
                return nil
            }
            guard let extras = self.content?.extras else {
                return nil
            }
            if let size = extras[kFileSize] as? Int {
                if size > 1024 * 1024 {
                    return String(format: "%.1fM", Double(size) / 1024.0 / 1024.0)
                }
                if size > 1024 {
                    return "\(size / 1024)K"
                }
                return "\(size)B"
            }
            return nil
        }
    }
    
    var isShortVideo: Bool {
        get {
            if let content = self.content as? JMSGFileContent {
                if let extras = content.extras {
                    if extras.keys.contains(where: { (key) -> Bool in
                        if let key = key as? String {
                            return key == kShortVideo
                        }
                        return false
                    }) {
                        return true
                    }
                }
            }
            return false
        }
        set {
            if let content = self.content as? JMSGFileContent {
                content.addStringExtra("mov", forKey: kShortVideo)
            }
        }
    }
    
    var isLargeEmoticon: Bool {
        get {
            if let content = self.content as? JMSGImageContent {
                if let extras = content.extras {
                    if extras.keys.contains(where: { (key) -> Bool in
                        if let key = key as? String {
                            // android 的扩展字段：jiguang
                            return key == kLargeEmoticon || key == "jiguang"
                        }
                        return false
                    }) {
                        return true
                    }
                }
            }
            return false
        }
        set {
            if let content = self.content as? JMSGImageContent {
                content.addStringExtra(kLargeEmoticon, forKey: kLargeEmoticon)
            }
        }
    }
    
    static func createMessage(_ conversation: JMSGConversation, _ content: JMSGAbstractContent, _ reminds: [JCRemind]?) -> JMSGMessage {
        let message: JMSGMessage!
        if conversation.isGroup && reminds != nil {
            let group = conversation.target as! JMSGGroup
            
            if reminds!.count > 0 {
                var users: [JMSGUser] = []
                var isAtAll = false
                for remind in reminds! {
                    guard let user = remind.user else {
                        isAtAll = true
                        break
                    }
                    users.append(user)
                }
                if isAtAll {
                    message = JMSGMessage.createGroupAtAllMessage(with: content, groupId: group.gid)
                } else {
                    message = JMSGMessage.createGroupMessage(with: content, groupId: group.gid, at_list: users)
                }
            } else {
                message = JMSGMessage.createGroupMessage(with: content, groupId: group.gid)
            }
        } else {
            message = JMSGMessage.createSingleMessage(with: content, username: JMSGUser.myInfo().username)
        }
        return message
    }
}
