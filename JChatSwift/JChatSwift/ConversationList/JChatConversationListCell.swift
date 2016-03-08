//
//  JChatConversationListCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatConversationListCell)
class JChatConversationListCell: UITableViewCell {

  var conversationAvatar:UIImageView!
  var title:UILabel!
  var lastMessage:UILabel!
  var timeLable:UILabel!
  var unReadCount:UILabel!
  var conversationID:String?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.conversationAvatar = UIImageView()
    self.conversationAvatar.layer.cornerRadius = 22.5
    self.conversationAvatar.layer.masksToBounds = true
    self.contentView.addSubview(self.conversationAvatar)
    self.conversationAvatar.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(5)
      make.bottom.equalTo(self.contentView).offset(-5)
      make.width.equalTo(45)
      make.height.equalTo(145)
      make.left.equalTo(self.contentView).offset(7)
    }

    self.timeLable = UILabel()
    self.contentView.addSubview(self.timeLable)
    self.timeLable.textAlignment = .Right
    self.timeLable.font = UIFont.systemFontOfSize(16)
    self.timeLable.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(7)
      make.width.equalTo(100)
      make.height.equalTo(11)
      make.right.equalTo(self.contentView)
    }
    
    self.title = UILabel()
    self.contentView.addSubview(self.title)
    self.title.font = UIFont.systemFontOfSize(16)
    self.title.textColor = UIColor(netHex: 0x3f80dd)
    self.title.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.contentView).offset(7)
      make.left.equalTo(self.conversationAvatar.snp_right).offset(10)
      make.height.equalTo(17)
      make.right.equalTo(self.timeLable.snp_left)
    }
    
    self.lastMessage = UILabel()
    self.contentView.addSubview(self.lastMessage)
    self.lastMessage.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(21)
      make.bottom.equalTo(self.contentView).offset(-5)
      make.top.equalTo(self.title.snp_bottom).offset(3)
      make.left.equalTo(self.conversationAvatar.snp_right).offset(10)
    }
    
    self.unReadCount = UILabel()
    self.contentView.addSubview(unReadCount)
    self.unReadCount.textColor = UIColor.whiteColor()
    self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    self.unReadCount.layer.borderWidth = 1
    self.unReadCount.layer.borderColor = UIColor.whiteColor().CGColor
    self.unReadCount.layer.cornerRadius = 11
    self.unReadCount.layer.masksToBounds = true
    self.unReadCount.textAlignment = .Center
    self.unReadCount.font = UIFont.systemFontOfSize(11)
    self.unReadCount.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 22, height: 22))
      make.right.equalTo(self.conversationAvatar).offset(3)
      make.top.equalTo(self.conversationAvatar).offset(-3)
    }
  }
  
  func setCellData(conversation:JMSGConversation) {
    self.conversationID = self.conversationIdWithConversation(conversation)
    self.title.text = conversation.title

    conversation.avatarData { (data, ObjectId, error) -> Void in
      if error == nil {
        if data != nil {
          self.conversationAvatar.image = UIImage(data: data)
        } else {
          switch conversation.conversationType {
          case .Single:
            self.conversationAvatar.image = UIImage(named: "headDefalt")
            break
          case .Group:
            self.conversationAvatar.image = UIImage(named: "talking_icon_group")
            break
          }
        }
      } else { print("get avatar fail") }
    }

    if conversation.unreadCount?.integerValue > 0 {
      self.unReadCount.hidden = false
      self.unReadCount.text = "\(conversation.unreadCount!)"
    } else {
      self.unReadCount.hidden = true
    }

    if conversation.latestMessage?.timestamp != nil {
      let time = conversation.latestMessage?.timestamp.doubleValue
      self.timeLable.text = NSString.getFriendlyDateString(time!, forConversation: true)
    } else {
      self.timeLable.text = ""
    }

    self.lastMessage.text = conversation.latestMessageContentText()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func conversationIdWithConversation(conversation: JMSGConversation) -> String {
    var conversationid = ""
    switch conversation.conversationType {
    case .Single:
      let user = conversation.target as! JMSGUser
      conversationid = "\(user.username)_\(conversation.conversationType)"
      break
    case .Group:
      let group = conversation.target as! JMSGGroup
      conversationid = "\(group.gid)_\(conversation.conversationType)"
      break
    }
    return conversationid
  }

  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    }
  }
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)

    if highlighted {
      self.unReadCount.backgroundColor = UIColor(netHex: 0xfa3e32)
    }
  }

}
