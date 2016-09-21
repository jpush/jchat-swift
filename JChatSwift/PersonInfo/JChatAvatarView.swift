//
//  JChatAvatarView.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/1.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatAvatarView: UIImageView {

  var originImage:UIImage?
  var centerAvatar:UIImageView!
  var nameLable:UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.centerAvatar = UIImageView()
    self.centerAvatar?.layer.cornerRadius = 35
    self.centerAvatar.layer.masksToBounds = true
    self.addSubview(self.centerAvatar!)
    self.centerAvatar?.snp_makeConstraints({ (make) -> Void in
      make.centerX.equalTo(self)
      make.size.equalTo(CGSize(width: 70, height: 70))
      make.bottom.equalTo(self.snp_bottom).offset(-70)
    })
    
    self.nameLable = UILabel()
    self.addSubview(self.nameLable)
    self.nameLable.font = UIFont(name: "helvetica", size: 16)
    self.nameLable.textColor = UIColor.white
    self.nameLable.shadowColor = UIColor.gray
    self.nameLable.textAlignment = .center
    self.nameLable.shadowOffset = CGSize(width: -1.0, height: 1.0)
    
    self.nameLable?.snp_makeConstraints({ (make) -> Void in
      make.centerX.equalTo(self)
      make.left.right.equalTo(self)
      make.bottom.equalTo(self.snp_bottom).offset(-40)
    })
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setDefaultAvatar() {
    self.centerAvatar.image = UIImage(named: "wo_05")
    self.image = nil
    self.backgroundColor = UIColor(netHex: 0xe1e1e1)
  }
  
  func updataNameLable() {
    let userInfo = JMSGUser.myInfo()
    print("\(userInfo.nickname)    \(userInfo.username)")
    if userInfo.nickname == nil || userInfo.nickname == "" {
      self.nameLable.text = userInfo.username
    } else {
      self.nameLable.text = userInfo.nickname
    }
  }

  func setHeadImage(_ originImage:UIImage) {
    var theImage = originImage
    self.centerAvatar.image = theImage

    let imageOrientation = theImage.imageOrientation
    
    if imageOrientation != .up {
      UIGraphicsBeginImageContext(theImage.size);
      theImage.draw(in: CGRect(x: 0, y: 0, width: theImage.size.width, height: theImage.size.height))
      theImage = UIGraphicsGetImageFromCurrentImageContext()!;
      UIGraphicsEndImageContext();
    }
    
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
      let outputImage = UIImage.blur(20, inputImage: theImage)
      DispatchQueue.main.async(execute: { 
        self.image = outputImage
      })
      
    }
    
  }
}
