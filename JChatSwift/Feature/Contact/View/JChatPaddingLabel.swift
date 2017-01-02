//
//  JChatPaddingLabel.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/27.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatPaddingLabel: UILabel {

  open var padding:UIEdgeInsets?
		
  
  override func drawText(in rect: CGRect) {
    if self.padding == nil {
      self.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    super.drawText(in: UIEdgeInsetsInsetRect(rect, self.padding!))
  }
}
