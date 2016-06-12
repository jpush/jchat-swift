//
//  JChatMessageBubble.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/25.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

let kDeleteMessage = "DeleteMessage"

@objc(JChatMessageBubble)
class JChatMessageBubble: UIImageView {
  var maskBackgroupImage:UIImage?
  var maskBackgroupView:UIImageView?
  weak var message:JMSGMessage?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    maskBackgroupView = UIImageView()
    self.attachTapHandler()
  }

  override func canBecomeFirstResponder() -> Bool {
    return true
  }
  
  func attachTapHandler() {
    self.userInteractionEnabled = true
    let touch = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    touch.minimumPressDuration = 0.7
    self.addGestureRecognizer(touch)
  }
  
  func handleTap(recognizer: UIGestureRecognizer) {
    self.becomeFirstResponder()
    UIMenuController.sharedMenuController().setTargetRect(self.frame, inView: self.superview!)
    UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
    
  }
  
  override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    if self.message?.contentType == .Voice {
      return action == #selector(self.delete(_:))
    } else {
      return action == #selector(self.copy(_:)) || action == #selector(self.delete(_:))
    }
  }
  
  override func copy(sender: AnyObject?) {
    
    let pboard = UIPasteboard.generalPasteboard()
    switch self.message!.contentType {
      case .Text:
        let textContent = self.message?.content as! JMSGTextContent
        pboard.string = textContent.text
        break
      case .Image:
        let imageContent = self.message?.content as! JMSGImageContent
        imageContent.thumbImageData({ (imageData, msgId, error) in
          if (imageData != nil) && (error == nil) {
            pboard.image = UIImage(data: imageData)
          } else {
            print("get message image fail")
          }
      })
      break
    default:
      break
    }
  }
  
  override func delete(sender: AnyObject?) {
    NSNotificationCenter.defaultCenter().postNotificationName(kDeleteMessage, object: self.message)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.maskBackgroupView!.image = self.maskBackgroupImage
    self.maskBackgroupView!.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
    self.layer.mask = self.maskBackgroupView!.layer
  }
}
