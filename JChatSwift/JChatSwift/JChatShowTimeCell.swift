//
//  JChatShowTimeCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/18.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatShowTimeCell)
class JChatShowTimeCell: UITableViewCell {
  var timeLable:UILabel!

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .None
    self.backgroundColor = UIColor.clearColor()
    
    self.timeLable = UILabel()
    self.contentView.addSubview(self.timeLable)
    self.timeLable.layer.cornerRadius = 2
    self.timeLable.textColor = UIColor.grayColor()
    self.textLabel?.font = UIFont.systemFontOfSize(14)
    self.textLabel?.textAlignment = .Center
    self.timeLable.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.contentView)
      make.height.equalTo(15)
      make.height.lessThanOrEqualTo(22)
      make.top.equalTo(self.contentView).offset(2)
      make.bottom.equalTo(self.contentView).offset(-2)
    }
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func layoutModel(model:JChattimeModel) {
    self.timeLable.text = NSString.getFriendlyDateString(model.messageTime.doubleValue, forConversation: false)
    print("did layoutModel")
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
