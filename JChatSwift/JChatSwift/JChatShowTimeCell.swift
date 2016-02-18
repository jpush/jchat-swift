//
//  JChatShowTimeCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/18.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatShowTimeCell: UITableViewCell {
  var timeLable:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.timeLable = UILabel()
      self.contentView.addSubview(self.timeLable)
      self.timeLable.layer.cornerRadius = 2
      self.timeLable.backgroundColor = UIColor.grayColor()
      self.timeLable.snp_makeConstraints { (make) -> Void in
        make.center.equalTo(self.contentView)
        make.size.equalTo(CGSize(width: 60, height: 30))
      }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
