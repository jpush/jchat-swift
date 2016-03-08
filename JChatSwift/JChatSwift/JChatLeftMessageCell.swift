//
//  JChatLeftMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatLeftMessageCell)
class JChatLeftMessageCell:JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.messageBubble?.maskBackgroupImage = UIImage(named: "otherChatBg")!.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 28, 20))
    self.messageBubble?.contentMode = .ScaleToFill
    self.messageBubble?.layer.masksToBounds = true
    
    self.messageBubble?.snp_makeConstraints(closure: { (make) -> Void in
      make.right.equalTo(self.textMessageContent.snp_right).offset(5)
      make.top.equalTo(self.textMessageContent.snp_top).offset(-5)
      make.bottom.equalTo(self.textMessageContent.snp_bottom).offset(5)
      make.left.equalTo(self.textMessageContent.snp_left).offset(-15)
    })
    
    self.headImageView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 45, height: 45))
      make.leading.equalTo(self.contentView).offset(5)
      make.top.equalTo(self.contentView).offset(5)
    }
    
    self.textMessageContent.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.headImageView.snp_right).offset(20)
      make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.6)
      make.top.equalTo(headImageView).offset(10)
      make.bottom.equalTo(self.contentView).offset(-20).priorityLow()
    }
    
    self.voiceBtn.snp_makeConstraints { (make) -> Void in
      make.leading.equalTo(self.messageBubble!).offset(15)
      make.size.equalTo(CGSize(width: 9, height: 16))
      make.centerY.equalTo(self.messageBubble!.snp_centerY)
    }
    
    self.unreadStatusView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 8))
      make.top.equalTo(self.messageBubble!.snp_top).offset(5)
      make.right.equalTo(self.messageBubble!.snp_left).offset(5)
    }
    
    self.circleView.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.messageBubble!)
      make.leading.equalTo(self.voiceTimeLable!).offset(5)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    
    self.voiceTimeLable.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.messageBubble!)
      make.leading.equalTo(self.messageBubble!).offset(5)
      make.size.equalTo(CGSize(width: 40, height: 20))
    }
  }
  
  override func layoutAllViews() {
    super.layoutAllViews()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }
  
}

