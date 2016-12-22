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

  override var canBecomeFirstResponder : Bool {
    return true
  }
  
  func attachTapHandler() {
    self.isUserInteractionEnabled = true
    let touch = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    touch.minimumPressDuration = 0.7
    self.addGestureRecognizer(touch)
  }
  
  func handleTap(_ recognizer: UIGestureRecognizer) {
    self.becomeFirstResponder()
    UIMenuController.shared.setTargetRect(self.frame, in: self.superview!)
    UIMenuController.shared.setMenuVisible(true, animated: true)
    
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if self.message?.contentType == .voice {
      return action == #selector(self.delete(_:))
    } else {
      return action == #selector(self.copy(_:)) || action == #selector(self.delete(_:))
    }
  }
  
  override func copy(_ sender: Any?) {
    
    let pboard = UIPasteboard.general
    switch self.message!.contentType {
      case .text:
        let textContent = self.message?.content as! JMSGTextContent
        pboard.string = textContent.text
        break
      case .image:
        let imageContent = self.message?.content as! JMSGImageContent
        imageContent.thumbImageData({ (imageData, msgId, error) in
          if (imageData != nil) && (error == nil) {
            pboard.image = UIImage(data: imageData!)
          } else {
            print("get message image fail")
          }
      })
      break
    default:
      break
    }
  }
  
  override func delete(_ sender: Any?) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: kDeleteMessage), object: self.message)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.maskBackgroupView!.image = self.maskBackgroupImage
    self.maskBackgroupView!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    self.layer.mask = self.maskBackgroupView!.layer
  }
}
