//
//  JChatFriendTableViewCell.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/22.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JChatFriendTableViewCell: UITableViewCell {

  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var usernameLable: UILabel!
  weak var friend:JChatFriendModel?
  var username:String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func setupData(model:JChatFriendModel) {
    self.friend = model
    self.avatar.image = UIImage(named: "headDefalt")
    self.usernameLable.text = self.friend?.user?.displayName()
    self.friend?.user?.thumbAvatarData({[weak weakSelf = self] (avatarData, username, error) in
      
      if error == nil {
        if username != weakSelf?.friend?.user?.username {
//          乱序的头像
          return
        }
        if avatarData != nil {
          self.avatar.image = UIImage(data: avatarData!)
        }
      } else {
      }
    })
    
  }
  
  func setupOriginData(headImage: UIImage, title: String) {
    self.friend = nil
    self.avatar.image = headImage
    self.usernameLable.text = title
  }
  
  func setupData(with user:JMSGUser) {
    self.username = user.username
    self.avatar.image = UIImage(named: "headDefalt")
    self.usernameLable.text = user.displayName()
    self.friend?.user?.thumbAvatarData({[weak weakSelf = self] (avatarData, username, error) in
      if username != weakSelf?.username {
        return
      }
      
      if error == nil {
        if avatarData != nil {
          weakSelf?.avatar.image = UIImage(data: avatarData!)
        }
      } else {
      }
    })
  }
}
