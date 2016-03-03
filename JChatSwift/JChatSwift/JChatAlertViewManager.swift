//
//  JChatAlertViewManager.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/2.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
@objc(JChatBubbleAlertViewDelegate)
protocol JChatBubbleAlertViewDelegate {
  func clickBubbleFristBtn()
  func clickBubbleSecondBtn()
}

class JChatAlertViewManager: NSObject {
  var alertView:UIView!
  weak var delegate:JChatBubbleAlertViewDelegate?
  var isShowing:Bool!
  
  class var sharedInstance: JChatAlertViewManager {
    struct Static {
      static var onceToken: dispatch_once_t = 0
      static var instance: JChatAlertViewManager? = nil
    }
    dispatch_once(&Static.onceToken) {
      Static.instance = JChatAlertViewManager()
    }
    return Static.instance!
  }

  override init() {
    super.init()
    self.alertView = UIView()
    self.isShowing = false
  }

  func showBubbleBtn(inView view: UIView, delegate: JChatBubbleAlertViewDelegate) {
    
    self.isShowing = true
    self.delegate = delegate
    
    let bubbleView = UIImageView()
    var bubbleImg = UIImage(named: "frame")
    bubbleImg = bubbleImg?.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 10, 30, 64), resizingMode: .Tile)
    bubbleView.image = bubbleImg
    self.alertView.addSubview(bubbleView)
    bubbleView.snp_makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.alertView)
    }
    
    let fristBtn = UIButton()
    self.alertView.addSubview(fristBtn)
    fristBtn.setBackgroundColor(UIColor(netHex: 0x4880d7), forState: .Highlighted)
    fristBtn.setTitle("发起群聊", forState: .Normal)
    fristBtn.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.alertView).offset(10)
      make.right.equalTo(self.alertView).offset(-10)
      make.height.equalTo(30)
      make.top.equalTo(self.alertView).offset(20)
    }
    fristBtn.addTarget(self, action: Selector("clickFristBtn"), forControlEvents: .TouchUpInside)
    
    
    let secondBtn = UIButton()
    self.alertView.addSubview(secondBtn)
    secondBtn.setBackgroundColor(UIColor(netHex: 0x4880d7), forState: .Highlighted)
    secondBtn.setTitle("添加朋友", forState: .Normal)
    secondBtn.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.alertView).offset(10)
      make.right.equalTo(self.alertView).offset(-10)
      make.height.equalTo(30)
      make.top.equalTo(fristBtn.snp_bottom).offset(10)
    }
    secondBtn.addTarget(self, action: Selector("clickSecondBtn"), forControlEvents: .TouchUpInside)
    view.addSubview(self.alertView)
    self.alertView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 100, height: 100))
      make.right.equalTo(view)
      make.top.equalTo(view).offset(1)
    }
  }
  
  @objc func clickFristBtn() {
    self.delegate?.clickBubbleFristBtn()
  }
  
  @objc func clickSecondBtn() {
    self.delegate?.clickBubbleSecondBtn()
  }
  
  func hidenAll() {
    self.isShowing = false
    self.alertView.removeFromSuperview()
    self.alertView = UIView()
  }
}
