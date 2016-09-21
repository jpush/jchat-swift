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
  var topLine:UIView!
  var infoLabel:UILabel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = UIColor.clear
    
    self.iconImg = UIImageView()
    self.contentView.addSubview(self.iconImg)
    self.iconImg.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.contentView).offset(9)
      make.size.equalTo(CGSize(width: 22, height: 22))
      make.bottom.equalTo(self.contentView).offset(-10)
    }
    
    self.arrowImg = UIImageView()
    self.contentView.addSubview(self.arrowImg)
    self.arrowImg.image = UIImage(named: "jiantou")
    self.arrowImg.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 8, height: 15))
      make.centerY.equalTo(self.contentView)
      make.right.equalTo(self.contentView).offset(-1)
    }
    
    self.tittleLable = UILabel()
    self.contentView.addSubview(self.tittleLable)
    self.tittleLable.font = UIFont.systemFont(ofSize: 17)
    self.tittleLable.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(self.iconImg.snp_right).offset(8)
      make.centerY.equalTo(self.contentView.snp_centerY)
      make.width.equalTo(75)
    }
    
    self.infoLabel = UILabel()
    self.infoLabel.numberOfLines = 0
    self.infoLabel.textAlignment = .right
    self.infoLabel.font = UIFont.systemFont(ofSize: 17)
    self.infoLabel.textColor = UIColor.gray
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
    self.baseLine.backgroundColor = kSeparatorColor
    self.baseLine.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
      make.bottom.equalTo(self.contentView).offset(0.5)
    }
    
    self.topLine = UIView()
    self.contentView.addSubview(self.topLine)
    self.topLine.backgroundColor = kSeparatorColor
    self.topLine.snp_makeConstraints { (make) in
      make.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
      make.top.equalTo(self.contentView)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setCellData(_ tittle: String, icon: String) {
    self.infoLabel.isHidden = true
    self.iconImg.image = UIImage(named: icon)
    self.tittleLable.text = tittle
  }
  
  func setCellData(_ tittle: String, icon: String, info: String) {
    self.iconImg.image = UIImage(named: icon)
    self.tittleLable.text = tittle
    self.infoLabel.text = info
  }
  
  func setFriendCellData(_ tittle: String, icon: String, info: String) {
    self.iconImg.image = UIImage(named: icon)
    self.tittleLable.text = tittle
    self.infoLabel.text = info
    self.arrowImg.isHidden = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
