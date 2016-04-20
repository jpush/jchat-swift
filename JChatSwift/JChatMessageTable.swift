//
//  JChatMessageTable.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatMessageTable)
class JChatMessageTable: UITableView {
  var isFlashToLoad:Bool! = false
  
  override var contentSize: CGSize {
    didSet {
        if self.isFlashToLoad != false {
          if !CGSizeEqualToSize(self.contentSize, CGSizeZero) {
            if oldValue.height < self.contentSize.height {
              var offset = self.contentOffset
              offset.y = self.contentSize.height - oldValue.height
              self.contentOffset = offset
            }
          }
        }
          self.isFlashToLoad = false
    }
  }
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func loadMoreMessage() {
    self.isFlashToLoad = true
    self.reloadData()
  }
}
