//
//  JChatContactsViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatContactsViewController)
class JChatContactsViewController: UITabBarController {
  var contactsList:UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupNavigation()
    self.setupAllView()
    
  }

  func setupNavigation() {
    self.title = "通讯录"
  }
  
  func setupAllView() {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
