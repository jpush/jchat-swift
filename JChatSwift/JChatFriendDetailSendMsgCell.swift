//
//  JChatFriendDetailSendMsgCell.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/8.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

typealias SendMessageCallback = () -> ()

class JChatFriendDetailSendMsgCell: UITableViewCell {

  @IBOutlet weak var sendMsgBtn: UIButton!
  var callBack:SendMessageCallback?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.sendMsgBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: .Normal)
    self.sendMsgBtn.setBackgroundColor(UIColor(netHex: 0x50cb50), forState: .Highlighted)
  }

  func setClickSendMsgCallback(clickBtnCallback:SendMessageCallback) {
    self.callBack = clickBtnCallback
  }
  
  @IBAction func clickSendMessageBtn(sender: AnyObject) {
   self.callBack?()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
}
