//
//  JChatSendImageManager.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/27.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatSendImageManager: NSObject {

  var sendMsgListDic:NSMutableDictionary!
  var textDraftDic:NSMutableDictionary! //未发送的草稿

  class var sharedInstance: JChatSendImageManager {
    struct Static {
      static var onceToken: dispatch_once_t = 0
      static var instance: JChatSendImageManager? = nil
    }
    dispatch_once(&Static.onceToken) {
      Static.instance = JChatSendImageManager()
    }
    return Static.instance!
  }

  override init() {
    super.init()
    self.sendMsgListDic = NSMutableDictionary()
    self.textDraftDic = NSMutableDictionary()
  }

  func addMessage(imgMsg:JMSGMessage, withConversation conversation:JMSGConversation) {
    var key:String = ""
    if conversation.conversationType == .Single {
      key = (conversation.target as! JMSGUser).username
    } else {
      key = (conversation.target as! JMSGGroup).gid
    }
    
    if self.sendMsgListDic.objectForKey(key) == nil {
      let sendMsgCtl:JChatSendImageController = JChatSendImageController()
      sendMsgCtl.msgConversation = conversation
      sendMsgCtl.addDelegateForConversation(conversation)
      sendMsgCtl.prepareImageMessage(imgMsg)
      self.sendMsgListDic.setObject(sendMsgCtl, forKey: key)
    } else {
      let sendMsgCtl = self.sendMsgListDic.objectForKey(key)
      sendMsgCtl!.prepareImageMessage(imgMsg)
    }
    
  }

  func updateConversation(conversation:JMSGConversation, withDraft draftString:String) {
    var key = ""
    key = NSString.conversationIdWithConversation(conversation)
    self.textDraftDic.setObject(draftString, forKey: key)
  }

  func draftStringWithConversation(conversaion:JMSGConversation) -> String {
    var key = ""
    key = NSString.conversationIdWithConversation(conversaion)
    if self.textDraftDic.objectForKey(key) != nil {
      return self.textDraftDic.objectForKey(key) as! String
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

  func addDelegateForConversation(conversation:JMSGConversation) {
    JMessage.addDelegate(self, withConversation: conversation)
  }

  func removeDelegate() {
    JMessage.removeDelegate(self, withConversation: self.msgConversation)
  }
  
  func sendStart() {
    self.msgConversation.sendMessage(self.draftImageMessageArr[0] as! JMSGMessage)
  }

  func prepareImageMessage(imgMsg:JMSGMessage) {
    self.draftImageMessageArr.addObject(imgMsg)
    if self.draftImageMessageArr.count == 1 {
      self.sendStart()
    }
  }
}

extension JChatSendImageController : JMessageDelegate {
  func onSendMessageResponse(message: JMSGMessage!, error: NSError!) {
    
    
    if message.contentType != .Image {
      return
    }

    self.draftImageMessageArr.removeObjectAtIndex(0)
    if self.draftImageMessageArr.count > 0 {
      self.sendStart()
    }
  }
}

