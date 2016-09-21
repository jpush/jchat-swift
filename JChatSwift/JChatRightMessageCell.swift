//
//  JChatRightMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatRightMessageCell)
class JChatRightMessageCell : JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.messageBubble?.maskBackgroupImage = UIImage(named: "mychatBg")!.resizableImage(withCapInsets: UIEdgeInsetsMake(28, 20, 28, 20))
    self.messageBubble?.contentMode = .scaleToFill
    self.messageBubble?.layer.masksToBounds = true

    self.headImageView.snp.makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 45, height: 45))
      make.right.equalTo(self.contentView.snp.right).offset(-5)
      make.top.equalTo(self.contentView).offset(5)
    }
    
    self.textMessageContent.preferredMaxLayoutWidth = self.contentView.bounds.width * 0.6
    self.textMessageContent.snp.makeConstraints { (make) -> Void in
      make.right.equalTo(self.headImageView.snp.left).offset(-20)
      make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.6)
      make.top.equalTo(headImageView).offset(10)
      make.bottom.equalTo(self.contentView).offset(-20)
    }
    
    self.messageBubble!.snp.makeConstraints { (make) -> Void in
      make.right.equalTo(self.textMessageContent.snp.right).offset(15)
      make.top.equalTo(self.textMessageContent.snp.top).offset(-5)
      make.bottom.equalTo(self.textMessageContent.snp.bottom).offset(5)
      make.left.equalTo(self.textMessageContent.snp.left).offset(-5)
    }

    
    self.voiceBtn.snp.makeConstraints { (make) -> Void in
      make.right.equalTo(self.messageBubble!.snp.right).offset(-15)
      make.size.equalTo(CGSize(width: 9, height: 16))
      make.centerY.equalTo(self.messageBubble!.snp.centerY)
    }
    
    self.unreadStatusView.snp.makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 8))
      make.top.equalTo(self.messageBubble!.snp.top).offset(5)
      make.right.equalTo(self.messageBubble!.snp.left).offset(-5)
    }
    
    self.circleView.snp.makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.messageBubble!)
      make.right.equalTo(self.voiceTimeLable!.snp.left).offset(-5)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    
    self.voiceTimeLable.snp.makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.messageBubble!)
      make.right.equalTo(self.messageBubble!.snp.left).offset(-5)
//      make.size.equalTo(CGSize(width: 40, height: 20))
    }
  }
  
  override func layoutAllViews() {
    super.layoutAllViews()

    switch messageModel.message.contentType {
    case .image:
      self.messageBubble?.snp.remakeConstraints({ (make) -> Void in
        make.right.equalTo(self.textMessageContent.snp.right).offset(15)
        make.top.equalTo(self.textMessageContent.snp.top).offset(-5)
        make.bottom.equalTo(self.textMessageContent.snp.bottom).offset(5)
        make.left.equalTo(self.textMessageContent.snp.left).offset(-5)
        make.size.equalTo(CGSize(width: self.messageModel.imageSize!.width, height: self.messageModel.imageSize!.height))
      })
      break
    case .voice:
      self.messageBubble?.snp.remakeConstraints({ (make) in
        make.right.equalTo(self.textMessageContent.snp.right).offset(15)
        make.top.equalTo(self.textMessageContent.snp.top).offset(-5)
        make.bottom.equalTo(self.textMessageContent.snp.bottom).offset(5)
        make.left.equalTo(self.textMessageContent.snp.left).offset(-5)
        make.size.equalTo(CGSize(width: CGFloat(messageModel.voiceBubbleWidth!), height: 45))
      })
      break
    case .text:
      self.messageBubble?.snp.remakeConstraints({ (make) -> Void in
        make.right.equalTo(self.textMessageContent.snp.right).offset(15)
        make.top.equalTo(self.textMessageContent.snp.top).offset(-5)
        make.bottom.equalTo(self.textMessageContent.snp.bottom).offset(5)
        make.left.equalTo(self.textMessageContent.snp.left).offset(-5)
      })
      break
    default:
      break
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



