//
//  JChatAlertViewManager.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/2.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

let kAlertToSendImage = "kAlertToSendImage"

@objc(JChatBubbleAlertViewDelegate)
protocol JChatBubbleAlertViewDelegate {
  func clickBubbleFristBtn()
  func clickBubbleSecondBtn()
}

class JChatAlertViewManager: NSObject {
  var alertView:UIView!
  var alertSendImage:UIImage?
  
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
    fristBtn.addTarget(self, action: #selector(JChatAlertViewManager.clickFristBtn), forControlEvents: .TouchUpInside)
    
    
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
    secondBtn.addTarget(self, action: #selector(JChatAlertViewManager.clickSecondBtn), forControlEvents: .TouchUpInside)
    view.addSubview(self.alertView)
    self.alertView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 100, height: 100))
      make.right.equalTo(view)
      make.top.equalTo(view).offset(1)
    }
  }
  
  func clickFristBtn() {
    self.delegate?.clickBubbleFristBtn()
  }
  
  func clickSecondBtn() {
    self.delegate?.clickBubbleSecondBtn()
  }
  
  func hidenAll() {
    self.isShowing = false
    self.alertView.removeFromSuperview()
    self.alertView = UIView()
  }
}

// extension to paste image alert
extension JChatAlertViewManager {
  func showPastedImageMessageAlert(preparedImage: UIImage) {
    self.alertSendImage = preparedImage
    self.alertView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    
    let appDelegate = UIApplication.sharedApplication().delegate
    let myWindow = UIApplication.sharedApplication().windows.last
    myWindow?.windowLevel = UIWindowLevelAlert
    myWindow?.addSubview(self.alertView)
    
    self.alertView.snp_makeConstraints { (make) in
      make.right.equalTo(myWindow!)
            make.top.equalTo(myWindow!)
            make.left.equalTo(myWindow!)
            make.bottom.equalTo(myWindow!)
    }
    
    let alertHub = UIView()
    alertHub.backgroundColor = UIColor.whiteColor()
    alertHub.layer.cornerRadius = 5
    alertHub.layer.masksToBounds = true
    self.alertView.addSubview(alertHub)
    alertHub.snp_makeConstraints { (make) in
      make.center.equalTo(self.alertView);
      make.size.equalTo(CGSizeMake(280, 235));
    }
    
    let imgView = UIImageView()
    imgView.contentMode = .ScaleAspectFit
    imgView.image = self.alertSendImage
    alertHub.addSubview(imgView)
    imgView.snp_makeConstraints { (make) in
            make.top.equalTo(alertHub).offset(15);
            make.left.equalTo(alertHub).offset(15);
            make.right.equalTo(alertHub).offset(-15);
            make.bottom.equalTo(alertHub).offset(-65);
    }

    let cancelBtn = UIButton()
    cancelBtn.backgroundColor = UIColor.whiteColor()
    cancelBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
    cancelBtn.layer.borderWidth = 0.5
    cancelBtn.layer.borderColor = UIColor.grayColor().CGColor
    cancelBtn.setTitle("取消", forState: .Normal)
    alertHub.addSubview(cancelBtn)
    cancelBtn.snp_makeConstraints { (make) in
      make.height.equalTo(50);
      make.width.equalTo(140);
      make.left.equalTo(alertHub).offset(-1);
      make.bottom.equalTo(alertHub).offset(0);
    }
    cancelBtn.addTarget(self, action: #selector(self.clickCancel), forControlEvents: .TouchUpInside)

    let sendBtn = UIButton()
    sendBtn.backgroundColor = UIColor.whiteColor()
    sendBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
    sendBtn.layer.borderWidth = 0.5
    sendBtn.layer.borderColor = UIColor.grayColor().CGColor
    sendBtn.setTitle("确定", forState: .Normal)
    alertHub.addSubview(sendBtn)
    sendBtn.snp_makeConstraints { (make) in
      make.height.equalTo(50);
      make.width.equalTo(142);
      make.right.equalTo(alertHub).offset(0.5);
      make.bottom.equalTo(alertHub).offset(0);
    }
    sendBtn.addTarget(self, action: #selector(self.clickSendImage), forControlEvents: .TouchUpInside)
    
  }
  
  func clickCancel() {
    self.hidenAll()
  }
  
  func clickSendImage() {
    NSNotificationCenter.defaultCenter().postNotificationName(kAlertToSendImage, object: self.alertSendImage)
    self.hidenAll()
  }
}
