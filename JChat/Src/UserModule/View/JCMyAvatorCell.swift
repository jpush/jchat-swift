//
//  JCMyAvatorCell.swift
//  JChat
//
//  Created by deng on 2017/3/30.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import JMessage

class JCMyAvatorCell: UITableViewCell {

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
    private lazy var nameLabel: UILabel = UILabel()
    
    private lazy var defaultAvator = UIImage.loadImage("com_icon_user_80")
    
    //MARK: - private func 
    private func _init() {
        avatorView.contentMode = .scaleAspectFill
        avatorView.clipsToBounds = true
        avatorView.image = defaultAvator
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(netHex: 0x999999)
        
        contentView.addSubview(avatorView)
        contentView.addSubview(nameLabel)
        
        addConstraint(_JCLayoutConstraintMake(avatorView, .top, .equal, contentView, .top, 25))
        addConstraint(_JCLayoutConstraintMake(avatorView, .centerX, .equal, contentView, .centerX))
        addConstraint(_JCLayoutConstraintMake(avatorView, .width, .equal, nil, .notAnAttribute, 80))
        addConstraint(_JCLayoutConstraintMake(avatorView, .height, .equal, nil, .notAnAttribute, 80))
        
        addConstraint(_JCLayoutConstraintMake(nameLabel, .top, .equal, avatorView, .bottom, 9))
        addConstraint(_JCLayoutConstraintMake(nameLabel, .right, .equal, contentView, .right))
        addConstraint(_JCLayoutConstraintMake(nameLabel, .left, .equal, contentView, .left))
        addConstraint(_JCLayoutConstraintMake(nameLabel, .height, .equal, nil, .notAnAttribute, 14))
    }
    
    func bindData(user: JMSGUser) {
        self.nameLabel.text =  "用户名：" + user.username
        avatorView.image = defaultAvator
        user.thumbAvatarData { (data, username, error) in
            guard let imageData = data else {
                return 
            }
            let image = UIImage(data: imageData)
            self.avatorView.image = image
        }
    }

}
