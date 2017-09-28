//
//  JCConversationCell.swift
//  JChat
//
//  Created by deng on 2017/3/22.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCConversationCell: JCTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _init()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private lazy var avatorView: UIImageView = UIImageView()
    private lazy var statueView: UIImageView = UIImageView()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var msgLabel: UILabel = UILabel()
    private lazy var dateLabel: UILabel = UILabel()
    private lazy var redPoin: UILabel = UILabel(frame: CGRect(x: 65 - 17, y: 4.5, width: 20, height: 20))
    
    //MARK: - public func
    open func bindConversation(_ conversation: JMSGConversation) {
        self.statueView.isHidden = true
        let isGroup = conversation.isGroup
        if conversation.unreadCount != nil && (conversation.unreadCount?.intValue)! > 0 {
            self.redPoin.isHidden = false
            var text = ""
            if (conversation.unreadCount?.intValue)! > 99 {
                text = "99+"
                redPoin.layer.cornerRadius = 9.0
                redPoin.layer.masksToBounds = true
                redPoin.frame = CGRect(x: 65 - 28, y: 4.5, width: 33, height: 18)
            } else {
                redPoin.layer.cornerRadius = 10.0
                redPoin.layer.masksToBounds = true
                redPoin.frame = CGRect(x: 65 - 15, y: 4.5, width: 20, height: 20)
                text = "\(conversation.unreadCount!)"
            }
            self.redPoin.text = text
            
            var isNoDisturb = false
            if isGroup {
                if let group = conversation.target as? JMSGGroup {
                    isNoDisturb = group.isNoDisturb
                }
            } else {
                if let user = conversation.target as? JMSGUser {
                    isNoDisturb = user.isNoDisturb
                }
            }
            
            if isNoDisturb {
                redPoin.layer.cornerRadius = 4.0
                redPoin.layer.masksToBounds = true
                redPoin.text = ""
                redPoin.frame = CGRect(x: 65 - 5, y: 4.5, width: 8, height: 8)
            }
        } else {
            self.redPoin.isHidden = true
        }
        
        if let latestMessage = conversation.latestMessage {
            let time = latestMessage.timestamp.intValue / 1000
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            self.dateLabel.text = date.conversationDate()
        } else {
            self.dateLabel.text = ""
        }
        
        msgLabel.text = conversation.latestMessageContentText()
        if isGroup {
            
            if let latestMessage = conversation.latestMessage {
                let fromUser = latestMessage.fromUser
                if !fromUser.isEqual(to: JMSGUser.myInfo()) &&
                    latestMessage.contentType != .eventNotification {
                    msgLabel.text = "\(fromUser.displayName()):\(msgLabel.text!)"
                }
                if conversation.unreadCount != nil && conversation.unreadCount!.intValue > 0 {
                    
                    if latestMessage.isAtAll() {
                        msgLabel.attributedText = getAttributString(attributString: "[@所有人]", string: msgLabel.text!)
                    } else if latestMessage.isAtMe() {
                        msgLabel.attributedText = getAttributString(attributString: "[有人@我]", string: msgLabel.text!)
                    }
                }
            }
        }
        
        if let draft = JCDraft.getDraft(conversation) {
            if !draft.isEmpty {
                msgLabel.attributedText = getAttributString(attributString: "[草稿]", string: draft)
            }
        }
        
        
        if !isGroup {
            let user = conversation.target as? JMSGUser
            self.titleLabel.text = user?.displayName() ?? ""
            user?.thumbAvatarData { (data, username, error) in
                guard let imageData = data else {
                    self.avatorView.image = self.userDefaultIcon
                    return
                }
                let image = UIImage(data: imageData)
                self.avatorView.image = image
            }
            
        } else {
//            self.avatorView.image = groupDefaultIcon
            if let group = conversation.target as? JMSGGroup {
                self.titleLabel.text = group.displayName()
                if group.isShieldMessage {
                    self.statueView.isHidden = false
                }
                group.thumbAvatarData({ (data, _, error) in
                    if let data = data {
                        self.avatorView.image = UIImage(data: data)
                    } else {
                        self.avatorView.image = self.groupDefaultIcon
                    }
                })
            }
        }
        if conversation.isSticky {
            self.backgroundColor = UIColor(netHex: 0xF5F6F8)
        } else {
            self.backgroundColor = .white
        }
    }
    
    func getAttributString(attributString: String, string: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: "")
        var attrSearchString: NSAttributedString!
        attrSearchString = NSAttributedString(string: attributString, attributes: [ NSForegroundColorAttributeName : UIColor(netHex: 0xEB424C), NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14.0)])
        attr.append(attrSearchString)
        attr.append(NSAttributedString(string: string))
        return attr
    }
    
    private lazy var groupDefaultIcon = UIImage.loadImage("com_icon_group_50")
    private lazy var userDefaultIcon = UIImage.loadImage("com_icon_user_50")
    
    //MARK: - private func
    private func _init() {
        avatorView.contentMode = .scaleToFill
        avatorView.image = userDefaultIcon
        
        statueView.image = UIImage.loadImage("com_icon_shield")
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        msgLabel.textColor = UIColor(netHex: 0x808080)
        msgLabel.font = UIFont.systemFont(ofSize: 14)
        
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor(netHex: 0xB3B3B3)
        
        redPoin.textAlignment = .center
        redPoin.font = UIFont.systemFont(ofSize: 11)
        redPoin.textColor = .white
        redPoin.layer.backgroundColor = UIColor(netHex: 0xEB424C).cgColor
        redPoin.textAlignment = .center
        
        contentView.addSubview(avatorView)
        contentView.addSubview(statueView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(msgLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(redPoin)
        
        addConstraint(_JCLayoutConstraintMake(avatorView, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(avatorView, .top, .equal, contentView, .top, 7.5))
        addConstraint(_JCLayoutConstraintMake(avatorView, .width, .equal, nil, .notAnAttribute, 50))
        addConstraint(_JCLayoutConstraintMake(avatorView, .height, .equal, nil, .notAnAttribute, 50))
        
        addConstraint(_JCLayoutConstraintMake(titleLabel, .left, .equal, avatorView, .right, 10.5))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .top, .equal, contentView, .top, 10.5))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .right, .equal, dateLabel, .left, -3))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .height, .equal, nil, .notAnAttribute, 22.5))
        
        addConstraint(_JCLayoutConstraintMake(msgLabel, .left, .equal, titleLabel, .left))
        addConstraint(_JCLayoutConstraintMake(msgLabel, .top, .equal, titleLabel, .bottom, 1.5))
        addConstraint(_JCLayoutConstraintMake(msgLabel, .right, .equal, statueView, .left, -5))
        addConstraint(_JCLayoutConstraintMake(msgLabel, .height, .equal, nil, .notAnAttribute, 20))
        
        addConstraint(_JCLayoutConstraintMake(dateLabel, .top, .equal, contentView, .top, 16))
        addConstraint(_JCLayoutConstraintMake(dateLabel, .right, .equal, contentView, .right, -15))
        addConstraint(_JCLayoutConstraintMake(dateLabel, .height, .equal, nil, .notAnAttribute, 16.5))
        addConstraint(_JCLayoutConstraintMake(dateLabel, .width, .equal, nil, .notAnAttribute, 100))
        
        addConstraint(_JCLayoutConstraintMake(statueView, .top, .equal, dateLabel, .bottom, 7))
        addConstraint(_JCLayoutConstraintMake(statueView, .right, .equal, contentView, .right, -16))
        addConstraint(_JCLayoutConstraintMake(statueView, .height, .equal, nil, .notAnAttribute, 12))
        addConstraint(_JCLayoutConstraintMake(statueView, .width, .equal, nil, .notAnAttribute, 12))
    }
    
}
