//
//  JChatLoadingMessageCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/18.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatLoadingMessageCell)
class JChatLoadingMessageCell: UITableViewCell {
  var loadIndicator:UIActivityIndicatorView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = UITableViewCellSelectionStyle.none
    loadIndicator = UIActivityIndicatorView()
    loadIndicator.color = UIColor.red
    self.contentView.addSubview(self.loadIndicator)
    
    self.contentView.snp_makeConstraints({ (make) -> Void in
      make.center.equalTo(self.snp_center)

      make.top.equalTo(self.snp_top).offset(13)
      make.bottom.equalTo(self.contentView.snp_bottom).offset(-3)
      make.size.equalTo(CGSize(width: 20, height: 20))
      
      
    })
    self.startLoading()
    self.backgroundColor = UIColor.clear
  }
  
  func startLoading() {
    self.loadIndicator.startAnimating()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }

}
