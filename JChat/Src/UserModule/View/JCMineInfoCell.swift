//
//  JCMineInfoCell.swift
//  JChat
//
//  Created by deng on 2017/3/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

@objc public protocol JCMineInfoCellDelegate: NSObjectProtocol {
    @objc optional func mineInfoCell(clickSwitchButton button: UISwitch, indexPath: IndexPath?)
}

class JCMineInfoCell: JCTableViewCell {
    
    open weak var delegate: JCMineInfoCellDelegate?
    var indexPate: IndexPath?
    
    var title: String {
        get {
            return self.titleLabel.text!
        }
        set {
            return self.titleLabel.text  = newValue
        }
    }
    
    var detail: String? {
        get {
            return self.detailLabel.text
        }
        set {
            self.detailLabel.isHidden = false
            self.detailLabel.text = newValue
        }
    }
    
    var isShowSwitch: Bool {
        get {
            return !self.switchButton.isHidden
        }
        set {
            self.switchButton.isHidden = !newValue
        }
    }
    
    var isSwitchOn: Bool {
        get {
            return self.switchButton.isOn
        }
        set {
            self.switchButton.isOn = newValue
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
    
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var switchButton: UISwitch =  UISwitch()
    private lazy var detailLabel: UILabel = UILabel()
    
    //MARK: - private func
    private func _init() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16)

        switchButton.isHidden = true
        switchButton.addTarget(self, action: #selector(clickSwitch(_:)), for: .valueChanged)
        
        detailLabel.textAlignment = .right
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.isHidden = true
        detailLabel.textColor = UIColor(netHex: 0x999999)
        
        contentView.addSubview(switchButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

        addConstraint(_JCLayoutConstraintMake(titleLabel, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .right, .equal, contentView, .centerX))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .centerY, .equal, contentView, .centerY))
        addConstraint(_JCLayoutConstraintMake(titleLabel, .height, .equal, nil, .notAnAttribute, 22.5))
        
        addConstraint(_JCLayoutConstraintMake(detailLabel, .centerY, .equal, contentView, .centerY))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .left, .equal, titleLabel, .right))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .right, .equal, contentView, .right))
        addConstraint(_JCLayoutConstraintMake(detailLabel, .height, .equal, contentView, .height))

//        addConstraint(_JCLayoutConstraintMake(switchButton, .top, .equal, contentView, .top, 15.5))
        addConstraint(_JCLayoutConstraintMake(switchButton, .right, .equal, contentView, .right, -15))
//        addConstraint(_JCLayoutConstraintMake(switchButton, .height, .equal, nil, .notAnAttribute, 14))
//        addConstraint(_JCLayoutConstraintMake(switchButton, .width, .equal, nil, .notAnAttribute, 60))
        addConstraint(_JCLayoutConstraintMake(switchButton, .centerY, .equal, contentView, .centerY))
        
    }
    
    func clickSwitch(_ sender: UISwitch) {
        delegate?.mineInfoCell?(clickSwitchButton: sender, indexPath: indexPate)
    }

}
