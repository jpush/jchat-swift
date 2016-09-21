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
//  private static var __once: () = {
//      Static.instance = JChatAlertViewManager()
//    }()
  var alertView:UIView!
  var alertSendImage:UIImage?
  
  weak var delegate:JChatBubbleAlertViewDelegate?
  var isShowing:Bool!
  
//  class var sharedInstance: JChatAlertViewManager {
//    struct Static {
//      static var onceToken: Int = 0
//      static var instance: JChatAlertViewManager? = nil
//    }
//    _ = JChatAlertViewManager.__once
//    return Static.instance!
//  }
  static let sharedInstance = JChatAlertViewManager()
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
    bubbleImg = bubbleImg?.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 10, 30, 64), resizingMode: .tile)
    bubbleView.image = bubbleImg
    self.alertView.addSubview(bubbleView)
    bubbleView.snp.makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.alertView)
    }
    
    let fristBtn = UIButton()
    self.alertView.addSubview(fristBtn)
    fristBtn.setBackgroundColor(UIColor(netHex: 0x4880d7), forState: .highlighted)
    fristBtn.setTitle("发起群聊", for: UIControlState())
    fristBtn.snp.makeConstraints { (make) -> Void in
      make.left.equalTo(self.alertView).offset(10)
      make.right.equalTo(self.alertView).offset(-10)
      make.height.equalTo(30)
      make.top.equalTo(self.alertView).offset(20)
    }
    fristBtn.addTarget(self, action: #selector(JChatAlertViewManager.clickFristBtn), for: .touchUpInside)
    
    
    let secondBtn = UIButton()
    self.alertView.addSubview(secondBtn)
    secondBtn.setBackgroundColor(UIColor(netHex: 0x4880d7), forState: .highlighted)
    secondBtn.setTitle("添加朋友", for: UIControlState())
    secondBtn.snp.makeConstraints { (make) -> Void in
      make.left.equalTo(self.alertView).offset(10)
      make.right.equalTo(self.alertView).offset(-10)
      make.height.equalTo(30)
      make.top.equalTo(fristBtn.snp.bottom).offset(10)
    }
    secondBtn.addTarget(self, action: #selector(JChatAlertViewManager.clickSecondBtn), for: .touchUpInside)
    view.addSubview(self.alertView)
    self.alertView.snp.makeConstraints { (make) -> Void in
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
  func showPastedImageMessageAlert(_ preparedImage: UIImage) {
    self.alertSendImage = preparedImage
    self.alertView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    
    let appDelegate = UIApplication.shared.delegate
    let myWindow = UIApplication.shared.windows.last
    myWindow?.windowLevel = UIWindowLevelAlert
    myWindow?.addSubview(self.alertView)
    
    self.alertView.snp.makeConstraints { (make) in
      make.right.equalTo(myWindow!)
            make.top.equalTo(myWindow!)
            make.left.equalTo(myWindow!)
            make.bottom.equalTo(myWindow!)
    }
    
    let alertHub = UIView()
    alertHub.backgroundColor = UIColor.white
    alertHub.layer.cornerRadius = 5
    alertHub.layer.masksToBounds = true
    self.alertView.addSubview(alertHub)
    alertHub.snp.makeConstraints { (make) in
      make.center.equalTo(self.alertView);
      make.size.equalTo(CGSize(width: 280, height: 235));
    }
    
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    imgView.image = self.alertSendImage
    alertHub.addSubview(imgView)
    imgView.snp.makeConstraints { (make) in
            make.top.equalTo(alertHub).offset(15);
            make.left.equalTo(alertHub).offset(15);
            make.right.equalTo(alertHub).offset(-15);
            make.bottom.equalTo(alertHub).offset(-65);
    }

    let cancelBtn = UIButton()
    cancelBtn.backgroundColor = UIColor.white
    cancelBtn.setTitleColor(UIColor.black, for: UIControlState())
    cancelBtn.layer.borderWidth = 0.5
    cancelBtn.layer.borderColor = UIColor.gray.cgColor
    cancelBtn.setTitle("取消", for: UIControlState())
    alertHub.addSubview(cancelBtn)
    cancelBtn.snp.makeConstraints { (make) in
      make.height.equalTo(50);
      make.width.equalTo(140);
      make.left.equalTo(alertHub).offset(-1);
      make.bottom.equalTo(alertHub).offset(0);
    }
    cancelBtn.addTarget(self, action: #selector(self.clickCancel), for: .touchUpInside)

    let sendBtn = UIButton()
    sendBtn.backgroundColor = UIColor.white
    sendBtn.setTitleColor(UIColor.black, for: UIControlState())
    sendBtn.layer.borderWidth = 0.5
    sendBtn.layer.borderColor = UIColor.gray.cgColor
    sendBtn.setTitle("确定", for: UIControlState())
    alertHub.addSubview(sendBtn)
    sendBtn.snp.makeConstraints { (make) in
      make.height.equalTo(50);
      make.width.equalTo(142);
      make.right.equalTo(alertHub).offset(0.5);
      make.bottom.equalTo(alertHub).offset(0);
    }
    sendBtn.addTarget(self, action: #selector(self.clickSendImage), for: .touchUpInside)
    
  }
  
  func clickCancel() {
    self.hidenAll()
  }
  
  func clickSendImage() {
    NotificationCenter.default.post(name: Notification.Name(rawValue: kAlertToSendImage), object: self.alertSendImage)
    self.hidenAll()
  }
}
