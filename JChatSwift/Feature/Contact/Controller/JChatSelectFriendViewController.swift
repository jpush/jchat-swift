//
//  JChatSelectFriendViewController.swift
//  JChatSwift
//
//  Created by oshumini on 2017/1/9.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JChatSelectFriendViewController: UIViewController {
  
  var selectedView:UIView!
  var contactsList:UITableView!
//  var contactsDataSource:JChatContatctsDataSource!
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  func setupDataSource() {
//    self.contactsDataSource = JChatContatctsDataSource()
// 
//    JChatDataBaseManager.sharedInstance.setupTable(username: JMSGUser.myInfo().username)
//    let usernameArr = JChatDataBaseManager.sharedInstance.selectAllContact(currentUser: JMSGUser.myInfo().username)
//    if usernameArr.count == 0 {
//      JMSGFriendManager.getFriendList { (friendList, error) in
//        if error == nil {
//          JChatContatctsDataSource.sharedInstance.setupData(friendList as! NSArray)
//          JChatDataBaseManager.sharedInstance.addContactList(currentUser: JMSGUser.myInfo().username, contactUsernameArr: friendList as! Array<JMSGUser>)
//        }
//        self.contactsList.reloadData()
//      }
//    } else {
//      JMSGUser.userInfoArray(withUsernameArray: usernameArr, completionHandler: { (contactArr, error) in
//        if error != nil { return }
//        
//        JChatContatctsDataSource.sharedInstance.setupData(contactArr as! NSArray)
//        self.contactsList.reloadData()
//      })
//    }

  }
  
  func setupAllView() {
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}
