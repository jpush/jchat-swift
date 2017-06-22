//
//  JCMessageType.swift
//  JChat
//
//  Created by deng on 10/04/2017.
//  Copyright © 2017 HXHG. All rights reserved.
//

import Foundation
import JMessage

@objc public protocol JCMessageType: class {
    
    var name: String { get }
    var identifier: UUID { get }
    var msgId: String { get }
    var date: Date { get }
    var sender: JMSGUser? { get }
    var senderAvator: UIImage? { get }
    var receiver: JMSGUser? { get }
    var content: JCMessageContentType { get }
    var options: JCMessageOptions { get }
    var updateSizeIfNeeded: Bool {get}
}
