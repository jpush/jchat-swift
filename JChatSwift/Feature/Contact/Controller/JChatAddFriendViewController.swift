//
//  JChatAddFriendViewController.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JChatAddFriendViewController: UIViewController {
  
  open var username:String?
  var reasonLabel:UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.layoutAllView()
  }
  
  func layoutAllView() {
    self.view.backgroundColor = UIColor(netHex: 0xebebeb)
    
    let presentationLabel = UILabel()
    presentationLabel.text = "你需要发送验证申请，等对方通过"
    presentationLabel.font = UIFont.systemFont(ofSize: 13)
    presentationLabel.textColor = UIColor(netHex: 0x727272)
    presentationLabel.numberOfLines = 0
    self.view.addSubview(presentationLabel)
    
    self.reasonLabel = UITextField()
    self.reasonLabel.placeholder = "我是\(JMSGUser.myInfo().displayName())"
    self.reasonLabel.becomeFirstResponder()
    self.view.addSubview(reasonLabel)
    
    let addFriendBtn = UIButton()
    addFriendBtn.setTitle("添加好友", for: .normal)
    addFriendBtn.layer.cornerRadius = 3
    addFriendBtn.layer.masksToBounds = true
    addFriendBtn.setBackgroundColor(UIColor(netHex: 0x1eae14), forState: .normal)
    addFriendBtn.setBackgroundColor(UIColor(netHex: 0x1b8d12), forState: .highlighted)
    self.view.addSubview(addFriendBtn)
    addFriendBtn.addTarget(self, action: #selector(self.onClickAddFriend), for: .touchUpInside)
    
    let deleteReasonBtn = UIButton()
    deleteReasonBtn.setImage(UIImage(named: "set_btn_del_"), for: .normal)
    deleteReasonBtn.setImage(UIImage(named: "set_btn_del_pre_"), for: .highlighted)
    self.view.addSubview(deleteReasonBtn)
    deleteReasonBtn.addTarget(self, action: #selector(self.onClickDeleteReason), for: .touchUpInside)
    
    presentationLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(18)
      make.right.equalToSuperview()
      make.left.equalToSuperview().offset(15)
      make.height.equalTo(20)
    }
   
    deleteReasonBtn.snp.makeConstraints { (make) in
      make.top.equalTo(presentationLabel.snp.bottom)
      make.right.equalToSuperview()
      make.height.equalTo(30)
      make.width.equalTo(30)
    }
    
    self.reasonLabel.snp.makeConstraints { (make) in
      make.top.equalTo(presentationLabel.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(15)
      make.right.equalTo(deleteReasonBtn.snp.left).offset(-15)
    }
    
    addFriendBtn.snp.makeConstraints { (make) in
      make.top.equalTo(self.reasonLabel.snp.bottom).offset(20)
      make.right.equalToSuperview().offset(-20)
      make.left.equalToSuperview().offset(20)
      make.height.equalTo(46)
    }
  }
  
  func onClickAddFriend() {
    MBProgressHUD.showMessage("正在发送好友请求", toView: self.view)
    JMSGFriendManager.sendInvitationRequest(withUsername: self.username, appKey: JMSSAGE_APPKEY, reason: self.reasonLabel!.text, completionHandler: { (resultObj, error) in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error != nil {
        MBProgressHUD.showMessage("添加失败", view: self.view)
        return }
      
      if error == nil {
        JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: self.username!, reason: self.reasonLabel.text!, invitationType: JChatFriendEventNotificationType.waitingVerification.rawValue)
        MBProgressHUD.showMessage("添加成功", view: self.view)
        self.navigationController?.popViewController(animated: true)
      }
    })
    
  }
  
  func onClickDeleteReason() {
    self.reasonLabel.text = ""
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }

}
