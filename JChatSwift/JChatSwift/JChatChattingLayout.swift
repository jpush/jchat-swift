//
//  JChatChattingLayout.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatChattingLayout: NSObject {
  internal var messageListTable:JChatMessageTable? = nil
  internal var inputView:JChatInputView? = nil
  
  init(messageTable:JChatMessageTable, inputView:JChatInputView) {
    super.init()
    self.messageListTable = messageTable
    self.inputView = inputView
  }


  func insertTableViewCellAtRows(addIndexs:NSArray) {
    if addIndexs.count == 0 { return }
    
    var addIndexPaths:[NSIndexPath] = [NSIndexPath]()
    for (_, value) in addIndexs.enumerate() {
      addIndexPaths.append(NSIndexPath(forRow: (value as! Int), inSection: 0))
    }
    self.messageListTable?.beginUpdates()
    self.messageListTable?.insertRowsAtIndexPaths(addIndexPaths, withRowAnimation: .None)
    self.messageListTable?.endUpdates()
  }

  func appendTableViewCellAtLastIndex(index:NSInteger) {
    let path:NSIndexPath = NSIndexPath(forRow: index - 1, inSection: 0)
    self.messageListTable?.beginUpdates()
    self.messageListTable?.insertRowsAtIndexPaths([path], withRowAnimation: .None)
    self.messageListTable?.endUpdates()
    UIView.animateWithDuration(0.25) { () -> Void in
      self.messageListTable?.scrollToRowAtIndexPath(path, atScrollPosition: .Bottom, animated: false)      
    }

    dispatch_async(dispatch_get_main_queue()) { () -> Void in
    }
  }
  
  // TODO: 
  func messageTableScrollToBottom(animation:Bool) {
    if (self.messageListTable?.contentSize.height)! + (self.messageListTable?.contentInset.top)! > self.messageListTable?.frame.size.height {
      let offset = CGPointMake(0, (self.messageListTable?.contentSize.height)! - self.messageListTable!.frame.size.height)

      if animation {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
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
  
  func messageTableScrollToIndexCell(index:Int) {
    self.messageListTable?.scrollToRowAtIndexPath(NSIndexPath(forRow: index - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
  }
  
  func hideKeyboard() {

  }
  
  func showMoreView() {
    
  }
  
  func hideMoreView() {
    
  }
}






