//
//  JChatAboutMeCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/1.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatAboutMeCell)
class JChatAboutMeCell: UITableViewCell {

  var tittleLable:UILabel!
  var arrowImg:UIImageView!
  var iconImg:UIImageView!
  var baseLine:UIView!
  var infoLabel:UILabel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .None
    self.backgroundColor = UIColor.clearColor()
    
    self.iconImg = UIImageView()
    self.contentView.addSubview(self.iconImg)
    self.iconImg.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.contentView).offset(9)
//      make.top.equalTo(self.contentView).offset(10)
      make.size.equalTo(CGSize(width: 22, height: 22))
      make.bottom.equalTo(self.contentView).offset(-10)
    }
    
    self.arrowImg = UIImageView()
    self.contentView.addSubview(self.arrowImg)
    self.arrowImg.image = UIImage(named: "jiantou")
    self.arrowImg.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSizeMake(8, 15))
      make.centerY.equalTo(self.contentView)
      make.right.equalTo(self.contentView).offset(-1)
    }
    
    self.tittleLable = UILabel()
    self.contentView.addSubview(self.tittleLable)
    self.tittleLable.font = UIFont.systemFontOfSize(17)
    self.tittleLable.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.iconImg.snp_right).offset(8)
      make.centerY.equalTo(self.contentView.snp_centerY)
      make.width.equalTo(75)
    }
    
    self.infoLabel = UILabel()
    self.infoLabel.numberOfLines = 0
    self.infoLabel.textAlignment = .Right
    self.infoLabel.font = UIFont.systemFontOfSize(17)
    self.infoLabel.textColor = UIColor.grayColor()
    self.contentView.addSubview(self.infoLabel)
    self.infoLabel.snp_makeConstraints { (make) -> Void in
      make.right.equalTo(self.arrowImg.snp_left).offset(-10)
      make.left.equalTo(self.tittleLable.snp_right)
      make.top.equalTo(self.contentView).offset(5)
      make.bottom.equalTo(self.contentView).offset(-5)
      make.height.greaterThanOrEqualTo(40)
    }
    
    self.baseLine = UIView()
    self.contentView.addSubview(self.baseLine)
    self.baseLine.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
      make.bottom.equalTo(self.contentView)
    }
    self.baseLine.backgroundColor = UIColor(netHex: 0xd0d0d0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setCellData(tittle: String, icon: String) {
    self.infoLabel.hidden = true
    self.iconImg.image = UIImage(named: icon)
    self.tittleLable.text = tittle
  }
  
  func setCellData(tittle: String, icon: String, info: String) {
    self.iconImg.image = UIImage(named: icon)
    self.tittleLable.text = tittle
    self.infoLabel.text = info
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
