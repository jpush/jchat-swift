//
//  JCMyInfoCell.swift
//  JChat
//
//  Created by deng on 2017/3/30.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCMyInfoCell: JCTableViewCell {
    
    var icon: UIImage? {
        get {
            return self.iconView.image
        }
        set {
            self.iconView.image = newValue
        }
    }
    
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var detail: String? {
        get {
            return self.detailLabel.text
        }
        set {
            self.detailLabel.text = newValue
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
    
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var detailLabel: UILabel = UILabel()
    
    private func _init() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.textAlignment = .right
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = UIColor(netHex: 0x999999)

        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        addConstraint(_JCLayoutConstraintMake(iconView, .top, .equal, contentView, .top, 13.5))
        addConstraint(_JCLayoutConstraintMake(iconView, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(iconView, .width, .equal, nil, .notAnAttribute, 18))
        addConstraint(_JCLayoutConstraintMake(iconView, .height, .equal, nil, .notAnAttribute, 18))
        
        addConstraint(_JCLayoutConstraintMake(titleLabel, .centerY, .equal, contentView, .centerY))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .left, .equal, iconView, .right, 10))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .width, .equal, nil, .notAnAttribute, 100))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .height, .equal, nil, .notAnAttribute, 22.5))
        
        
        addConstraint(_JCLayoutConstraintMake(detailLabel, .centerY, .equal, contentView, .centerY))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .left, .equal, titleLabel, .right))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .right, .equal, contentView, .right))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .height, .equal, contentView, .height))
    }

}
