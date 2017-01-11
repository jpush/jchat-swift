//
//  JChatInvitationTableViewCell.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/4.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JChatInvitationTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImage: UIImageView!
  
  @IBOutlet weak var username: UILabel!
  
  @IBOutlet weak var reason: UILabel!
  
  @IBOutlet weak var invitationTypeLabel: UILabel!
  
  @IBOutlet weak var acceptBtn: UIButton!
  
  @IBOutlet weak var rejectBtn: UIButton!

  var invitationModel:JChatInvitationModel!
  
  var clickAcceptCallback:CompletionBlock?
  var clickRejectCallback:CompletionBlock?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.username.textColor = UIColor(netHex: 0x131313)
    self.reason.textColor = UIColor(netHex: 0x7d7d7d)
    self.invitationTypeLabel.textColor = UIColor(netHex: 0x7d7d7d)
    
  }
  
  open func setData(with model: JChatInvitationModel,acceptCallback: CompletionBlock?, rejectCallback: CompletionBlock?) {
    self.invitationModel = model
    self.clickAcceptCallback = acceptCallback
    self.clickRejectCallback = rejectCallback
    
    self.username.text = model.user?.displayName()
    self.reason.text = model.reason
    
    switch model.type! {
    case .waitingVerification:
      self.layoutToWaitingFriendVertification(with: model)
      break
    case .receiveFriendInvitation:
      self.layoutToReceiveInvitation(with: model)
      break
    case .acceptedFriendInvitation:
      self.layoutToacceptedInvitation(with: model)
      break
    case .declinedFriendInvitation:
      self.layoutTodelinedInvitation(with: model)
      break
    default:
      break
    }
    
    self.avatarImage.image = UIImage(named: "headDefalt")
    model.user?.thumbAvatarData({ (avatarData, username, error) in
      if error != nil { return }
      
      if avatarData == nil { return}
      
      if username != self.invitationModel.user?.username { return}
      
      self.avatarImage.image = UIImage(data: avatarData!)
    })
  }
  
  func layoutToWaitingFriendVertification(with model: JChatInvitationModel) {
    self.acceptBtn.isHidden = true
    self.rejectBtn.isHidden = true
    self.invitationTypeLabel.isHidden = false
    self.invitationTypeLabel.text = "等待确认"
  }
  
  func layoutToReceiveInvitation(with model: JChatInvitationModel) {
    self.acceptBtn.isHidden = false
    self.rejectBtn.isHidden = false
    self.invitationTypeLabel.isHidden = true
  }

  func layoutToacceptedInvitation(with model: JChatInvitationModel) {
    self.acceptBtn.isHidden = true
    self.rejectBtn.isHidden = true
    self.invitationTypeLabel.isHidden = false
    self.invitationTypeLabel.text = "对方已接受你的好友请求"
  }
  
  func layoutTodelinedInvitation(with model: JChatInvitationModel) {
    self.acceptBtn.isHidden = true
    self.rejectBtn.isHidden = true
    self.invitationTypeLabel.isHidden = false
    self.invitationTypeLabel.text = "对方已拒绝你的好友邀请"
  }
  
  
  @IBAction func clickToAcceptInvitation(_ sender: Any) {
    JMSGFriendManager.acceptInvitation(withUsername: self.invitationModel.user?.username, appKey: JMSSAGE_APPKEY) { (user, error) in
//      if error != nil { return }
      
      JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: (self.invitationModel.user?.username)!, reason: "", invitationType: JChatFriendEventNotificationType.acceptedFriendInvitation.rawValue)
    // TODO: update model and UI
      self.invitationModel.type = JChatFriendEventNotificationType.acceptedFriendInvitation
      self.layoutToacceptedInvitation(with: self.invitationModel)
      self.clickAcceptCallback!(self.invitationModel.user?.username)
    }
  }
  
  @IBAction func clickToDeclinedInvitation(_ sender: Any) {
    // TODO: add reason
    JMSGFriendManager.rejectInvitation(withUsername: self.invitationModel.user?.username, appKey: JMSSAGE_APPKEY, reason:"") { (user, error) in
//      if error != nil { return }
      
      JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: (self.invitationModel.user?.username)!, reason: "", invitationType: JChatFriendEventNotificationType.declinedFriendInvitation.rawValue)
      self.invitationModel.type = JChatFriendEventNotificationType.declinedFriendInvitation
      self.clickRejectCallback!(self.invitationModel.user?.username)
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
