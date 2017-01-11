//
//  JChatFriendDetailSendMsgCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/8.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatFriendDetailSendMsgCell: UITableViewCell {

  @IBOutlet weak var cellBtn: UIButton!
  var callBack:ClickBlock?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.cellBtn.layer.cornerRadius = 3
    self.cellBtn.layer.masksToBounds = true
    self.selectionStyle = .none
  }

  func setClickSendMsgCallback(_ clickBtnCallback:@escaping ClickBlock) {
    self.cellBtn.setTitle("发送消息", for: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0x50cb50), forState: .highlighted)
    self.callBack = clickBtnCallback
  }
  
  func setClickAddFriendCallback(_ clickBtnCallback:@escaping ClickBlock) {
    self.cellBtn.setTitle("添加好友", for: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0x1eae14), forState: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0x1b8d12), forState: .highlighted)
//    addFriendBtn.setBackgroundColor(UIColor(netHex: 0x1eae14), forState: .normal)
//    addFriendBtn.setBackgroundColor(UIColor(netHex: 0x1b8d12), forState: .highlighted)
    self.callBack = clickBtnCallback
    
  }
  
  func setClickDeleteCallback(_ clickBtnCallback:@escaping ClickBlock) {
    self.cellBtn.setTitle("删除好友", for: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0xd32c32), forState: .normal)
    self.cellBtn.setBackgroundColor(UIColor(netHex: 0xc2272c), forState: .highlighted)
    self.callBack = clickBtnCallback
  }
  @IBAction func clickSendMessageBtn(_ sender: AnyObject) {
   self.callBack?()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
  
  
}
