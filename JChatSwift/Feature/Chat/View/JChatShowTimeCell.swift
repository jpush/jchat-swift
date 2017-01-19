//
//  JChatShowTimeCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/18.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatShowTimeCell)
class JChatShowTimeCell: UITableViewCell {
  var timeLable:UILabel!

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.backgroundColor = UIColor.clear
    
    self.timeLable = UILabel()
    self.contentView.addSubview(self.timeLable)
    self.timeLable.layer.cornerRadius = 2
    self.timeLable.textColor = UIColor.gray
    self.textLabel?.font = UIFont.systemFont(ofSize: 14)
    self.textLabel?.textAlignment = .center
    self.timeLable.numberOfLines = 0
    self.timeLable.font = UIFont.systemFont(ofSize: 13)
    self.timeLable.textAlignment = .center
    self.timeLable.snp.makeConstraints { (make) -> Void in
      make.center.equalTo(self.contentView)
      make.top.equalTo(self.contentView).offset(0)
      make.bottom.equalTo(self.contentView).offset(0)
      make.right.equalTo(self.contentView).offset(-20)
      make.left.equalTo(self.contentView).offset(20)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func layoutModel(_ model:JChattimeModel) {
    self.timeLable.text = NSString.getFriendlyDateString(model.messageTime.doubleValue, forConversation: false)
    print("did layoutModel")
  }
  
  func layoutWithNotifcation(_ model:JChatMessageModel) {
    if model.message.contentType == .eventNotification {
      let eventContent = model.message.content as! JMSGEventContent
      self.timeLable.text = eventContent.showEventNotification()
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
