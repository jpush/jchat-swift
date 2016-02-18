//
//  JChatChattingLayout.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatChattingLayout: NSObject {
  internal var messageListTable:UITableView? = nil
  internal var inputView:JChatInputView? = nil
  
  func setupLayout(inputView:JChatInputView, tableView:UITableView) {
    self.messageListTable = tableView
    self.inputView = inputView
  }
  
//  
//  
//  -(void)insertTableViewCellAtRows:(NSArray*)addIndexs
//  {
//  if (!addIndexs.count) {
//  return;
//  }
//  NSMutableArray *addIndexPathes = [NSMutableArray array];
//  [addIndexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//  [addIndexPathes addObject:[NSIndexPath indexPathForRow:[obj integerValue] inSection:0]];
//  }];
//  [_messageListTable beginUpdates];
//  [_messageListTable insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationNone];
//  [_messageListTable endUpdates];
//  
//  NSTimeInterval scrollDelay = .01f;
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(scrollDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//  [_messageListTable scrollToRowAtIndexPath:[addIndexPathes lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//  });
//}

//
//- (void)appendTableViewCellAtLastIndex:(NSInteger)index {
//  NSIndexPath *path = [NSIndexPath indexPathForRow:index - 1 inSection:0];
//  [_messageListTable beginUpdates];
//  [_messageListTable insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//  [_messageListTable endUpdates];
//  dispatch_async(dispatch_get_main_queue(), ^{
//  [self messageTableScrollToIndeCell:index];
//  });
//  }
//  
//  - (void)messageTableScrollToBottom:(BOOL)animation {
//    if (_messageListTable.contentSize.height + _messageListTable.contentInset.top > _messageListTable.frame.size.height)
//    {
//      CGPoint offset = CGPointMake(0, _messageListTable.contentSize.height - _messageListTable.frame.size.height);
//      if (animation) {
//        [UIView animateWithDuration:animationDuration animations:^{
//          [_messageListTable setContentOffset:offset];
//          }];
//      } else {
//        [_messageListTable setContentOffset:offset animated:animation];
//        [_messageListTable setContentOffset:offset];
//      }
//    }
//    }
//    
//    - (void)messageTableScrollToIndeCell:(NSInteger)index {
//      [_messageListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//      }
//      
//      - (void)hideKeyboard {
//        [_inputView hideKeyboard];
//        }
//        
//        - (void)showMoreView {
//          NSLog(@"huangmin superview  height  %f",[_messageListTable superview].jmui_height);
//          _inputView.jmui_top = kApplicationHeight - _inputView.jmui_height - 64;
//          _messageListTable.jmui_height = [_messageListTable superview].jmui_height - _inputView.jmui_height;
//          [self messageTableScrollToBottom:YES];
//          }
//          
//          - (void)hideMoreView {
//            [UIView animateWithDuration:animationDuration animations:^{
//              _inputView.jmui_top = [_inputView superview].jmui_height - 45;
//              _messageListTable.jmui_height = [_messageListTable superview].jmui_height - 45;
//              }];
//}
//
}
