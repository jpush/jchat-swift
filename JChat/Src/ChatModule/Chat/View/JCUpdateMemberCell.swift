//
//  JCUpdateMemberCell.swift
//  JChat
//
//  Created by deng on 2017/5/11.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCUpdateMemberCell: UICollectionViewCell {
    var avator: UIImage? {
        get {
            return self.avatorView.image
        }
        set {
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
    
    private func _init() {
        
        avatorView.image = UIImage.loadImage("com_icon_user_36")
        avatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(avatorView)
        
        addConstraint(_JCLayoutConstraintMake(avatorView, .centerY, .equal, contentView, .centerY))
        addConstraint(_JCLayoutConstraintMake(avatorView, .width, .equal, nil, .notAnAttribute, 36))
        addConstraint(_JCLayoutConstraintMake(avatorView, .height, .equal, nil, .notAnAttribute, 36))
        addConstraint(_JCLayoutConstraintMake(avatorView, .centerX, .equal, contentView, .centerX))
        
    }
    
    func bindDate(user: JMSGUser) {
        avatorView.image = UIImage.loadImage("com_icon_user_36")
        user.thumbAvatarData { (data, id, error) in
            if data != nil {
                let image = UIImage(data: data!)
                self.avatorView.image = image
            }
        }
    }
}
