//
//  JChatInvitationControllerViewController.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/4.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JChatInvitationViewController: UIViewController {

  var invitationTable:UITableView!
  var invitationArr:NSMutableArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigation()
    self.setupAllView()
    self.setupAllData()
  }
  
  func setupNavigation() {
    self.title = "验证消息"
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    let rightBtn = UIButton(type: .custom)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
    rightBtn.addTarget(self, action: #selector(self.clickToDeleteAllInvitation), for: .touchUpInside)
    rightBtn.setTitle("清空", for: .normal)
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15 * UIScreen.main.scale)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
  }
  
  func clickToDeleteAllInvitation() {
    JChatDataBaseManager.sharedInstance.deleteAllInvitation(currentUser: JMSGUser.myInfo().username)
    self.invitationArr = NSMutableArray()
    self.invitationTable.reloadData()
  }
  
  func setupAllData() {
    JChatDataBaseManager.sharedInstance.selectInvitation(currentUser: JMSGUser.myInfo().username, callback: { (invitationarr) in
      self.invitationArr = NSMutableArray(array: (invitationarr as! NSArray))
      self.invitationTable.reloadData()
      
    })
  }
  
  func setupAllView() {
    self.invitationTable = UITableView()
    self.view.addSubview(self.invitationTable)
    self.invitationTable.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.left.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    self.invitationTable.delegate = self
    self.invitationTable.dataSource = self
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  

}

// MARK:
extension JChatInvitationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.invitationArr == nil {
      return 0
    }
    return self.invitationArr.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatInvitationTableViewCell"
    var cell:JChatInvitationTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatInvitationTableViewCell
    
    if cell == nil {
      tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatInvitationTableViewCell
    }

    cell?.setData(with: (self.invitationArr[indexPath.row] as! JChatInvitationModel), acceptCallback: { (username) in
      NotificationCenter.default.post(name: Notification.Name(rawValue: kAcceptFriendNotification), object: username)
    }, rejectCallback: { (username) in
      self.invitationArr.remove(username)
      self.invitationTable.reloadData()
    })
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    if indexPath.section == 0 {
      
    } else {
      
    }
  }
}


extension JChatInvitationViewController: UIGestureRecognizerDelegate {
  
}

