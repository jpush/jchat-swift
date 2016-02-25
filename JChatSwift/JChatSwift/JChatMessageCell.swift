//
//  JChatMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit



protocol JChatMessageCellDelegate {
  func tapPicture(index:Int, tapView:UIImageView, tableViewCell:UITableViewCell)
  func selectHeadView(model:JChatMessageModel)
}

@objc(JChatMessageCell)
class JChatMessageCell: UITableViewCell {
  internal var headImageView:UIImageView!

  internal var imageMessageContent:UIImageView!
  internal var circleView:UIActivityIndicatorView!
  internal var percentLable:UILabel!
  internal var sendfailImg:UIImageView!
  
//  text UI
  internal var textMessageContent:UILabel!
  
//  voice UI
  internal var voiceBtn:UIImageView!
  internal var unreadStatusView:UIView!
  internal var voiceTimeLable:UILabel!
  
  var delegate:JChatMessageCellDelegate!
  var messageModel:JChatMessageModel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = UITableViewCellSelectionStyle.None
    
    
    self.headImageView = UIImageView()
    self.headImageView.layer.cornerRadius = 22.5
    self.headImageView.layer.masksToBounds = true
    self.contentView.addSubview(self.headImageView)
    
    self.textMessageContent = UILabel()
    self.textMessageContent.numberOfLines = 0
    self.textMessageContent.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    self.contentView.addSubview(textMessageContent)
    self.imageMessageContent = UIImageView()
    self.contentView.addSubview(self.imageMessageContent)
    
    self.voiceBtn = UIImageView()
    self.contentView.addSubview(self.voiceBtn)
    
    self.unreadStatusView = UIView()
    self.unreadStatusView.layer.cornerRadius = 4
    self.unreadStatusView.layer.masksToBounds = true
    self.unreadStatusView.backgroundColor = UIColor.redColor()
    self.contentView.addSubview(self.unreadStatusView)
    
    self.circleView = UIActivityIndicatorView()
    self.circleView.backgroundColor = UIColor.clearColor()
    self.circleView.hidden = true
    self.circleView.hidesWhenStopped = true
    self.contentView.addSubview(self.circleView)

    self.sendfailImg = UIImageView()
    self.sendfailImg.image = UIImage(named: "fail05")
    self.contentView.addSubview(self.sendfailImg)
    
    self.percentLable = UILabel()
    self.imageMessageContent.addSubview(percentLable)
    self.percentLable.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.percentLable)
      make.size.equalTo(CGSize(width: 40, height: 20))
    }

    self.voiceTimeLable = UILabel()
    self.voiceTimeLable.backgroundColor = UIColor.clearColor()
    self.voiceTimeLable.font = UIFont.systemFontOfSize(18)
    self.contentView.addSubview(self.voiceTimeLable)
    
    
    // test
    self.voiceBtn.backgroundColor = UIColor.greenColor()
    self.textMessageContent.backgroundColor = UIColor.blueColor()
  }

  func setCellData(model:JChatMessageModel, delegate:JChatMessageCellDelegate) {
    self.messageModel = model
    self.delegate = delegate
    
    model.message.fromUser.thumbAvatarData { (data, ObjectId, error) -> Void in
      if error == nil {
        let user:JMSGUser = self.messageModel.message.fromUser 
        if ObjectId == user.username {

          if data != nil {
            self.headImageView.image = UIImage(data: data)
          } else {
            self.headImageView.image = UIImage(named: "headDefalt")
          }
          
        } else {
          print("该头像是乱序的头像")
        }
        
      } else {
        print("get thumbAvatar fail")
        self.headImageView.image = UIImage(named: "headDefalt")
      }
      
      switch model.message.contentType {
      case .Text:
        let textContent = model.message.content as! JMSGTextContent
        self.textMessageContent.text = textContent.text
        break
      case .Voice:
        break
      case .Image:
        break
      default:
        break
      }
      if self.messageModel.message.flag == 1 || self.messageModel.message.isReceived {
        self.unreadStatusView.hidden = true
      } else {
        self.unreadStatusView.hidden = false
      }
      
      self.layoutAllViews()
      
    }
  }
  
  func layoutAllViews() {
    let tmpMessage = self.messageModel.message
    switch tmpMessage.status {
    case .Sending:
      fallthrough
    case .SendDraft:
      self.circleView.startAnimating()
      self.sendfailImg.hidden = true
      self.percentLable.hidden = false
      
      if tmpMessage.contentType == .Image {
        self.imageMessageContent.alpha = 0.5
        self.addUpLoadHandler()
      } else {
        self.imageMessageContent.alpha = 1
      }

      break
      
    case .SendFailed:
      fallthrough
    case .SendUploadFailed:
      fallthrough
    case .ReceiveDownloadFailed:
      self.circleView.stopAnimating()
      if tmpMessage.isReceived {
        self.sendfailImg.hidden = false
      } else {
        self.percentLable.hidden = true
      }
      self.imageMessageContent.alpha = 1
      break
    default:
      self.imageMessageContent.alpha = 1
      self.circleView.stopAnimating()
      self.sendfailImg.hidden = true
      self.percentLable.hidden = true
      break
    }
    
    if tmpMessage.contentType != .Voice {
      self.unreadStatusView.hidden = true
    }
    
    switch tmpMessage.contentType {
    case .Unknown:
      
      break
    case .Text:
      self.percentLable.hidden = true
      self.unreadStatusView.hidden = true
      self.voiceTimeLable.hidden = true
      break
    case .Image:
      self.unreadStatusView.hidden = true
      self.voiceTimeLable.hidden = true
      break
    case .Voice:
      self.percentLable.hidden = true
      self.voiceTimeLable.hidden = false
      self.voiceTimeLable.text = "\((tmpMessage.content as! JMSGVoiceContent).duration)"
      if tmpMessage.isReceived {
        self.voiceTimeLable.textAlignment = .Left
      } else {
        self.voiceTimeLable.textAlignment = .Right
      }
      break
    case .Custom:
      break
    case .EventNotification:
      break
    }
  }

  func addUpLoadHandler() {
    (self.messageModel.message.content as! JMSGImageContent).uploadHandler = {[weak weakSelf = self] (percent:Float, msgId:(String!)) in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if weakSelf?.messageModel.message.msgId == msgId! {
          let percent = "\(percent)"
          weakSelf?.percentLable.text = percent
          print("upload percent is \(percent)")
        }
      })
    } as JMSGMediaProgressHandler
    
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}

@objc(JChatRightMessageCell)
class JChatRightMessageCell : JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.headImageView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 45, height: 45))
      make.right.equalTo(self.contentView.snp_right).offset(-5)
      make.top.equalTo(self.contentView).offset(5)
    }

    self.textMessageContent.snp_makeConstraints { (make) -> Void in
      make.right.equalTo(self.headImageView.snp_left).offset(-5)
      make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.6)
      make.top.equalTo(headImageView).offset(10)
      make.bottom.equalTo(-20).priorityLow()
    }

    self.imageMessageContent.snp_makeConstraints { (make) -> Void in
      make.right.equalTo(self.textMessageContent.snp_right).offset(3)
      make.top.equalTo(self.textMessageContent.snp_top).offset(-3)
      make.bottom.equalTo(self.textMessageContent.snp_bottom).offset(3)
      make.left.equalTo(self.textMessageContent.snp_left).offset(-3)
    }
    
    self.voiceBtn.snp_makeConstraints { (make) -> Void in
      make.right.equalTo(self.imageMessageContent.snp_right).offset(-5)
      make.size.equalTo(CGSize(width: 9, height: 16))
      make.centerY.equalTo(self.imageMessageContent.snp_centerY)
    }

    self.unreadStatusView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 8))
      make.top.equalTo(self.imageMessageContent.snp_top).offset(5)
      make.right.equalTo(self.imageMessageContent.snp_left).offset(5)
    }
    
    self.circleView.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.imageMessageContent)
      make.trailing.equalTo(self.imageMessageContent).offset(-5)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    
    self.voiceTimeLable.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.imageMessageContent)
      make.trailing.equalTo(self.imageMessageContent).offset(-5)
      make.size.equalTo(CGSize(width: 40, height: 20))
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

@objc(JChatLeftMessageCell)
class JChatLeftMessageCell:JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.headImageView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 45, height: 45))
      make.leading.equalTo(self.contentView).offset(5)
      make.top.equalTo(self.contentView).offset(5)
    }
    
    self.textMessageContent.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.headImageView.snp_right).offset(5)
      make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.6)
      make.top.equalTo(headImageView).offset(10)
      make.bottom.equalTo(self.contentView).offset(-20).priorityLow()
    }
    
    self.imageMessageContent.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.headImageView.snp_right).offset(-10)
      make.top.equalTo(headImageView).offset(10)
      make.bottom.equalTo(self.textMessageContent.snp_bottom).offset(10)
    }
    
    self.voiceBtn.snp_makeConstraints { (make) -> Void in
      make.leading.equalTo(self.imageMessageContent).offset(5)
      make.size.equalTo(CGSize(width: 9, height: 16))
      make.centerY.equalTo(self.imageMessageContent.snp_centerY)
    }
    
    self.unreadStatusView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 8))
      make.top.equalTo(self.imageMessageContent.snp_top).offset(5)
      make.right.equalTo(self.imageMessageContent.snp_left).offset(5)
    }
    
    self.circleView.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.imageMessageContent)
      make.leading.equalTo(self.imageMessageContent).offset(5)
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
    
    self.voiceTimeLable.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.imageMessageContent)
      make.leading.equalTo(self.imageMessageContent).offset(5)
      make.size.equalTo(CGSize(width: 40, height: 20))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }

}
