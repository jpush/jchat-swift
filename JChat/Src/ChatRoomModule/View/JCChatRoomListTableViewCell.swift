//
//  JCChatRoomListTableViewCell.swift
//  JChat
//
//  Created by xudong.rao on 2019/4/17.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit
import Masonry

class JCChatRoomListTableViewCell: JCTableViewCell {
    
    public var iconImageView: UIImageView = UIImageView()
    public var nameLabel: UILabel = UILabel()
    public var descLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _init()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        nameLabel.textColor = UIColor(netHex: 0x2c2c2c)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.backgroundColor = .white
        
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.backgroundColor = .white
        descLabel.lineBreakMode = .byTruncatingTail
        
//        iconImageView.layer.cornerRadius = 8.0
//        iconImageView.layer.masksToBounds = true
        iconImageView.image = UIImage.loadImage("com_icon_group_36")
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        
        iconImageView.mas_makeConstraints { (make) in
            let space = 10.0
            make?.top.equalTo()(space)
            make?.left.equalTo()(space)
            make?.bottom.equalTo()(-space)
            make?.width.equalTo()(iconImageView.mas_height)
        }
        nameLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(iconImageView.mas_top)
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(8.0)
            make?.right.equalTo()(-10)
            make?.height.equalTo()(iconImageView.mas_height)?.multipliedBy()(0.5)
        }
        descLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(nameLabel.mas_bottom)
            make?.left.equalTo()(nameLabel.mas_left)
            make?.right.equalTo()(nameLabel.mas_right)
            make?.height.equalTo()(nameLabel.mas_height)
        }
    }
    
    public func bindData(_ room: JMSGChatRoom) {
        nameLabel.text = room.displayName()
        descLabel.text = room.desc
        iconImageView.image = UIImage.loadImage("com_icon_group_36")
    }
}
