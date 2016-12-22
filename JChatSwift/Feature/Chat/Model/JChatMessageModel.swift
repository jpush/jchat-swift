//
//  JChatMessageModel.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


internal let st_receiveUnknowMessageDes = "收到新消息类型无法解析的数据，请升级查看"
internal let st_receiveErrorMessageDes = "接收消息错误"

class JChatMessageModel:NSObject {

  var message:JMSGMessage!
  var messageTime:NSNumber?
  var photoIndex:Int?
  var isErrorMessage:Bool!
  var messageError:NSError?
  var imageSize:CGSize?
  var voiceBubbleWidth:Double?

  var messageCellHeight:CGFloat!

  func setChatModel(_ message:JMSGMessage!, conversation:JMSGConversation!) {
    self.message = message
    self.messageTime = message.timestamp
    switch message.contentType {
    case .unknown:
      
      break
    case .text:

      break
    case .image:
      (message.content as! JMSGImageContent).thumbImageData({ (data, objectId, error) -> Void in
        if error == nil {
          let img:UIImage? = UIImage(data: data!)
          if img == nil {return}
          
          var imgHeight:CGFloat?
          var imgWidth:CGFloat?
          
          if img?.size.height >= img?.size.width {
            imgHeight = CGFloat(135)
            imgWidth = (img?.size.width)!/(img?.size.height)! * imgHeight!
            imgWidth = (imgWidth < 55) ? 55 : imgWidth
          } else {
            imgWidth = CGFloat(135)
            imgHeight = (img?.size.height)!/(img?.size.width)! * imgWidth!
            imgHeight = (imgHeight < 55) ? 55 : imgHeight
          }
          self.imageSize = CGSize(width: imgWidth!, height: imgHeight!)
        }
      })
      break
    case .voice:
      self.setVoiceLength((message.content as! JMSGVoiceContent).duration)
      break
    case .custom:
      break
    case .eventNotification:
      break
    case .location:
      self.imageSize = CGSize(width: 200, height: 100)
      break
      
    default:
      break
    }
  }
  
  internal func setVoiceLength(_ timeDuration:NSNumber) {
    var voiceBubbleWidth = 0.0
    let duration = timeDuration.doubleValue
    switch duration {
    case duration where duration <= 2:
      voiceBubbleWidth = 60.0
      break
    case duration where duration > 2 && duration <= 20:
      voiceBubbleWidth = 60.0 + 2.5 * duration
      break
    case duration where duration > 20 && duration <= 30:
      voiceBubbleWidth = 110.0 + 2 * duration
      break
    case duration where duration > 30 && duration <= 60:
      voiceBubbleWidth = 130.0 + duration
      break
    default:
      break
    }
    self.voiceBubbleWidth = voiceBubbleWidth
  }
  
  func setError(_ error:NSError!) {
    self.isErrorMessage = true
    self.messageError = error
  }
  
}

@objc(JChattimeModel)
class JChattimeModel:NSObject {
  var messageTime:NSNumber!
}
