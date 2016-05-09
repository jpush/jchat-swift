//
//  JChatConversationTable.swift
//  JChatSwift
//
//  Created by oshumini on 16/5/9.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(TouchTableViewDelegate)
protocol TouchTableViewDelegate {
  func TableViewTouchBegin()
}

class JChatConversationTable: UITableView {
  weak var touchDelegate:TouchTableViewDelegate?
  
  override func touchesBegan(touches: Set<UITouch>,
                               withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    self.touchDelegate?.TableViewTouchBegin()
  }

}
