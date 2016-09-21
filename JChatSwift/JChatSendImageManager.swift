//
//  JChatSendImageManager.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/27.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatSendImageManager: NSObject {

//  private static var __once: () = {
//      Static.instance = JChatSendImageManager()
//    }()

  var sendMsgListDic:NSMutableDictionary!
  var textDraftDic:NSMutableDictionary! //未发送的草稿

//  class var sharedInstance: JChatSendImageManager {
//    struct Static {
//      static var onceToken: Int = 0
//      static var instance: JChatSendImageManager? = nil
//    }
//    _ = JChatSendImageManager.__once
//    return Static.instance!
//  }
  static let sharedInstance = JChatSendImageManager()
  override init() {
    super.init()
    self.sendMsgListDic = NSMutableDictionary()
    self.textDraftDic = NSMutableDictionary()
  }

  func addMessage(_ imgMsg:JMSGMessage, withConversation conversation:JMSGConversation) {
    var key:String = ""
    if conversation.conversationType == .single {
      key = (conversation.target as! JMSGUser).username
    } else {
      key = (conversation.target as! JMSGGroup).gid
    }
    
    if self.sendMsgListDic.object(forKey: key) == nil {
      let sendMsgCtl:JChatSendImageController = JChatSendImageController()
      sendMsgCtl.msgConversation = conversation
      sendMsgCtl.addDelegateForConversation(conversation)
      sendMsgCtl.prepareImageMessage(imgMsg)
      self.sendMsgListDic.setObject(sendMsgCtl, forKey: key as NSCopying)
    } else {
      let sendMsgCtl = self.sendMsgListDic.object(forKey: key)
      (sendMsgCtl! as AnyObject).prepareImageMessage(imgMsg)
    }
    
  }

  func updateConversation(_ conversation:JMSGConversation, withDraft draftString:String) {
    var key = ""
    key = NSString.conversationIdWithConversation(conversation)
    self.textDraftDic.setObject(draftString, forKey: key as NSCopying)
  }

  func draftStringWithConversation(_ conversaion:JMSGConversation) -> String {
    var key = ""
    key = NSString.conversationIdWithConversation(conversaion)
    if self.textDraftDic.object(forKey: key) != nil {
      return self.textDraftDic.object(forKey: key) as! String
    } else {
      return ""
    }
  }

}

class JChatSendImageController: NSObject {
  var msgConversation:JMSGConversation!
  var draftImageMessageArr:NSMutableArray!
  override init() {
    super.init()
    self.draftImageMessageArr = NSMutableArray()
  }

  func addDelegateForConversation(_ conversation:JMSGConversation) {
    JMessage.add(self, with: conversation)
  }

  func removeDelegate() {
    JMessage.remove(self, with: self.msgConversation)
  }
  
  func sendStart() {
    self.msgConversation.send(self.draftImageMessageArr[0] as! JMSGMessage)
  }

  func prepareImageMessage(_ imgMsg:JMSGMessage) {
    self.draftImageMessageArr.add(imgMsg)
    if self.draftImageMessageArr.count == 1 {
      self.sendStart()
    }
  }
}

extension JChatSendImageController : JMessageDelegate {
  func onSendMessageResponse(_ message: JMSGMessage!, error: NSError!) {
    
    
    if message.contentType != .image {
      return
    }

    self.draftImageMessageArr.removeObject(at: 0)
    if self.draftImageMessageArr.count > 0 {
      self.sendStart()
    }
  }
}

