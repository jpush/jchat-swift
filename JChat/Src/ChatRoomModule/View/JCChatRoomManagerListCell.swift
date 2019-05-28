//
//  JCChatRoomManagerListCell.swift
//  JChat
//
//  Created by Allan on 2019/4/28.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomManagerListCell: JCContacterCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        fatalError("init(coder:) has not been implemented")
    }
    private func _init(){
        self.isShowBadge = false
        self.contentView.addSubview(self.deletBtn)
        self.deletBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.contentView)
            make?.right.equalTo()(self.contentView)?.offset()(-10.0)
            make?.size.equalTo()(CGSize.init(width: 72, height: 25))
        }
    }
    lazy var deletBtn: UIButton = {
        let deletBtn = UIButton.init()
        deletBtn.setTitle("移除", for: .normal)
        deletBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let image = UIImage.createImage(color: UIColor(netHex: 0x2dd0cf), size: CGSize(width: 72, height: 25))
        deletBtn.setBackgroundImage(image, for: .normal)
        deletBtn.layer.cornerRadius = 2
        deletBtn.layer.masksToBounds = true
        return deletBtn
    }()
}
