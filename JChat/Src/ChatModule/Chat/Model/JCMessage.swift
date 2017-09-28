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
}

@objc public protocol JCMessageDelegate: NSObjectProtocol {
    @objc optional func message(videoData data: Data?)
    @objc optional func message(voiceData data: Data?, duration: Double)
    @objc optional func message(message: JCMessageType, fileData data: Data?, fileName: String?, fileType: String?)
    @objc optional func message(location address: String?, lat: Double, lon: Double)
    @objc optional func message(message: JCMessageType, image: UIImage?)
    @objc optional func clickTips(message: JCMessageType)
    @objc optional func tapAvatarView(message: JCMessageType)
}
