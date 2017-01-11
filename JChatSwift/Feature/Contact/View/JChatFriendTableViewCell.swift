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
  @IBOutlet weak var selectBtn: UIButton!
  @IBOutlet weak var avatarLeadSuperContrain: NSLayoutConstraint!
  weak var friend:JChatFriendModel?
  
  var selectCallBack:CompletionBlock?
  var delSelectCallBack:CompletionBlock?
  
  var username:String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupData(model:JChatFriendModel, isSelectModel: Bool, selectDefaults: [String] ,selectCallBack: CompletionBlock?, delSelectCallBack: CompletionBlock?) {
    
    self.friend = model
    self.selectCallBack = selectCallBack
    self.delSelectCallBack = delSelectCallBack
    self.avatar.image = UIImage(named: "headDefalt")
    self.usernameLable.text = self.friend?.user?.displayName()
    
    self.selectBtn.isEnabled = true
    if isSelectModel == true {
      self.selectBtn.isHidden = false
      self.avatarLeadSuperContrain.constant = 33
      self.selectBtn.isSelected = model.isSelected
      self.selectionStyle = .none
    } else {
      self.selectBtn.isHidden = true
      self.avatarLeadSuperContrain.constant = 7
    }
    
    if selectDefaults.contains((model.user?.username)!) {
      self.selectBtn.isEnabled = false
    }
    self.friend?.user?.thumbAvatarData({[weak weakSelf = self] (avatarData, username, error) in
      
      if error == nil {
        if username != weakSelf?.friend?.user?.username {
          return // 乱序的头像
        }
        if avatarData != nil {
          self.avatar.image = UIImage(data: avatarData!)
        }
      } else {
      }
    })
    
  }
  
  @IBAction func clickSelectBtn(_ sender: Any) {
    let btn = sender as! UIButton
    btn.isSelected = !(btn.isSelected)
    self.friend?.isSelected = btn.isSelected
    
    if btn.isSelected {
      self.selectCallBack?(self.friend)
    } else {
      self.delSelectCallBack?(self.friend)
    }
  }
  
  func setupOriginData(headImage: UIImage, title: String) {
    self.friend = nil
    self.avatar.image = headImage
    self.usernameLable.text = title
    self.selectBtn.isHidden = true
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
