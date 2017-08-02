//
//  JCGroupMemberCell.swift
//  JChat
//
//  Created by deng on 2017/5/10.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCGroupMemberCell: UICollectionViewCell {
    
    var avator: UIImage? {
        get {
            return self.avatorView.image
        }
        set {
            self.nickname.text = ""
            self.avatorView.image = newValue
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private var avatorView: UIImageView = UIImageView()
    private var nickname: UILabel = UILabel()
    
    private func _init() {
        
        avatorView.image = UIImage.loadImage("com_icon_user_50")
        
        avatorView.translatesAutoresizingMaskIntoConstraints = false
        nickname.font = UIFont.systemFont(ofSize: 12)
        nickname.textAlignment = .center
        nickname.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatorView)
        addSubview(nickname)
        
        addConstraint(_JCLayoutConstraintMake(avatorView, .centerY, .equal, contentView, .centerY, -10))
        addConstraint(_JCLayoutConstraintMake(avatorView, .width, .equal, nil, .notAnAttribute, 50))
        addConstraint(_JCLayoutConstraintMake(avatorView, .height, .equal, nil, .notAnAttribute, 50))
        addConstraint(_JCLayoutConstraintMake(avatorView, .centerX, .equal, contentView, .centerX))
        
        addConstraint(_JCLayoutConstraintMake(nickname, .centerX, .equal, contentView, .centerX))
        addConstraint(_JCLayoutConstraintMake(nickname, .width, .equal, nil, .notAnAttribute, 50))
        addConstraint(_JCLayoutConstraintMake(nickname, .height, .equal, nil, .notAnAttribute, 15))
        addConstraint(_JCLayoutConstraintMake(nickname, .top, .equal, avatorView, .bottom, 5))
        
    }
    
    func bindDate(user: JMSGUser) {
        nickname.text = user.displayName()
        avatorView.image = UIImage.loadImage("com_icon_user_50")
        user.thumbAvatarData { (data, id, error) in
            if data != nil {
                let image = UIImage(data: data!)
                self.avatorView.image = image
            }
        }
    }
    
}
