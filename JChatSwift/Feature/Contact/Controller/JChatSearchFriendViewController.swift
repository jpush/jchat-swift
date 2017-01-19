//
//  JChatSearchFriendViewController.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatSearchFriendViewController: UIViewController {
  
  var callBack:CompletionBlock?
  convenience init() {
    self.init(callBack: nil)
  }
  
  init(callBack: CompletionBlock?) {
    self.callBack = callBack
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open var filterContactArr:[JMSGUser] = [JMSGUser]() {
    didSet { self.filterContactTable?.reloadData() }
  }

  var filterContactTable:UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.filterContactTable = UITableView()
    self.filterContactTable.tableFooterView = UIView()
    self.view.addSubview(self.filterContactTable)
    self.filterContactTable.delegate = self
    self.filterContactTable.dataSource = self
    self.filterContactTable.backgroundColor = UIColor.clear
    self.filterContactTable.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.left.equalToSuperview()
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
//  open func reflashContactTable(contacts:NSArray) {
//    self.filterContactArr = contacts
//    self.filterContactTable.reloadData()
//  }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JChatSearchFriendViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.filterContactArr == nil {
      return 0
    }
    return self.filterContactArr.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatFriendTableViewCell"
    var cell:JChatFriendTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    
    if cell == nil {
      tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    }
    
    cell?.setupData(with: self.filterContactArr[indexPath.row])
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    let friend = self.filterContactArr[indexPath.row] as! JMSGUser
    self.callBack!(friend)

  }
  
}
