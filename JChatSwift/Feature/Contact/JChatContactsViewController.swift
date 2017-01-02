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
  var contactsDataSource:JChatContatctsDataSource!
  var searchController:UISearchController!
  var filtContactViewCtr:JChatSearchFriendViewController!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupNavigation()
    
    self.setupAllView()
    self.setupDatasource()
  }
  
//  override func viewDidLayoutSubviews() {
//    self.setupAllView()
//    self.setupDatasource()
//  }
  
  func setupDatasource() {
    self.contactsDataSource = JChatContatctsDataSource()
    JMSGFriendManager.getFriendList { (friendList, error) in
      if error == nil {
          self.contactsDataSource.setupData(friendList as! NSArray)
        }
        self.contactsList.reloadData()
      }
  }
  
  func setupNavigation() {
    self.title = "通讯录"
  }
  
  func setupAllView() {
    self.filtContactViewCtr = JChatSearchFriendViewController()
    
    
    self.searchController = UISearchController(searchResultsController: self.filtContactViewCtr)
    self.searchController.searchBar.showsCancelButton = false;
    self.searchController.searchBar.placeholder = "搜索"
    self.searchController.searchBar.barTintColor = kcontactColor
    self.searchController.searchBar.layer.borderWidth = 1
    self.searchController.searchBar.delegate = self
    self.searchController.searchBar.layer.borderColor = kcontactColor.cgColor

    self.contactsList = UITableView()
    self.contactsList.backgroundColor = kcontactColor
    self.contactsList.separatorStyle = .singleLine
    self.contactsList.keyboardDismissMode = .onDrag
    self.contactsList.sectionIndexColor = kcontactColor
    self.contactsList.sectionIndexBackgroundColor = UIColor.clear
//    self.contactsList.tableHeaderView = self.searchBar;
    self.view.addSubview(self.contactsList)
    self.contactsList.snp.makeConstraints { (make) in
      make.left.equalTo(self.view)
      make.right.equalTo(self.view)
      make.bottom.equalTo(self.view)
      make.top.equalTo(self.view)
    }
    self.contactsList.delegate = self
    self.contactsList.dataSource = self
    self.contactsList.tableHeaderView = self.searchController.searchBar
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JChatContactsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if (self.contactsDataSource?.friendsLetterArr) == nil { return 0 }
    return (self.contactsDataSource.friendsLetterArr.count);
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    let nameLetter = self.contactsDataSource.friendsLetterArr[section]
    let nameLetterArr = self.contactsDataSource.friendsDic[nameLetter] as! NSMutableArray
    return nameLetterArr.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
//    if (section == integerRepresentingYourSectionOfInterest) {
//      headerView.backgroundColor = UIColor.redColor()
//    } else {
//      headerView.backgroundColor = UIColor.clearColor()
//    }
//    return headerView
    
    
    if section == 0 {
//      return self.searchView
      return UIView()
    }
    let nameLetter = self.contactsDataSource.friendsLetterArr[section]
    let label = JChatPaddingLabel()
    label.padding = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 5)
    label.backgroundColor = kcontactColor
    label.text = nameLetter as! String
    label.textColor = UIColor(netHex: 0x787878)
    label.backgroundColor = kcontactColor
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    }
    return 21
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56;
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return (self.contactsDataSource.friendsLetterArr) as! [String]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatFriendTableViewCell"
    var cell:JChatFriendTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    
    if cell == nil {
      tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    }
    
    if indexPath.section == 0 {
      cell?.setupOriginData(headImage: UIImage(named: "menu_14")!, title: "好友请求")
      return cell!
    }
    
    let nameLetter = self.contactsDataSource.friendsLetterArr[indexPath.section]
    let nameLetterArr = self.contactsDataSource.friendsDic[nameLetter] as! NSMutableArray
    let friend = nameLetterArr[indexPath.row]
    
    cell?.setupData(model: friend as! JChatFriendModel)
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


// MARK: - UISearchBarDelegate
extension JChatContactsViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
    let cancelBtn = searchBar.value(forKey: "cancelButton") as! UIButton
    cancelBtn.setTitle("取消", for: .normal)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let filterArr = self.contactsDataSource.filterFriends(with: searchText)
    print(filterArr)
    self.filtContactViewCtr.filterContactArr = filterArr
  }
  
}

