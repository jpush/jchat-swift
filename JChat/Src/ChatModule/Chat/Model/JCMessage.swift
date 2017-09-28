//
//  JCMessage.swift
//  JChat
//
//  Created by deng on 10/04/2017.
//  Copyright © 2017 HXHG. All rights reserved.
//

import UIKit
import JMessage

open class JCMessage: NSObject, JCMessageType {

    init(content: JCMessageContentType) {
        self.content = content
        self.options = JCMessageOptions(with: content)
        super.init()
    }
    
    open let identifier: UUID = .init()
    open var msgId = ""
    open var name: String = "UserName"
    open var date: Date = .init()
    open var sender: JMSGUser?
    open var senderAvator: UIImage?
    open var receiver: JMSGUser?
    open var content: JCMessageContentType
    open let options: JCMessageOptions
    open var updateSizeIfNeeded: Bool = false
    open var unreadCount: Int = 0
    open var targetType: MessageTargetType = .single
}

@objc public protocol JCMessageDelegate: NSObjectProtocol {
    @objc optional func message(videoData data: Data?)
    @objc optional func message(voiceData data: Data?, duration: Double)
    @objc optional func message(message: JCMessageType, fileData data: Data?, fileName: String?, fileType: String?)
    @objc optional func message(location address: String?, lat: Double, lon: Double)
    @objc optional func message(message: JCMessageType, image: UIImage?)
    // user 对象是为了提高效率，如果 user 已经加载出来了，就直接使用，不需要重新去获取一次
    @objc optional func message(message: JCMessageType, user: JMSGUser?, businessCardName: String, businessCardAppKey: String)
    @objc optional func clickTips(message: JCMessageType)
    @objc optional func tapAvatarView(message: JCMessageType)
    @objc optional func longTapAvatarView(message: JCMessageType)
    @objc optional func tapUnreadTips(message: JCMessageType)
}
