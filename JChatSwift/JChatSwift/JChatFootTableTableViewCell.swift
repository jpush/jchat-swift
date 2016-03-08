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
    self.quitBtn.setBackgroundColor(UIColor.redColor(), forState: .Normal)
    self.quitBtn.setBackgroundColor(UIColor(netHex: 0xc0303b), forState: .Highlighted)
    let baseLine = UIView()
    baseLine.backgroundColor = UIColor.grayColor()
    self.contentView.addSubview(baseLine)
    baseLine.snp_makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.contentView)
      make.height.equalTo(0.5)
    }
  }

  func setDataWithGroupName(groupName: String) {
    self.footTitle.hidden = false
    self.groupName.hidden = false
    self.arrowImg.hidden = false
    self.quitBtn.hidden = true
    
    self.footTitle.text = "群聊名称"
    self.groupName.text = groupName
  }
  
  func layoutToClearChatRecord() {
    self.footTitle.hidden = false
    self.groupName.hidden = false
    self.arrowImg.hidden = false
    self.quitBtn.hidden = true
    
    self.footTitle.text = "清空聊天纪录"
    self.groupName.text = ""
  }

  func layoutToQuitGroup() {
    self.footTitle.hidden = true
    self.groupName.hidden = true
    self.arrowImg.hidden = true
    self.quitBtn.hidden = false
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
    
  @IBAction func clickToQuitGroup(sender: AnyObject) {
    self.cellDelegate?.quitGroup()
  }
}
