//
//  JChatChattingLayout.swift
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JChatChattingLayout: NSObject {
  internal weak var messageListTable:JChatMessageTable? = nil
  internal weak var inputView:JChatInputView? = nil
  
  init(messageTable:JChatMessageTable, inputView:JChatInputView) {
    super.init()
    self.messageListTable = messageTable
    self.inputView = inputView
  }


  func insertTableViewCellAtRows(_ addIndexs:NSArray) {
    if addIndexs.count == 0 { return }
    
    var addIndexPaths:[IndexPath] = [IndexPath]()
    for (_, value) in addIndexs.enumerated() {
      addIndexPaths.append(IndexPath(row: (value as! Int), section: 0))
    }
    self.messageListTable?.beginUpdates()
    self.messageListTable?.insertRows(at: addIndexPaths, with: .none)
    self.messageListTable?.endUpdates()
  }

  func appendTableViewCellAtLastIndex(_ index:NSInteger) {
    let path:IndexPath = IndexPath(row: index - 1, section: 0)
    //DispatchQueue.main.async {
      self.messageListTable?.beginUpdates()
      self.messageListTable?.insertRows(at: [path], with: .none)
      self.messageListTable?.endUpdates()
    
    
      UIView.animate(withDuration: 0.25, animations: { () -> Void in
        self.messageListTable?.scrollToRow(at: path, at: .bottom, animated: false)
      })
    //}
//    self.messageTableScrollToBottom(true)
    DispatchQueue.main.async { () -> Void in
    }
  }
  
  // TODO: 
  func messageTableScrollToBottom(_ animation:Bool) {
    if (self.messageListTable?.contentSize.height)! + (self.messageListTable?.contentInset.top)! > self.messageListTable?.frame.size.height {
      let offset = CGPoint(x: 0, y: (self.messageListTable?.contentSize.height)! - self.messageListTable!.frame.size.height)

      if animation {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.messageListTable?.setContentOffset(offset, animated: true)
        })
      } else {
          self.messageListTable?.setContentOffset(offset, animated: false)
        }
      }
    }

  func loadMoreMessage() {
    self.messageListTable?.loadMoreMessage()
  }
  
  func messageTableScrollToIndexCell(_ index:Int) {
    self.messageListTable?.scrollToRow(at: IndexPath(row: index - 1, section: 0), at: .bottom, animated: true)
  }
  
  func hideKeyboard() {

  }
  
  func showMoreView() {
    
  }
  
  func hideMoreView() {
    
  }
}






