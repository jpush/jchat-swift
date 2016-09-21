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
  
  var imageMessageArr:NSMutableArray!  //用于存储图片的arrary
  
  var messageLimit:Int!
  var messagefristPageNumber:Int!
  var showTimeInterval:Double!
  var messageOffset:Int!          // 当前message 的位置，，用于纪录获取更多的历史消息
  var isNoMoreHistoryMsg:Bool!
  
  var messageCell:JChatRightMessageCell!
  init(conversation:JMSGConversation, showTimeInterval:Double, fristPageNumber:Int, limit:Int) {
    super.init()
    self.conversation = conversation
    self.showTimeInterval = showTimeInterval
    self.messagefristPageNumber = fristPageNumber
    self.messageLimit = limit
    self.allMessageDic = NSMutableDictionary()
    self.allMessageIdArr = NSMutableArray()
    self.imageMessageArr = NSMutableArray()
    self.isNoMoreHistoryMsg = false
    self.messageOffset = 0
    self.messageCell = JChatRightMessageCell.init(style: .default, reuseIdentifier: "MessageCellToGetRowHeight")
  }
  
  /**
  *  清除所有的消息缓存
  */
  func cleanCache() {
    self.allMessageIdArr.removeAllObjects()
    self.allMessageDic.removeAllObjects()
  }
  
  /**
  *  把消息拼接到消息列表的最后
  */
  func appendMessage(_ model:NSObject) {
    if model.isKind(of: JChattimeModel.self) {
      self.allMessageIdArr.add(model)
    } else {
      self.getMessageCellHeight(model as! JChatMessageModel)
      self.allMessageDic.setObject(model, forKey: (model as! JChatMessageModel).message.msgId as NSCopying)

      self.allMessageIdArr.add((model as! JChatMessageModel).message.msgId)
      
      self.imageMessageArr.add(model)
    }
  }
  
  /**
  *  拼接时间消息到消息列表最后一行
  */
  func appendTimeData(_ timeInterVal:TimeInterval) {
    let timeModel = JChattimeModel()
    timeModel.messageTime = timeInterVal as NSNumber!
    self.appendMessage(timeModel)
  }
  
  /**
  *  插入消息到消息列表的指定行
  */
  func addmessage(_ model:NSObject, toIndex index:Int) {
    if model.isKind(of: JChattimeModel.self) {
      self.allMessageIdArr.insert(model, at: index)
    } else {
      self.getMessageCellHeight(model as! JChatMessageModel)
      self.allMessageIdArr.insert(model, at: index)
      self.allMessageDic.setObject(model, forKey: (model as! JChatMessageModel).message.msgId as NSCopying)
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
    self.allMessageIdArr.add(NSObject())
    let thearr = self.conversation.messageArrayFromNewest(withOffset: self.messageOffset as NSNumber?, limit: self.messagefristPageNumber as NSNumber?) as NSArray
    
    arrList.addObjects(from: (self.conversation.messageArrayFromNewest(withOffset: self.messageOffset as NSNumber?, limit: self.messagefristPageNumber as NSNumber?) as NSArray).reverseObjectEnumerator().allObjects)
    self.messageOffset = self.messageOffset + self.messagefristPageNumber
    if arrList.count < self.messagefristPageNumber {
      self.isNoMoreHistoryMsg = true
      self.allMessageIdArr.removeObject(at: 0)
    }

    for (_, value) in arrList.enumerated() {
      let message:JMSGMessage = value as! JMSGMessage
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.getMessageCellHeight(model)
      self.dataMessageShowtime(message.timestamp)
      self.allMessageDic.setObject(model, forKey: model.message.msgId as NSCopying)
      self.allMessageIdArr.add(model.message.msgId)
      if message.contentType == .image {
        imageMessageArr.add(model)
      }
    }
  }
  
  /**
   *  分页获取跟多的历史消息
   */
  func getMoreMessage() {
    
    let arrList = NSMutableArray()
//    arrList.addObjectsFromArray((self.conversation.messageArrayFromNewestWithOffset(self.messageOffset, limit: self.messageLimit) as NSArray).reverseObjectEnumerator().allObjects)
    arrList.addObjects(from: self.conversation.messageArrayFromNewest(withOffset: self.messageOffset as NSNumber?, limit: self.messageLimit as NSNumber?) as NSArray as [AnyObject])
    self.messageOffset = self.messageOffset + self.messageLimit
    if arrList.count < self.messageLimit {
      self.isNoMoreHistoryMsg = true
      self.allMessageIdArr.removeObject(at: 0)
    }
    
    for (_, value) in arrList.enumerated() {
      let message:JMSGMessage = value as! JMSGMessage
      let model:JChatMessageModel = JChatMessageModel()
      model.setChatModel(message, conversation: self.conversation)
      self.getMessageCellHeight(model)
      self.dataMessageShowTimeToTop(message.timestamp)
      if self.isNoMoreHistoryMsg == true {
        self.allMessageIdArr.insert(model.message.msgId, at: 0)
      } else {
        self.allMessageIdArr.insert(model.message.msgId, at: 1)
      }
      
      if message.contentType == .image {
        imageMessageArr.insert(model, at: 0)
      }
      
      self.allMessageDic.setObject(model, forKey: model.message.msgId as NSCopying)
      
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
  func getMessageWithIndex(_ index:Int) -> AnyObject {
    let messageId = self.allMessageIdArr[index]
    if (messageId as AnyObject) is JChattimeModel {
      return messageId as AnyObject
    } else {
    
      let model:JChatMessageModel = self.allMessageDic.object(forKey: messageId) as! JChatMessageModel
      return model
    }
  }
  
  /**
  *  通过msgId 获取指定消息model
  */
  func getMessageWithMsgId(_ messageId:String) -> JChatMessageModel{
    return self.allMessageDic.object(forKey: messageId) as! JChatMessageModel
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
  func tableIndexPathWithMessageId(_ messageId:String) -> IndexPath {
    let index = self.allMessageIdArr.index(of: messageId)
    let indexPath = IndexPath(row: index, section: 0)
    return indexPath
  }

  
  /**
   * 删除message
   */
  func deleteMessage(_ message:JMSGMessage) {
    self.allMessageIdArr.remove(message.msgId)
    self.allMessageDic.removeObject(forKey: message.msgId)
  }
  
  /**
  *
  */
  func isContaintMessage(_ msgId:String) -> Bool {
    if self.allMessageDic[msgId] == nil {
      return false
    } else {
      return true
    }
  }
  
  internal func getMessageCellHeight(_ model: JChatMessageModel) -> CGFloat {
    messageCell.setCellData(model)
    messageCell.layoutIfNeeded()
    let height = messageCell.systemLayoutSizeFitting(CGSize.zero).height
    model.messageCellHeight = height + 1
    return height
  }
  
  internal func dataMessageShowtime(_ timeNumber:NSNumber) {
    if self.allMessageIdArr.count > 0 {
      if (self.allMessageIdArr.lastObject! as AnyObject) is NSString {
        let messageId = self.allMessageIdArr.lastObject
        let lastModel = self.allMessageDic.object(forKey: messageId!) as! JChatMessageModel
        let timeInterVal = timeNumber.doubleValue
        if lastModel.isKind(of: JChatMessageModel.self) != false {
          let lastDate:Date = Date(timeIntervalSince1970: (lastModel.messageTime?.doubleValue)!)
          let currentDate = Date(timeIntervalSince1970: timeInterVal)
          
          let timeBetween = currentDate.timeIntervalSince(lastDate)
          if fabs(timeBetween) > showTimeInterval {
            let timeModel = JChattimeModel()
            timeModel.messageTime = timeInterVal as NSNumber!
            self.allMessageIdArr.add(timeModel)
          }
        }
      }
    } else {
      let timeInterVal = timeNumber.doubleValue
      let timeModel = JChattimeModel()
      timeModel.messageTime = timeInterVal as NSNumber!
      self.allMessageIdArr.add(timeModel)
    }
  }
  
  func dataMessageShowTimeToTop(_ timeNumber:NSNumber) {
    
    if self.allMessageIdArr.count > 0 {
      var fristObj:AnyObject
      
      if self.isNoMoreHistoryMsg! {
//        fristObj = self.allMessageIdArr[0]
        fristObj = self.allMessageIdArr.object(at: 0) as AnyObject
      } else {
//        fristObj = self.allMessageIdArr[1]
        fristObj = self.allMessageIdArr.object(at: 1) as AnyObject
      }
      print(fristObj is NSString)
      if fristObj is NSString {
        let fristModel = self.allMessageDic.object(forKey: fristObj) as! JChatMessageModel
        let timeInterVal = timeNumber.doubleValue
        
        if fristModel.isKind(of: JChatMessageModel.self) == true {
          let lastDate:Date = Date(timeIntervalSince1970: (fristModel.messageTime?.doubleValue)!)
          let currentDate = Date(timeIntervalSince1970: timeInterVal)
          
          let timeBetween = lastDate.timeIntervalSince(currentDate)
          
          if fabs(timeBetween) > showTimeInterval {
            let timeModel = JChattimeModel()
            timeModel.messageTime = timeInterVal as NSNumber!
            if self.isNoMoreHistoryMsg! {
              self.allMessageIdArr.insert(timeModel, at:0)
            } else {
              self.allMessageIdArr.insert(timeModel, at:1)
            }
          }
        }
        
      }
      
    }
  }
}
