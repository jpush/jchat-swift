//
//  JCHATMemberCollectionCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JCHATMemberCollectionCell)
class JCHATMemberCollectionCell: UICollectionViewCell {

  @IBOutlet weak var deleteLableBtn: UIButton!
  @IBOutlet weak var avatarImg: UIImageView!
  @IBOutlet weak var userNameLable: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.avatarImg.layer.masksToBounds = true
    self.deleteLableBtn.layer.masksToBounds = true
    self.avatarImg.layer.cornerRadius = self.avatarImg.bounds.size.height / 2
    self.avatarImg.contentMode = .scaleAspectFill
    self.deleteLableBtn.layer.cornerRadius = 10
  }

  func setCellData(_ user:JMSGUser, isDeleting: Bool) {
    self.userNameLable.text = user.displayName()
    self.deleteLableBtn.isHidden = !isDeleting
    
    user.thumbAvatarData { (data, objectId, error) -> Void in
      if error == nil {
        if data == nil {
          self.avatarImg.image = UIImage(named: "headDefalt")
        } else {
          self.avatarImg.image = UIImage(data: data!)
        }
      } else {
        print("get thumbAvatar fail")
      }
    }
  }

  func setDeleteMember() {
    self.userNameLable.text = ""
    self.deleteLableBtn.isHidden = true
    self.avatarImg.image = UIImage(named: "deleteMan")
  }
  
  func setAddMember() {
    self.userNameLable.text = ""
    self.deleteLableBtn.isHidden = true
    self.avatarImg.image = UIImage(named: "addMan")
  }
}
