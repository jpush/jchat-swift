//
//  JChatFootTableTableViewCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatQuitGroupDelegate)
protocol JChatQuitGroupDelegate {
  func quitGroup()
}

@objc(JChatFootTableTableViewCell)
class JChatFootTableTableViewCell: UITableViewCell {
  @IBOutlet weak var footTitle: UILabel!
  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var quitBtn: UIButton!
  @IBOutlet weak var arrowImg: UIImageView!
  weak var cellDelegate:JChatQuitGroupDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.quitBtn.layer.cornerRadius = 4
    self.quitBtn.layer.masksToBounds = true
    self.quitBtn.setBackgroundColor(UIColor.red, forState: UIControlState())
    self.quitBtn.setBackgroundColor(UIColor(netHex: 0xc0303b), forState: .highlighted)
    let topLine = UIView()
    topLine.backgroundColor = kSeparatorColor
    self.contentView.addSubview(topLine)
    topLine.snp_makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
    }
  }

  func setDataWithGroupName(_ groupName: String) {
    self.footTitle.isHidden = false
    self.groupName.isHidden = false
    self.arrowImg.isHidden = false
    self.quitBtn.isHidden = true
    
    self.footTitle.text = "群聊名称"
    self.groupName.text = groupName
  }
  
  func layoutToClearChatRecord() {
    self.footTitle.isHidden = false
    self.groupName.isHidden = false
    self.arrowImg.isHidden = false
    self.quitBtn.isHidden = true
    
    self.footTitle.text = "清空聊天纪录"
    self.groupName.text = ""
  }

  func layoutToQuitGroup() {
    self.footTitle.isHidden = true
    self.groupName.isHidden = true
    self.arrowImg.isHidden = true
    self.quitBtn.isHidden = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
    
  @IBAction func clickToQuitGroup(_ sender: AnyObject) {
    self.cellDelegate?.quitGroup()
  }
}
