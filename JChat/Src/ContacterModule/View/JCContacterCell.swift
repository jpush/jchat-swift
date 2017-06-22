//
//  JCContacterCell.swift
//  JChat
//
//  Created by deng on 2017/3/14.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCContacterCell: JCTableViewCell {
    
    var isShowBadge: Bool {
        get {
            return !self.redPoin.isHidden
        }
        set {
            self.redPoin.isHidden = !newValue
        }
    }
    
    var icon: UIImage? {
        get {
            return self.avatorView.image
        }
        set {
            self.avatorView.image = newValue
        }
    }
    
    var title: String? {
        get {
            return self.usernameLabel.text
        }
        set {
            self.usernameLabel.text = newValue
        }
    }

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
    private lazy var usernameLabel: UILabel = UILabel()
    private lazy var redPoin: UILabel = UILabel()
    
    public func bindDate(_ user : JMSGUser) {
        self.title = user.displayName()
        self.icon = UIImage.loadImage("com_icon_user_36")
        user.thumbAvatarData({ (data, name, error) in
            if data != nil {
                let image = UIImage(data: data!)
                self.icon = image
            }
        })
    }
    
    public func bindDateWithGroup(group : JMSGGroup) {
        self.title = group.displayName()
        self.icon = UIImage.loadImage("com_icon_group_36")
    }
    
    //MARK: - private func
    private func _init() {
        
        avatorView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.textColor = UIColor(netHex: 0x2c2c2c)
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        redPoin.textAlignment = .center
        redPoin.text = ""
        redPoin.layer.cornerRadius = 4.0
        redPoin.layer.masksToBounds = true
        redPoin.isHidden = true
        redPoin.layer.backgroundColor = UIColor.red.cgColor
        redPoin.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(avatorView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(redPoin)
        
        addConstraint(_JCLayoutConstraintMake(avatorView, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(avatorView, .top, .equal, contentView, .top, 9.5))
        addConstraint(_JCLayoutConstraintMake(avatorView, .width, .equal, nil, .notAnAttribute, 36))
        addConstraint(_JCLayoutConstraintMake(avatorView, .height, .equal, nil, .notAnAttribute, 36))
        
        addConstraint(_JCLayoutConstraintMake(usernameLabel, .left, .equal, avatorView, .right, 11))
        addConstraint(_JCLayoutConstraintMake(usernameLabel, .top, .equal, contentView, .top, 19.5))
        addConstraint(_JCLayoutConstraintMake(usernameLabel, .right, .equal, contentView, .right, -15))
        addConstraint(_JCLayoutConstraintMake(usernameLabel, .height, .equal, nil, .notAnAttribute, 16))

        addConstraint(_JCLayoutConstraintMake(redPoin, .left, .equal, avatorView, .right, -5))
        addConstraint(_JCLayoutConstraintMake(redPoin, .top, .equal, avatorView, .top, -3))
        addConstraint(_JCLayoutConstraintMake(redPoin, .height, .equal, nil, .notAnAttribute, 8))
        addConstraint(_JCLayoutConstraintMake(redPoin, .width, .equal, nil, .notAnAttribute, 8))
    }

}
