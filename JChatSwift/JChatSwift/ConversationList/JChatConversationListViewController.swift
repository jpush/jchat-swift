//
//  JChatConversationListViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

@objc(JChatConversationListViewController)
class JChatConversationListViewController: UIViewController {
  var conversationListTable:UITableView!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.conversationListTable = UITableView()
      self.conversationListTable.tableFooterView = UIView()
      self.conversationListTable.delegate = self
      self.conversationListTable.dataSource = self
      self.view.addSubview(self.conversationListTable)
      self.conversationListTable.snp_makeConstraints { (make) -> Void in
        make.top.right.left.bottom.equalTo(self.view)
      }
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

    }
}

extension JChatConversationListViewController: UITableViewDataSource,UITableViewDelegate {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
}