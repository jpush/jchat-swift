//
//  JCButtonCell.swift
//  JChat
//
//  Created by deng on 2017/3/28.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

@objc public protocol JCButtonCellDelegate: NSObjectProtocol {
    @objc optional func buttonCell(clickButton button: UIButton)
}

class JCButtonCell: UITableViewCell {
    
    open weak var delegate: JCButtonCellDelegate?
    
    var buttonTitle: String {
        get {
            return (self.button.titleLabel?.text)!
        }
        set {
            self.button.setTitle(newValue, for: .normal)
        }
    }
    
    var buttonColor: UIColor {
        get {
            return self.color
        }
        set {
            color = newValue
            self.button.setBackgroundImage(UIImage.createImage(color: color, size: CGSize(width: self.contentView.width - 30, height: self.contentView.height)), for: .normal)
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
    
    private var color = UIColor(netHex: 0x2dd0cf)
    private lazy var button: UIButton = UIButton()
    
    //MARK: - private func 
    private func _init() {
        backgroundColor = .clear
        button.addTarget(self, action: #selector(_click(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("退出登录", for: .normal)
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage.createImage(color: color, size: CGSize(width: contentView.width - 30, height: contentView.height)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        addConstraint(_JCLayoutConstraintMake(button, .left, .equal, contentView, .left, 15))
        addConstraint(_JCLayoutConstraintMake(button, .right, .equal, contentView, .right, -15))
        addConstraint(_JCLayoutConstraintMake(button, .top, .equal, contentView, .top))
        addConstraint(_JCLayoutConstraintMake(button, .bottom, .equal, contentView, .bottom))
        
    }
    
    //MARK: - click func
    func _click(_ sender: UIButton) {
        delegate?.buttonCell?(clickButton: sender)
    }

}
