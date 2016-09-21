//
//  JChatExpandHeader.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/1.
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


internal let ContentOffsetkeyPath = "contentOffset"
class JChatExpandHeader: NSObject {

  weak var scrollView:UIScrollView?
  weak var expandHeadView:UIView?
  var expandHeight:CGFloat?

  override init() {
    self.expandHeight = 0
  }
  
  deinit {
    self.scrollView?.removeObserver(self, forKeyPath: ContentOffsetkeyPath)
    self.scrollView = nil
    self.expandHeadView = nil
  }

  class func expandWithScrollView(_ scrollView: UIScrollView, expandView: UIView) -> JChatExpandHeader {
    let expandHeader: JChatExpandHeader = JChatExpandHeader()
    expandHeader.expandWithScrollView(scrollView, expandView: expandView)
    return expandHeader
  }

  func expandWithScrollView(_ scrollView: UIScrollView, expandView: UIView) {
    self.expandHeight = expandView.frame.height
    self.scrollView = scrollView
    self.scrollView?.contentInset = UIEdgeInsets(top: self.expandHeight!, left: 0, bottom: 0, right: 0)
    self.scrollView?.insertSubview(expandView, at: 0)
    self.scrollView?.addObserver(self, forKeyPath: ContentOffsetkeyPath, options: .new, context: nil)
    self.scrollView?.setContentOffset(CGPoint(x: 0, y: -180), animated: false)
    
    self.expandHeadView = expandView
    self.expandHeadView?.contentMode = .scaleAspectFill
    self.expandHeadView?.clipsToBounds = true

    self.expandHeight = self.expandHeadView!.frame.width
    self.reSizeView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath != ContentOffsetkeyPath { return }
    
    self.scrollViewDidScroll(self.scrollView!)
  }

  
  func reSizeView() {
    self.expandHeadView?.frame = CGRect(x: 0, y: -1 * self.expandHeight!, width: self.expandHeadView!.frame.width, height: self.expandHeight!)
  }
}

extension JChatExpandHeader: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = self.scrollView?.contentOffset.y
    if offsetY < self.expandHeight! * -1 {
      var currentFrame = self.expandHeadView?.frame
      currentFrame?.origin.y = offsetY!
      self.expandHeadView?.frame = currentFrame!
    }
  }
}
