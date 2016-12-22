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
    self.sendMsgBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: UIControlState())
    self.sendMsgBtn.setBackgroundColor(UIColor(netHex: 0x50cb50), forState: .highlighted)
  }

  func setClickSendMsgCallback(_ clickBtnCallback:@escaping SendMessageCallback) {
    self.callBack = clickBtnCallback
  }
  
  @IBAction func clickSendMessageBtn(_ sender: AnyObject) {
   self.callBack?()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
}
