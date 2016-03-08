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
  var oldcontentOffset:CGPoint?
  
//  override var contentSize: CGSize {
//    didSet {
//      if self.oldcontentOffset != nil {
//        if self.isFlashToLoad != false {
//          if !CGSizeEqualToSize(self.contentSize, CGSizeZero) {
//            if oldValue.height < self.contentSize.height {
//              oldcontentOffset = CGPointMake(0, self.oldcontentOffset!.y + self.contentSize.height - oldValue.height)
//              super.contentOffset = self.oldcontentOffset!
//            }
//          }
//        }
//      }
//          self.isFlashToLoad = false
//    }
//  }
//  override init(frame: CGRect, style: UITableViewStyle) {
//    super.init(frame: frame, style: style)
//    
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//  }
  
  func loadMoreMessage() {
    self.isFlashToLoad = true
    self.oldcontentOffset = CGPointMake(0, 0)
    self.reloadData()
  }
}
