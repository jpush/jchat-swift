//
//  JChatExpandHeader.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/1.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

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

  class func expandWithScrollView(scrollView: UIScrollView, expandView: UIView) -> JChatExpandHeader {
    let expandHeader: JChatExpandHeader = JChatExpandHeader()
    expandHeader.expandWithScrollView(scrollView, expandView: expandView)
    return expandHeader
  }

  func expandWithScrollView(scrollView: UIScrollView, expandView: UIView) {
    self.expandHeight = CGRectGetHeight(expandView.frame)
    self.scrollView = scrollView
    self.scrollView?.contentInset = UIEdgeInsets(top: self.expandHeight!, left: 0, bottom: 0, right: 0)
    self.scrollView?.insertSubview(expandView, atIndex: 0)
    self.scrollView?.addObserver(self, forKeyPath: ContentOffsetkeyPath, options: .New, context: nil)
    self.scrollView?.setContentOffset(CGPoint(x: 0, y: -180), animated: false)
    
    self.expandHeadView = expandView
    self.expandHeadView?.contentMode = .ScaleAspectFill
    self.expandHeadView?.clipsToBounds = true

    self.expandHeight = CGRectGetWidth(self.expandHeadView!.frame)
    self.reSizeView()
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if keyPath != ContentOffsetkeyPath { return }
    
    self.scrollViewDidScroll(self.scrollView!)
  }

  
  func reSizeView() {
    self.expandHeadView?.frame = CGRectMake(0, -1 * self.expandHeight!, self.expandHeadView!.frame.width, self.expandHeight!)
  }
}

extension JChatExpandHeader: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let offsetY = self.scrollView?.contentOffset.y
    if offsetY < self.expandHeight! * -1 {
      var currentFrame = self.expandHeadView?.frame
      currentFrame?.origin.y = offsetY!
      self.expandHeadView?.frame = currentFrame!
    }
  }
}
