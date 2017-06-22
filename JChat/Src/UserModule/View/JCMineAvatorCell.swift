//
//  JCMineAvatorCell.swift
//  JChat
//
//  Created by deng on 2017/3/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCMineAvatorCell: UITableViewCell {

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
    
    func baindDate(user: JMSGUser) {
        nickname.text = user.displayName()
        signature.text = user.signature
        iconView.image = UIImage.loadImage("com_icon_user_65")
        user.thumbAvatarData { (data, username, error) in
            guard let imageData = data else {
                return
            }
            let image = UIImage(data: imageData)
            self.iconView.image = image
        }
    }
    
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var signature: UILabel = UILabel()
    private lazy var nickname: UILabel = UILabel()
    
    //MARK: - private func
    private func _init() {
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        signature.font = UIFont.systemFont(ofSize: 14)
        signature.textColor = UIColor(netHex: 0x999999)
        signature.translatesAutoresizingMaskIntoConstraints = false
        nickname.textColor = UIColor(netHex: 0x2c2c2c)
        nickname.font = UIFont.systemFont(ofSize: 16)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(signature)
        contentView.addSubview(nickname)
        
        addConstraint(_JCLayoutConstraintMake(iconView, .top, .equal, contentView, .top, 10))
        addConstraint(_JCLayoutConstraintMake(iconView, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(iconView, .width, .equal, nil, .notAnAttribute, 65))
        addConstraint(_JCLayoutConstraintMake(iconView, .height, .equal, nil, .notAnAttribute, 65))
        
        addConstraint(_JCLayoutConstraintMake(nickname, .top, .equal, contentView, .top, 21.5))
        addConstraint(_JCLayoutConstraintMake(nickname, .left, .equal, iconView, .right, 11))
        addConstraint(_JCLayoutConstraintMake(nickname, .right, .equal, contentView, .right))
        addConstraint(_JCLayoutConstraintMake(nickname, .height, .equal, nil, .notAnAttribute, 22.5))
        
        addConstraint(_JCLayoutConstraintMake(signature, .top, .equal, nickname, .bottom, 2.5))
        addConstraint(_JCLayoutConstraintMake(signature, .left, .equal, nickname, .left))
        addConstraint(_JCLayoutConstraintMake(signature, .right, .equal, nickname, .right))
        addConstraint(_JCLayoutConstraintMake(signature, .height, .equal, nil, .notAnAttribute, 20))
    }

}
