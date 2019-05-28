//
//  JCChatRoomInfoTableViewCell.swift
//  JChat
//
//  Created by Allan on 2019/4/25.
//  Copyright © 2019 HXHG. All rights reserved.
//

import UIKit

class JCChatRoomInfoCell: JCTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _init()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func _init(){
        self.accessoryType = .disclosureIndicator
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in  self.contentView.subviews {
            if view.isKind(of: UIImageView.self) {
                view.removeFromSuperview()
            }
        }
    }
    public func bindImages(users: [JMSGUser]?) {
        let startX = UIScreen.main.bounds.width - 25
        let paddingX: CGFloat = 5
        let width: CGFloat = 40
        let y: CGFloat = self.contentView.centerY - width/2
        
        var  end = users?.count ?? 0
        if end > 5 { //最多取5个管理员头像展示
          end = 5
        }
        for index in 0..<end {
            let i : CGFloat = CGFloat(index + 1)
            let user = users?[end-index-1]
            let x = startX - (paddingX + width)*i
            let imageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))
            self.contentView.addSubview(imageView)
            user?.thumbAvatarData { (data, id, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    imageView.image = image
                } else {
                    imageView.image = UIImage.loadImage("com_icon_user_50")
                }
            }
        }
    }
}
