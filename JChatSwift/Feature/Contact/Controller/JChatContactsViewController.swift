//
//  JChatContactsViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD


@objc(JChatContactsViewController)
class JChatContactsViewController: UITabBarController {

  
  var contactsList:UITableView!
  var searchController:UISearchController!
  var filtContactViewCtr:JChatSearchFriendViewController!
  var navigationRightBtn:UIButton!
  var selectContactView:JChatSelectContactView?

  // SeletedMode
  var callBack:CompletionBlock? // 选择模式，点击右上角的回调
  var isSelectMode:Bool!
  var defaulSelectedArr:[String]
  
  convenience init() {
    self.init(isSelect: false, callBack: nil)
  }
  
  init(isSelect: Bool!, callBack: CompletionBlock?) {
    self.isSelectMode = isSelect
    self.callBack = callBack
    self.defaulSelectedArr = []
    super.init(nibName: nil, bundle: nil)
  }
  
  init(isSelect: Bool!, defaulSelected:[String], callBack: CompletionBlock?) {
    self.isSelectMode = isSelect
    self.callBack = callBack
    self.defaulSelectedArr = defaulSelected
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.setupNavigation()

    self.setupAllView()
    
    JMessage.add(self, with: nil)
    JChatContatctsDataSource.sharedInstance.resetSelected()
    self.addAllNotification()
  }
  
  override func viewDidLayoutSubviews() {

  }
  func addAllNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.deleteFriend(_:)), name: NSNotification.Name(rawValue: kDeleteFriendNotificaion), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.acceptFriend(_:)), name: NSNotification.Name(rawValue: kAcceptFriendNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.accountChangeToReloadContactList), name: NSNotification.Name(rawValue: kAccountChangeNotification), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.reflashContactTable(_:)), name: NSNotification.Name(rawValue: kContactDataReadyNotification), object: nil)
  }

  func accountChangeToReloadContactList() {
    JChatContatctsDataSource.sharedInstance.changeAccount()
  }
  
  func reflashContactTable(_ notification:Notification) {
    DispatchQueue.main.async(execute: {
      self.contactsList?.reloadData()
    })
    
  }
  
  func deleteFriend(_ notification:Notification) {
    let username = notification.object as! String
    JChatDataBaseManager.sharedInstance.removeContact(currentUser: JMSGUser.myInfo().username, with: username)
    JChatContatctsDataSource.sharedInstance.deleteUser(with: username)
    self.contactsList.reloadData()
  }
  
  
  func acceptFriend(_ notification:Notification) {
    let username = notification.object as! String
    JChatDataBaseManager.sharedInstance.addContact(currentUser: JMSGUser.myInfo().username, with: username)
    JChatContatctsDataSource.sharedInstance.addUser(with: username)
    self.contactsList.reloadData()
  }
  
  func setupNavigation() {
    self.title = "通讯录"
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationRightBtn = UIButton(type: .custom)
    self.navigationRightBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
    self.navigationRightBtn.contentHorizontalAlignment = .right
    self.navigationRightBtn.addTarget(self, action: #selector(self.clickToRightNavigationBtn), for: .touchUpInside)
    
    if self.isSelectMode == true {
      self.navigationRightBtn.setTitle("确定", for: .normal)
    } else {
      self.navigationRightBtn.setImage(UIImage(named: "createConversation"), for: UIControlState())
    }
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.navigationRightBtn)
    
  }
  
  func clickToRightNavigationBtn() {
    if self.isSelectMode == true {
      
      
      var selectArr = NSArray(array: JChatContatctsDataSource.sharedInstance.selectedContact) as! [JChatFriendModel]
      var selectUserNameArr = JChatContatctsDataSource.sharedInstance.usernameArr(with: selectArr)
      selectUserNameArr += self.defaulSelectedArr
      if selectArr.count == 0 {
        self.navigationController?.popViewController(animated: true)
        return
      }
      MBProgressHUD.showMessage("正在创建群聊", toView: self.view)
      self.callBack?(selectArr)
    } else {
      let alertView = UIAlertView(title: "添加好友", message: "输入好友用户名!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
      alertView.alertViewStyle = .plainTextInput
      alertView.show()
    }
    
  }
  
  func setupAllView() {
    
    self.filtContactViewCtr = JChatSearchFriendViewController(callBack: { (user) in
      let userDetailVC = JChatFriendDetailViewController()
      userDetailVC.hidesBottomBarWhenPushed = true
      userDetailVC.isGroupFlag = false
      userDetailVC.user = user as! JMSGUser
      self.navigationController?.pushViewController(userDetailVC, animated: true)
    })
  
    self.contactsList = UITableView()
    self.contactsList.backgroundColor = kcontactColor
    self.contactsList.separatorStyle = .singleLine
    self.contactsList.keyboardDismissMode = .onDrag
    self.contactsList.sectionIndexColor = UIColor(netHex: 0x3e3e3e)
    self.contactsList.sectionIndexBackgroundColor = UIColor.clear
    self.contactsList.tableFooterView = UIView()
    self.view.addSubview(self.contactsList)

    self.contactsList.delegate = self
    self.contactsList.dataSource = self
    
    if self.isSelectMode == false {
      self.contactsList.snp.makeConstraints { (make) in
        make.left.equalTo(self.view)
        make.right.equalTo(self.view)
        make.bottom.equalTo(self.view).offset(-50)
        make.top.equalTo(self.view)
      }
      
      self.searchController = UISearchController(searchResultsController: self.filtContactViewCtr)
      self.searchController.searchBar.showsCancelButton = false;
      self.searchController.searchBar.placeholder = "搜索"
      self.searchController.searchBar.barTintColor = kcontactColor
      self.searchController.searchBar.layer.borderWidth = 1
      self.searchController.searchBar.delegate = self
      self.searchController.searchBar.layer.borderColor = kcontactColor.cgColor
      self.contactsList.tableHeaderView = self.searchController.searchBar
    } else {
      self.contactsList.snp.makeConstraints({ (make) in
        make.right.left.bottom.top.equalToSuperview()
      })
    }
    
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    JMessage.remove(self, with: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JChatContactsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if (JChatContatctsDataSource.sharedInstance.friendsLetterArr) == nil { return 0 }
    
    return (JChatContatctsDataSource.sharedInstance.friendsLetterArr.count);
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return self.isSelectMode == true ? 0 : 1
    }
    
//    if self.isSelectMode == true {
//      
//    } else {
      let nameLetter = JChatContatctsDataSource.sharedInstance.friendsLetterArr[section]
      print("nameletter \(nameLetter)")
      let nameLetterArr = JChatContatctsDataSource.sharedInstance.friendsDic[nameLetter] as? NSMutableArray
      return nameLetterArr != nil ? (nameLetterArr?.count)! : 0
//    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
      return UIView()
    }
    
    let nameLetter = JChatContatctsDataSource.sharedInstance.friendsLetterArr[section]
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
    return (JChatContatctsDataSource.sharedInstance.friendsLetterArr) as! [String]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatFriendTableViewCell"
    var cell:JChatFriendTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    
    if cell == nil {
      tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendTableViewCell
    }

    if indexPath.section == 0 && self.isSelectMode == false {
      cell?.setupOriginData(headImage: UIImage(named: "menu_14")!, title: "验证消息")
      return cell!
    }
    
    let nameLetter = JChatContatctsDataSource.sharedInstance.friendsLetterArr[indexPath.section]
    let nameLetterArr = JChatContatctsDataSource.sharedInstance.friendsDic[nameLetter] as! NSMutableArray
    let friendUsername = nameLetterArr[indexPath.row]
    let friend = JChatContatctsDataSource.sharedInstance.contactUser(with: (friendUsername as! String))
    
    cell?.setupData(model: friend!, isSelectModel: self.isSelectMode, selectDefaults: self.defaulSelectedArr, selectCallBack: {[weak weakSelf = self] (user) in
      if user == nil { return }
      
      JChatContatctsDataSource.sharedInstance.addSelectedUser(with: user as! JChatFriendModel)
      weakSelf?.navigationRightBtn.setTitle("确定(\(JChatContatctsDataSource.sharedInstance.seletedCount()))", for: .normal)
    }, delSelectCallBack: {[weak weakSelf = self] (user) in
      if user == nil { return }
      
      JChatContatctsDataSource.sharedInstance.removeSelectedUser(with: user as! JChatFriendModel)
      weakSelf?.navigationRightBtn.setTitle("确定(\(JChatContatctsDataSource.sharedInstance.seletedCount()))", for: .normal)
    })
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    if self.isSelectMode == true { return } // 选择模式，Cell 没有点击任务
    
    if indexPath.section == 0 {
      let invitationVC = JChatInvitationViewController()
      invitationVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(invitationVC, animated: true)
    } else {
      let userDetailVC = JChatFriendDetailViewController()
      userDetailVC.hidesBottomBarWhenPushed = true
      userDetailVC.isGroupFlag = false
      
      let nameLetter = JChatContatctsDataSource.sharedInstance.friendsLetterArr[indexPath.section]
      let nameLetterArr = JChatContatctsDataSource.sharedInstance.friendsDic[nameLetter] as! NSMutableArray
      let friendusername = nameLetterArr[indexPath.row]
      let friend = JChatContatctsDataSource.sharedInstance.contactUser(with: friendusername as! String)
      
      userDetailVC.user = friend?.user
      self.navigationController?.pushViewController(userDetailVC, animated: true)
    }
  }

}

extension JChatContactsViewController: UIGestureRecognizerDelegate {
  
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
//    let filterArr = JChatContatctsDataSource.sharedInstance.filterFriends(with: searchText)
    JChatContatctsDataSource.sharedInstance.filterFriends(with: searchText) { (userArr) in
      let filterArr = userArr as! [JMSGUser]
      self.filtContactViewCtr.filterContactArr = filterArr
    }
  }
}

extension JChatContactsViewController: JMessageDelegate {
  
  func onReceive(_ event: JMSGNotificationEvent!) {
    
    switch event.eventType {
    case .acceptedFriendInvitation:
      let fromeUser = (event as! JMSGFriendNotificationEvent).getFromUser()
      JChatDataBaseManager.sharedInstance.addContact(currentUser: JMSGUser.myInfo().username, with: (fromeUser?.username)!)
      JChatContatctsDataSource.sharedInstance.addUser(with: (fromeUser?.username)!)
      
      let friendEvent = (event as! JMSGFriendNotificationEvent)
      JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: fromeUser!.username, reason: friendEvent.getReason()!, invitationType: JChatFriendEventNotificationType.acceptedFriendInvitation.rawValue)
      break
    case .receiveFriendInvitation:
      let fromeUser = (event as! JMSGFriendNotificationEvent).getFromUser()
      let friendEvent = (event as! JMSGFriendNotificationEvent)
      JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: fromeUser!.username, reason: friendEvent.getReason()!, invitationType: JChatFriendEventNotificationType.receiveFriendInvitation.rawValue)
      break
    case .declinedFriendInvitation:
      let fromeUser = (event as! JMSGFriendNotificationEvent).getFromUser()
      let friendEvent = (event as! JMSGFriendNotificationEvent)
      JChatDataBaseManager.sharedInstance.addInvitation(currentUser: JMSGUser.myInfo().username, with: fromeUser!.username, reason: friendEvent.getReason()!, invitationType: JChatFriendEventNotificationType.declinedFriendInvitation.rawValue)
      
      break
    case .deletedFriend:
      let fromeUser = (event as! JMSGFriendNotificationEvent).getFromUser()
      
      let friendEvent = (event as! JMSGFriendNotificationEvent)
      JChatDataBaseManager.sharedInstance.deleteInvitation(currentUser: JMSGUser.myInfo().username, with: fromeUser!.username)
      JChatContatctsDataSource.sharedInstance.deleteUser(with: (fromeUser?.username)!)
      self.contactsList.reloadData()
      break

    default:
      break
    }
  }
  

}

extension JChatContactsViewController: UIAlertViewDelegate {
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 0 { return }
    let username = alertView.textField(at: 0)?.text
    if username == "" {
      MBProgressHUD .showMessage("请输入用户名", view: self.view)
      return
    } else {
      JMSGUser.userInfoArray(withUsernameArray:[username!] , completionHandler: { (userArr, error) in
          if error != nil { return }
          if userArr == nil {
            MBProgressHUD.showMessage("该用户不存在", view: self.view)
            return
          }
          
          let userDetailVC = JChatFriendDetailViewController()
          userDetailVC.hidesBottomBarWhenPushed = true
          userDetailVC.isGroupFlag = false
          userDetailVC.user = (userArr as! NSArray)[0] as! JMSGUser
          self.navigationController?.pushViewController(userDetailVC, animated: true)
        })
    }
  }
}
