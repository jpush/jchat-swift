//
//  JChatChattingDataSource.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatChattingDataSource: NSObject {
  var conversation:JMSGConversation!
  var allMessageIdArr:NSMutableArray!
  var allMessageDic:NSMutableDictionary!
  
  var messageLimit:Int!
  var messagefristPageNumber:Int!
  var showTimeInterval:Double!
  var messageOffset:Int!
  var isNoMoreHistoryMsg:Bool!
  
  init(conversation:JMSGConversation, showTimeInterval:Double, fristPageNumber:Int, limit:Int) {
    super.init()
    self.conversation = conversation
    self.showTimeInterval = showTimeInterval
    self.messagefristPageNumber = fristPageNumber
    self.messageLimit = limit
    self.allMessageDic = NSMutableDictionary()
    self.allMessageIdArr = NSMutableArray()
  }
  
  /**
  *  清除所有的消息缓存
  */
  func cleanCache() {
  
  }
  
  /**
  *  把消息拼接到消息列表的最后
  */
  func appendMessage(model:NSObject) {
    if model.isKindOfClass(JChattimeModel) {
      self.allMessageIdArr.addObject(model)
    } else {
      self.allMessageDic.setObject(model, forKey: (model as! JChatMessageModel).message.msgId)
      self.allMessageIdArr.addObject((model as! JChatMessageModel).message.msgId)
    }
  }
  
  /**
  *  拼接时间消息到消息列表最后一行
  */
  func appendTimeData(timeInterVal:NSTimeInterval) {
    let timeModel = JChattimeModel()
    timeModel.messageTime = timeInterVal
    self.appendMessage(timeModel)
  }
  
  /**
  *  插入消息到消息列表的指定行
  */
  func addmessage(model:NSObject, toIndex index:Int) {
    if model.isKindOfClass(JChattimeModel) {
      self.allMessageIdArr.insertObject(model, atIndex: index)
    } else {
      self.allMessageIdArr.insertObject(model, atIndex: index)
      self.allMessageDic.setObject(model, forKey: (model as! JChatMessageModel).message.msgId)
    }
  }
  
  /**
  *  分页获取历史消息
  */
  func getPageMessage() {
    print("Action - getPageMessage")
    self.allMessageDic.removeAllObjects()
    self.allMessageIdArr.removeAllObjects()
    let arrList = NSMutableArray()
    self.allMessageIdArr.addObject(NSObject())
    
    self.messageOffset = self.messagefristPageNumber
    arrList.addObjectsFromArray((self.conversation.messageArrayFromNewestWithOffset(0, limit: self.messageOffset) as NSArray).reverseObjectEnumerator().allObjects)
    if arrList.count < self.messagefristPageNumber {
      self.isNoMoreHistoryMsg = true
      self.allMessageIdArr.removeObjectAtIndex(0)
    }

    for (_, value) in arrList.enumerate() {
      let message:JMSGMessage = value as! JMSGMessage
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.dataMessageShowtime(message.timestamp)
      self.allMessageDic.setObject(model, forKey: model.message.msgId)
      self.allMessageIdArr.addObject(model.message.msgId)
    }
  }
  
  /**
  *  返回消息数量
  */
  func messageCount() -> Int {
    return allMessageIdArr.count
  }
  
  /**
  *  用于标识还有没更多历史消息
  */
  func noMoreHistoryMessage() -> Bool {
      return isNoMoreHistoryMsg
  }

  /**
  *  通过index 获取置顶消息model
  */
  func getMessageWithIndex(index:Int) -> AnyObject {
    let messageId = self.allMessageIdArr[index]
    if messageId.isKindOfClass(JChattimeModel) {
      return messageId
    } else {
      let model:JChatMessageModel = self.allMessageDic.objectForKey(messageId) as! JChatMessageModel
      return model
    }
  }
  
  /**
  *  通过msgId 获取指定消息model
  */
  func getMessageWithMsgId(messageId:String) -> JChatMessageModel{
    return self.allMessageDic.objectForKey(messageId) as! JChatMessageModel
  }
  
  /**
  *  返回最后一条消息
  */
  func lastMessage() -> AnyObject {
    let messageId = self.allMessageIdArr.lastObject as! String
    let lastModel = self.getMessageWithMsgId(messageId)
    return lastModel
  }

  /**
  *  返回 指定message 的位置
  */
  func tableIndexPathWithMessageId(messageId:String) -> NSIndexPath {
    let index = self.allMessageIdArr.indexOfObject(messageId)
    let indexPath = NSIndexPath(forRow: index, inSection: 0)
    return indexPath
  }

  internal func dataMessageShowtime(timeNumber:NSNumber) {
    
    if self.allMessageIdArr.count > 0 {
      let messageId = self.allMessageIdArr.lastObject
      let lastModel = self.allMessageDic.objectForKey(messageId!) as! JChatMessageModel
      let timeInterVal = timeNumber.doubleValue
      if lastModel.isKindOfClass(JChatMessageModel) != false {
        let lastDate:NSDate = NSDate(timeIntervalSince1970: (lastModel.messageTime?.doubleValue)!)
        let currentDate = NSDate(timeIntervalSince1970: timeInterVal)
        let timeBetween = currentDate.timeIntervalSinceDate(lastDate)
        if fabs(timeBetween) > showTimeInterval {
          let timeModel = JChattimeModel()
          timeModel.messageTime = timeInterVal
          self.allMessageIdArr.addObject(timeModel)
        }
      }
    } else {
      let timeInterVal = timeNumber.doubleValue
      let timeModel = JChattimeModel()
      timeModel.messageTime = timeInterVal
      self.allMessageIdArr.addObject(timeModel)
    }
  }
}
