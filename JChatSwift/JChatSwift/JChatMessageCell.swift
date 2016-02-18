//
//  JChatMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatMessageCell)

class JChatMessageCell: UITableViewCell {
  internal var headImageView:UIImageView!
  internal var textMessageContent:UILabel!
  internal var imageMessageContent:UIImageView!
  internal var voiceBtn:UIImageView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = UITableViewCellSelectionStyle.None
    
    self.headImageView = UIImageView()
    self.contentView.addSubview(self.headImageView)
    
    self.textMessageContent = UILabel()
    self.contentView.addSubview(textMessageContent)
    
    self.imageMessageContent = UIImageView()
    self.contentView.addSubview(self.imageMessageContent)
    
    self.voiceBtn = UIImageView()
    self.contentView.addSubview(self.imageMessageContent)
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}

class JChatRightMessageCell:JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
}

class JChatLeftMessageCell:JChatMessageCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.headImageView = UIImageView()

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }

}
