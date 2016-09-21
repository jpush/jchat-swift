//
//  JChatMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

protocol JChatMessageCellDelegate:NSObjectProtocol {
  func selectHeadView(_ model:JChatMessageModel)
  
  //  picture
  func tapPicture(_ messageModel:JChatMessageModel, tableViewCell:UITableViewCell)

  //  voice
  func getContinuePlay(_ cell:UITableViewCell)

  func successionalPlayVoice(_ cell:UITableViewCell)
}

@objc(JChatMessageCell)
class JChatMessageCell: UITableViewCell {
  internal var headImageView:UIImageView!
  internal var messageBubble:JChatMessageBubble?
  internal var circleView:UIActivityIndicatorView!
  internal var percentLable:UILabel!
  internal var sendfailImg:UIImageView!

//  text
  internal var textMessageContent:UILabel!
  
//  voice
  internal var isPlaying:Bool!
  internal var voiceImgIndex:Int!  // 语言按钮图片的当前标识
  internal var voiceBtn:UIImageView!
  internal var unreadStatusView:UIView!
  internal var voiceTimeLable:UILabel!
  internal var continuePlayer:Bool!
  
  weak var delegate:JChatMessageCellDelegate!
  var messageModel:JChatMessageModel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = UITableViewCellSelectionStyle.none
    self.backgroundColor = UIColor.clear
    
    self.continuePlayer = false
    self.voiceImgIndex = 0
    self.isPlaying = false
    
    self.headImageView = UIImageView()
    self.headImageView.layer.cornerRadius = 22.5
    self.headImageView.layer.masksToBounds = true
    self.contentView.addSubview(self.headImageView)
    
    self.textMessageContent = UILabel()
    self.textMessageContent.numberOfLines = 0
    self.textMessageContent.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    self.contentView.addSubview(textMessageContent)
    
    self.voiceBtn = UIImageView()
    self.contentView.addSubview(self.voiceBtn)
    
    self.unreadStatusView = UIView()
    self.unreadStatusView.layer.cornerRadius = 4
    self.unreadStatusView.layer.masksToBounds = true
    self.unreadStatusView.backgroundColor = UIColor.red
    self.contentView.addSubview(self.unreadStatusView)
    
    self.circleView = UIActivityIndicatorView()
    self.circleView.backgroundColor = UIColor.clear
    self.circleView.isHidden = true
    self.circleView.hidesWhenStopped = true
    self.contentView.addSubview(self.circleView)

    self.sendfailImg = UIImageView()
    self.sendfailImg.image = UIImage(named: "fail05")
    self.contentView.addSubview(self.sendfailImg)
    
    self.voiceTimeLable = UILabel()
    self.voiceTimeLable.backgroundColor = UIColor.clear
    self.voiceTimeLable.font = UIFont.systemFont(ofSize: 18)
    self.contentView.addSubview(self.voiceTimeLable)
    
    self.textMessageContent.backgroundColor = UIColor.clear
    
    self.messageBubble = JChatMessageBubble(frame: CGRect.zero)
    self.contentView.insertSubview(self.messageBubble!, belowSubview: self.textMessageContent)
    
    self.percentLable = UILabel()
    self.percentLable.font = UIFont.systemFont(ofSize: 18)
    self.percentLable.textAlignment = .center
    self.percentLable.textColor = UIColor.white
    self.messageBubble?.addSubview(percentLable)
    self.percentLable.snp_makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 60, height: 40))
      make.center.equalTo(self.messageBubble!)
    }
    
    self.addGestureForAllViews()
  }
  
  func addGestureForAllViews() {
    let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapContent))
    self.messageBubble?.addGestureRecognizer(gesture)
    self.messageBubble?.isUserInteractionEnabled = true

    let tapHeadGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHeadView))
    self.headImageView.addGestureRecognizer(tapHeadGesture)
    self.headImageView.isUserInteractionEnabled = true
    
  }
  
  func tapContent() {
    print("tap message")
    switch messageModel.message.contentType {
    case .voice:
      self.playVoice()
      break
    case .image:
      if messageModel.message.status == .receiveDownloadFailed {
        print("正在下载缩略图")
        self.circleView.startAnimating()
      } else {
        self.delegate.tapPicture(self.messageModel, tableViewCell: self)
      }
      break
    default:
      break
    }
  }
  
  func tapHeadView() {
    self.delegate.selectHeadView(self.messageModel)
  }
  
  func setCellData(_ model:JChatMessageModel) {
    self.messageModel = model
    self.messageBubble?.message = model.message
    
    model.message.fromUser.thumbAvatarData { (data, ObjectId, error) -> Void in
      if error == nil {
        let user:JMSGUser = self.messageModel.message.fromUser
        if ObjectId == user.username {
          
          if data != nil {
            self.headImageView.image = UIImage(data: data!)
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
      
    }
    
    self.messageBubble?.image = self.messageBubble?.maskBackgroupImage
    
    switch model.message.contentType {
    case .text:
      let textContent = model.message.content as! JMSGTextContent
      self.textMessageContent.text = textContent.text
      break
    case .voice:
      self.setVoiceBtmImage()
      break
    case .image:
      let imageContent = self.messageModel.message.content as! JMSGImageContent
      
      imageContent.thumbImageData({[weak weakSelf = self] (data, objectId, error) -> Void in
        if error == nil {
          if data != nil {
            weakSelf?.messageBubble?.image = UIImage(data: data!)
            return
          }
        }
        weakSelf?.messageBubble?.image = UIImage(named: "receiveFail")
        })
      break
    default:
      break
    }
    
    if self.messageModel.message.flag == 1 || !self.messageModel.message.isReceived {
      self.unreadStatusView.isHidden = true
    } else {
      self.unreadStatusView.isHidden = false
    }
    
    self.layoutAllViews()

  }
  
  func setCellData(_ model:JChatMessageModel, delegate:JChatMessageCellDelegate) {
    self.delegate = delegate
    self.setCellData(model)
  }
  
  func layoutAllViews() {
    let tmpMessage = self.messageModel.message

    switch tmpMessage?.status {
    case .sending?:
      fallthrough
    case .sendDraft?:
      self.circleView.startAnimating()
      self.sendfailImg.isHidden = true
      self.percentLable.isHidden = false
      
      if tmpMessage?.contentType == .image {
        self.messageBubble?.alpha = 0.5
        self.addUpLoadHandler()
      } else {
        self.messageBubble?.alpha = 1
      }

      break
      
    case .sendFailed?:
      fallthrough
    case .sendUploadFailed?:
      fallthrough
    case .receiveDownloadFailed?:
      self.circleView.stopAnimating()
      if (tmpMessage?.isReceived)! {
        self.sendfailImg.isHidden = false
      } else {
        self.percentLable.isHidden = true
      }
      self.messageBubble?.alpha = 1
      break
    default:
      self.messageBubble?.alpha = 1
      self.circleView.stopAnimating()
      self.sendfailImg.isHidden = true
      self.percentLable.isHidden = true
      break
    }
    
    if tmpMessage?.contentType != .voice {
      self.unreadStatusView.isHidden = true
    }
    
    switch tmpMessage?.contentType {
    case .unknown?:
      
      break
    case .text?:
      self.textMessageContent.isHidden = false
      self.percentLable.isHidden = true
      self.unreadStatusView.isHidden = true
      self.voiceTimeLable.isHidden = true
      self.voiceBtn.isHidden = true
      break
    case .image?:
      self.textMessageContent.isHidden = true
      self.unreadStatusView.isHidden = true
      self.voiceTimeLable.isHidden = true
      self.voiceBtn.isHidden = true
      break
    case .voice?:
      self.textMessageContent.isHidden = true
      self.textLabel?.isHidden = true
      self.percentLable.isHidden = true
      self.voiceTimeLable.isHidden = false
      self.voiceBtn.isHidden = false
      self.voiceTimeLable.text = "\((tmpMessage?.content as! JMSGVoiceContent).duration)"
      break
    case .custom?:
      break
    case .eventNotification?:
      break
    default:
      break
    }
  }
  
  func addUpLoadHandler() {
    (self.messageModel.message.content as! JMSGImageContent).uploadHandler = {[weak weakSelf = self] (percent:Float, msgId:(String!)) in
      DispatchQueue.main.async(execute: { () -> Void in
        if weakSelf?.messageModel.message.msgId == msgId! {
          let percent = "\(Int(percent*100))％"
          weakSelf?.percentLable.text = percent
          print("upload percent is \(percent)")
        }
      })
    } as! JMSGMediaProgressHandler
    
  }
  
  //#pragma mark --连续播放语音
  //- (void)playVoice {
  //}
  
  func playVoice() {
    print("Action - playVoice")

    self.continuePlayer = false
    self.unreadStatusView.isHidden = true
    self.messageModel.message.updateFlag(1)

    (self.messageModel.message.content as! JMSGVoiceContent).voiceData {[weak weakSelf = self] (data, objectId, error) -> Void in
      var alertString = ""
      if error == nil {
        if data != nil {
          alertString = "下载语言成功"
          weakSelf!.voiceImgIndex = 0
        }
// TODO:
        self.isPlaying = true
        JChatAudioPlayerHelper.sharedInstance.delegate = self
        JChatAudioPlayerHelper.sharedInstance.managerAudioWithData(data!, toplay: true)
      }
    }
    
  }
  
  func changeVoiceBtmImage() {
    if self.isPlaying == false {
      return
    }
    self.setVoiceBtmImage()
    if self.isPlaying == true{
      self.voiceImgIndex? = self.voiceImgIndex! + 1
      self.perform(#selector(self.changeVoiceBtmImage), with: nil, afterDelay: 0.25)
    }
  }
  
  func setVoiceBtmImage() {
    var voiceImagePreStr:NSString = ""
    if self.messageModel.message.isReceived {
      voiceImagePreStr = "ReceiverVoiceNodePlaying00"
    } else {
      voiceImagePreStr = "SenderVoiceNodePlaying00"
    }
    print(voiceImagePreStr.appending("\(self.voiceImgIndex % 4)"))
    self.voiceBtn.image = UIImage(named: voiceImagePreStr.appending("\(self.voiceImgIndex % 4)"))

  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}

// TODO:

extension JChatMessageCell:JChatAudioPlayerHelperDelegate {
  func didAudioPlayerBeginPlay(_ AudioPlayer:AVAudioPlayer) {
  
  }

  func didAudioPlayerStopPlay(_ AudioPlayer:AVAudioPlayer) {
    JChatAudioPlayerHelper.sharedInstance.delegate = nil
    self.isPlaying = false
    self.voiceImgIndex = 0
    self.setVoiceBtmImage()
    
    if self.continuePlayer == true {
      self.continuePlayer = false
      self.perform(#selector(JChatMessageCell.prepareToPlayVoice), with: nil, afterDelay: 0.5)
    }
  }
  
  func prepareToPlayVoice() {
    self.delegate?.successionalPlayVoice(self)
  }
  
  func didAudioPlayerPausePlay(_ AudioPlayer:AVAudioPlayer) {
  
  }
}


