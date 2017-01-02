//
//  JChatSearchFriendView.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

protocol JChatSearchFriendViewDelegate:NSObjectProtocol {
  // sendText
//  func sendTextMessage(_ messageText:String)
  func jchatSearchBarDeginEdit(searchBar:UISearchBar)
  func jchatSearchBarDidClickCancelButton(searchBar: UISearchBar)
  func jchatSearchBarTextDidDidChange(searchBar: UISearchBar)
}


class JChatSearchFriendView: UIView {

  var searchBar:UISearchBar!
  var filterContactTable:UITableView!
  weak var delegate:JChatSearchFriendViewDelegate!
  
  override init(frame: CGRect) {
    super.init(frame: frame) // calls designated initializer
    
    self.searchBar = UISearchBar()
    self.searchBar.showsCancelButton = false;
    self.searchBar.delegate = self
    self.searchBar.placeholder = "搜索"
    self.searchBar.barTintColor = kcontactColor
    self.searchBar.layer.borderWidth = 1
    self.searchBar.layer.borderColor = kcontactColor.cgColor
    
    self.addSubview(self.searchBar)
    self.searchBar.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.left.equalToSuperview()
      make.height.equalTo(44)
    }
    self.filterContactTable = UITableView()
    self.filterContactTable.delegate = self
    self.filterContactTable.dataSource = self
    
    self.addSubview(self.filterContactTable)
    self.filterContactTable.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.equalTo(self.searchBar.snp.bottom)
    }
  }
  
  convenience init(frame: CGRect, delegate: JChatSearchFriendViewDelegate){
    self.init(frame: frame) // calls the initializer above
    self.delegate = delegate
  }
  
  func showSearchList() {
      self.searchBar.snp.updateConstraints { (make) in
        make.top.equalToSuperview().offset(20)
        make.right.equalToSuperview()
        make.left.equalToSuperview()
        make.height.equalTo(kSearchBarHeight)
    }
  }
  
  func hideSearchList() {
    self.searchBar.snp.updateConstraints { (make) in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.left.equalToSuperview()
      make.height.equalTo(kSearchBarHeight)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension JChatSearchFriendView: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 0;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 21
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
    
//    if indexPath.section == 0 {
      cell?.setupOriginData(headImage: UIImage(named: "menu_14")!, title: "好友请求")
      return cell!
//    }
    
//    let nameLetter = self.contactsDataSource.friendsLetterArr[indexPath.section]
//    let nameLetterArr = self.contactsDataSource.friendsDic[nameLetter] as! NSMutableArray
//    let friend = nameLetterArr[indexPath.row]
//    
//    cell?.setupData(model: friend as! JChatFriendModel)
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
extension JChatSearchFriendView: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.setShowsCancelButton(true, animated: true)
    let cancelBtn = self.searchBar.value(forKey: "cancelButton") as! UIButton
    cancelBtn.setTitle("取消", for: .normal)
    self.delegate.jchatSearchBarDeginEdit(searchBar: searchBar)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.searchBar.setShowsCancelButton(false, animated: true)
    self.searchBar.resignFirstResponder()
    self.delegate.jchatSearchBarDidClickCancelButton(searchBar: searchBar)
  }
  
//  func showHeaderView() {
//    let contactHeadView = UIView()
//    contactHeadView.backgroundColor = kcontactColor
//    contactHeadView.frame = CGRect(x: 0, y: 0, width: kApplicationWidth , height: 20)
//    self.contactsList.tableHeaderView = contactHeadView
//  }
  
}

extension JChatSearchFriendView: UISearchResultsUpdating
{
  //实时进行搜索
  func updateSearchResults(for searchController: UISearchController) {
    //    self.searchArray = self.schoolArray.filter { (school) -> Bool in
    //      return school.contains(searchController.searchBar.text!)
    //    }
    print("asdfasdfas")
  }
}
