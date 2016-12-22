//
//  JChatMessageInputView.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/12.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatMessageInputView: UITextView {

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    super.canPerformAction(action, withSender: sender)
    return  (action == #selector(self.paste(_:))) || (action == #selector(self.resignFirstResponder))
  }
  
  override var canResignFirstResponder : Bool {
    return true
  }

  
  override func paste(_ sender: Any?) {
    let pasteboard = UIPasteboard.general
    let textAttachment = NSTextAttachment()
    if pasteboard.string != nil {
      super.paste(sender)
      return
    }
    
    if pasteboard.image != nil {
      textAttachment.image = pasteboard.image
      JChatAlertViewManager.sharedInstance.showPastedImageMessageAlert(pasteboard.image!)
    }
  }
}
