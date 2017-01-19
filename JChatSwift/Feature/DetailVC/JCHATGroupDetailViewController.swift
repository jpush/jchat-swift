//
//  JCHATGroupDetailViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

private var CellIdentifier = ""
internal let kAlertViewTagClearChatRecord = 100
internal let kAlertViewTagRenameGroup = 200
internal let kAlertViewTagAddMember = 300
internal let kAlertViewTagQuitGroup = 400

class JCHATGroupDetailViewController: UIViewController {
  weak var chattingVC:JChatChattingViewController!
  weak var conversation:JMSGConversation!
  var memberArr:NSMutableArray!
  var groupMemberGrip:UICollectionView!
  var isInEditing:Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isInEditing = false
    self.view.backgroundColor = UIColor.white
    self.setupNavigationBar()
    self.setupGroupMemberGrip()
    self.refreshMemberGrid()
  }

  func setupNavigationBar() {
    self.title = "群详情"
    self.navigationController?.navigationBar.isTranslucent = false
    
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
  }
  
  func backClick() {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func refreshMemberGrid() {
    self.getAllMember()
    self.groupMemberGrip.reloadData()
  }
  
  func setupGroupMemberGrip() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.sectionInset = UIEdgeInsets(top: 23, left: 20, bottom: 35, right: 20)
    self.groupMemberGrip = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    self.view.addSubview(self.groupMemberGrip)
    self.groupMemberGrip.snp.makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.view)
    }
    self.groupMemberGrip.backgroundColor = UIColor.clear
    self.groupMemberGrip.delegate = self
    self.groupMemberGrip.dataSource = self
    self.groupMemberGrip.minimumZoomScale = 0
    self.groupMemberGrip.register(
      UINib(nibName: "JCHATMemberCollectionCell", bundle: nil),
      forCellWithReuseIdentifier: "JCHATMemberCollectionCell")
    
    self.groupMemberGrip.register(
      UINib(nibName: "JCHATCollectionFootTableView", bundle: nil),
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "JCHATCollectionFootTableView")
    
    self.groupMemberGrip.backgroundView = UIView()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBackgroup))
    self.groupMemberGrip.backgroundView?.addGestureRecognizer(tapGesture)
    
  }

  func tapBackgroup() {
    self.removeEditStatus()
  }
  
  func removeEditStatus() {
    self.isInEditing = false
    self.groupMemberGrip.reloadData()
  }

  func tapToAddMember() {
//    let alertView = UIAlertView(
//      title: "添加好友进群",
//      message: "输入好友用户名!",
//      delegate: self,
//      cancelButtonTitle: "取消",
//      otherButtonTitles: "确定")
//    
//    alertView.tag = kAlertViewTagAddMember
//    alertView.alertViewStyle = .plainTextInput
//    alertView.show()

    switch self.conversation.conversationType {
    case .single:
      let selectFriendVC = JChatContactsViewController(isSelect: true, defaulSelected: [(self.conversation.target as! JMSGUser).username]) { (users) in
        let usernameArr = JChatContatctsDataSource.sharedInstance.usernameArr(with: users as! [JChatFriendModel])
        self.createGroup(usernameArr as! [String])
      }
      self.navigationController?.pushViewController(selectFriendVC, animated: true)
      break
    case .group:
      let userArr = JMSGGroup.memberArray(self.conversation.target as! JMSGGroup)
      let userNameArr = self.userNameArr(with: userArr())
      let selectFriendVC = JChatContactsViewController(isSelect: true, defaulSelected: userNameArr) { (users) in
        
        MBProgressHUD.showMessage("正在添加成员", toView: self.view)
        let usernameArr = JChatContatctsDataSource.sharedInstance.usernameArr(with: users as! [JChatFriendModel])
        
        (self.conversation?.target as! JMSGGroup).addMembers(withUsernameArray: usernameArr as! [String], completionHandler: {[weak weakSelf = self] (resultObject, error) -> Void in
          let lastVC = self.navigationController?.viewControllers.last
          lastVC?.navigationController?.popViewController(animated: true)
          
          MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
          if error == nil {
            MBProgressHUD.showMessage("添加成功", view: self.view)
            weakSelf!.refreshMemberGrid()
          } else {
            MBProgressHUD.showMessage("添加失败", view: self.view)
            print("addMembersFromUsernameArray fail")
          }
          
        })

      }
      self.navigationController?.pushViewController(selectFriendVC, animated: true)
      break
    }
    
//    let selectFriendVC = JChatContactsViewController(isSelect: true, defaulSelected: [(self.conversation.target as! JMSGUser).username]) { (users) in
//      
//      let usernameArr = JChatContatctsDataSource.sharedInstance.usernameArr(with: users as! [JChatFriendModel])
//      
//      switch self.conversation.conversationType {
//      case .single:
//        self.createGroup(usernameArr as! [String])
//        break
//      case .group:
//        MBProgressHUD.showMessage("正在添加成员", toView: self.view)
//        (self.conversation?.target as! JMSGGroup).addMembers(withUsernameArray: usernameArr as! [String], completionHandler: {[weak weakSelf = self] (resultObject, error) -> Void in
//          MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
//          if error == nil {
//            MBProgressHUD.showMessage("添加成功", view: self.view)
//            weakSelf!.refreshMemberGrid()
//          } else {
//            MBProgressHUD.showMessage("添加失败", view: self.view)
//            print("addMembersFromUsernameArray fail")
//          }
//        })
//        break
//      }
//    }
    
  }
  
  func tapToEditGroupName() {
    let alertView = UIAlertView(
      title: "输入群名称",
      message: "",
      delegate: self,
      cancelButtonTitle: "取消",
      otherButtonTitles: "确定")
    
    alertView.tag = kAlertViewTagRenameGroup
    alertView.alertViewStyle = .plainTextInput
    alertView.show()
    self.removeEditStatus()
  }

  func tapToClearChatRecord() {
    let alertView = UIAlertView(
      title: "清空聊天记录",
      message: "",
      delegate: self,
      cancelButtonTitle: "取消",
      otherButtonTitles: "确定")
    
    alertView.tag = kAlertViewTagClearChatRecord
    alertView.show()
    self.removeEditStatus()
  }

  func tapToQuitGroup() {
    let alertView = UIAlertView(
      title: "是否要退出群组",
      message: "",
      delegate: self,
      cancelButtonTitle: "取消",
      otherButtonTitles: "确定")
    
    alertView.tag = kAlertViewTagQuitGroup
    alertView.show()
    self.removeEditStatus()
  }
  
  func getAllMember() {
    switch self.conversation.conversationType {
    case .single:
      self.memberArr = [(self.conversation.target as! JMSGUser)]
      break
    case .group:
      self.memberArr = NSMutableArray(array: (self.conversation?.target as! JMSGGroup).memberArray())
      break
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  deinit {
    print("")
  }
}

extension JCHATGroupDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.conversation.conversationType {
    case .single:
      return self.memberArr.count + 1
    case .group:
      if section != 0 { return 0 }
      
      let group = (self.conversation?.target) as! JMSGGroup // TODO: user group
      if group.owner == JMSGUser.myInfo().username {
        return self.memberArr.count + 2
      } else {
        return self.memberArr.count + 1
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    return CGSize(width: 52, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int) -> CGSize {
      return CGSize(width: UIScreen.main.bounds.size.width, height: 200)
  }
 
  func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      CellIdentifier = "JCHATMemberCollectionCell"
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! JCHATMemberCollectionCell
      
      switch (indexPath as NSIndexPath).item {
      case self.memberArr.count + 1:
        cell.setDeleteMember()
        break
      case self.memberArr.count:
        cell.setAddMember()
        break
      default:
        let user = self.memberArr.object(at: (indexPath as NSIndexPath).item) as! JMSGUser
        switch self.conversation.conversationType {
        case .single:
          cell.setCellData(user, isDeleting: false)
          break
        case .group:
          let group = self.conversation?.target as! JMSGGroup
          
          if group.owner == user.username {
            cell.setCellData(user, isDeleting: false)
          } else {
            cell.setCellData(user, isDeleting: self.isInEditing)
          }
          break
        }

        break
      }
      return cell
  }

  func collectionView(_ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath) -> UICollectionReusableView {
      CellIdentifier = "JCHATCollectionFootTableView"
      let footTable = self.groupMemberGrip.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CellIdentifier, for: indexPath) as! JCHATCollectionFootTableView
      footTable.footTable.delegate = self
      footTable.footTable.dataSource = self
      footTable.footTable.reloadData()
      return footTable
  }
  
  func collectionView(_ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      switch (indexPath as NSIndexPath).item {
      case self.memberArr.count: // 添加成员
        self.isInEditing = false
        self.groupMemberGrip.reloadData()
        self.tapToAddMember()
        break
      case self.memberArr.count + 1:  // 删除成员
        self.isInEditing = !self.isInEditing
        self.groupMemberGrip.reloadData()
        break
      default:  // 点击群成员头像

        if self.conversation.conversationType == .single {
          // TODO: add push to my JChatPersonViewController
          
        } else {
          let user = self.memberArr[(indexPath as NSIndexPath).item] as! JMSGUser
          let group = self.conversation?.target as! JMSGGroup
          
          if self.isInEditing == true {
            if user.username == group.owner { return }
            
            let beDeletedUser = self.memberArr[(indexPath as NSIndexPath).item] as! JMSGUser
            self.deleteMemberWithUserName(beDeletedUser.username)
          } else {
            if user.username == JMSGUser.myInfo().username {
              // TODO: push to JC HATPersonViewController
//              let mydetailVC = jchatper
              let mydetailVC = JChatUserInfoViewController()
              self.navigationController?.pushViewController(mydetailVC, animated: true)
            } else {
              let friendDetail = JChatFriendDetailViewController()
              friendDetail.user = user
              friendDetail.isGroupFlag = true
              self.navigationController?.pushViewController(friendDetail, animated: true)
            }
          }
        }

        break
      }
      
  }
  
  func deleteMemberWithUserName(_ userName:String) {
    if memberArr.count == 1 { return }
    
    MBProgressHUD.showMessage("正在删除好友！", toView: self.view)
    (self.conversation?.target as! JMSGGroup).removeMembers(withUsernameArray: [userName]) { (resultObject, error) -> Void in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error == nil {
        MBProgressHUD.showMessage("删除成员成功！", view: self.view)
        self.refreshMemberGrid()
      } else {
        print("removeMembersWithUsernameArray fail with error \(NSString.errorAlert(error as! NSError))")
        MBProgressHUD.showMessage("删除成员错误！", view: self.view)
      }
    }
  }
}

extension JCHATGroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let identify = "JChatFootTableTableViewCell"
    var cell:JChatFootTableTableViewCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFootTableTableViewCell
    
    if cell == nil {
      tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFootTableTableViewCell
    }
  
    if self.conversation?.conversationType == .group {
      switch (indexPath as NSIndexPath).row {
      case 0:
        cell?.setDataWithGroupName((self.conversation?.target as! JMSGGroup).displayName())
        break
      case 1:
        cell?.layoutToClearChatRecord()
        break
      default:
        cell?.cellDelegate = self
        cell?.layoutToQuitGroup()
        break
      }
    } else {
      cell?.layoutToClearChatRecord()
    }
    return cell!
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch self.conversation.conversationType {
    case .single:
      return 1
    case .group:
      return 3
    }

  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    if self.conversation?.conversationType == .group {
      switch (indexPath as NSIndexPath).row {
      case 0:
        self.tapToEditGroupName()
        break
      case 1:
        self.tapToClearChatRecord()
        break
      default:
        
        break
      }
    } else {
      self.tapToClearChatRecord()
      print("clear record")
    }
  }
  
  func tableView(_ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
  }
  
}


extension JCHATGroupDetailViewController: UIAlertViewDelegate {
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 0 { return }
    switch alertView.tag {
    case kAlertViewTagClearChatRecord:
      if buttonIndex == 1 {  self.conversation?.deleteAllMessages() }
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
      break
    case kAlertViewTagAddMember:
      let userName = alertView.textField(at: 0)?.text
      if userName == "" { return }
//      switch self.conversation.conversationType {
//      case .single:
//        self.createGroup((alertView.textField(at: 0)?.text)!)
//        break
//      case .group:
////        MBProgressHUD.showMessage("正在添加 \(userName!)", toView: self.view)
////        (self.conversation?.target as! JMSGGroup).addMembers(withUsernameArray: [userName!], completionHandler: {[weak weakSelf = self] (resultObject, error) -> Void in
////          MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
////          if error == nil {
////            MBProgressHUD.showMessage("添加成功", view: self.view)
////            weakSelf!.refreshMemberGrid()
////          } else {
////            MBProgressHUD.showMessage("添加失败", view: self.view)
////            print("addMembersFromUsernameArray fail")
////          }
////          })
//        break
//      }

      break
    case kAlertViewTagQuitGroup:
      MBProgressHUD.showMessage("正在推出群组！", toView: self.view)
      let deletedGroup = self.conversation?.target as! JMSGGroup
      let deleteGid = deletedGroup.gid
      deletedGroup.exit({[weak weakSelf = self] (resultObject, error) -> Void in
        MBProgressHUD.hideAllHUDs(for: weakSelf!.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("推出群组成功", view: weakSelf!.view)
          JMSGConversation.deleteGroupConversation(withGroupId: deleteGid)
          weakSelf?.navigationController?.popToRootViewController(animated: true)
        } else {
          MBProgressHUD.showMessage("推出群组失败", view: weakSelf!.view)
        }
      })
      break
    case kAlertViewTagRenameGroup:
      MBProgressHUD.showMessage("更新群组名称", toView: self.view)
      let needUpdateGroup = self.conversation?.target as! JMSGGroup

      JMSGGroup.updateGroupInfo(withGroupId: needUpdateGroup.gid, name: (alertView.textField(at: 0)?.text)!, desc: needUpdateGroup.desc!, completionHandler: { (resultObject, error) -> Void in
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("更新群组名称成功", view: self.view)
          self.refreshMemberGrid()
        } else {
          MBProgressHUD.showMessage("更新群组名称失败", view: self.view)
        }
      })
      break
    default:
      break
    }
  }
  
  func userNameArr(with userArr: [JMSGUser]) -> [String]{
    let userNameArr = NSMutableArray()
    for user in userArr {
      userNameArr.add(user.username)
    }
    return userNameArr as NSArray as! [String]
  }
  
  func createGroup(_ userNames:[String]) {
    MBProgressHUD.showMessage("加好友进群组", toView: self.view)
    var groupName = ""
    if userNames.count > 1 {
       groupName = "\(userNames[0]), \(userNames[1])"
    } else {
      groupName = "和 \(userNames[0]) 的群聊)"
    }
    
    JMSGGroup.createGroup(withName: groupName, desc: "", memberArray: userNames) { (group, error) -> Void in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
      if error == nil {
        MBProgressHUD.showMessage("正在创建 group converation ", toView: self.view)
        JMSGConversation.createGroupConversation(withGroupId: (group as! JMSGGroup).gid, completionHandler: { (conversation, error) -> Void in
          MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
          if error == nil {
            MBProgressHUD.showMessage("创建group conversation 成功", view: self.view)
            let groupconveration = conversation as! JMSGConversation
            
            let conversationListVC = self.navigationController!.viewControllers.first
            
            self.navigationController?.popToRootViewController(animated: false)
            
            
            let chatVC = JChatChattingViewController()
            chatVC.conversation = groupconveration
            chatVC.hidesBottomBarWhenPushed = true
            conversationListVC?.navigationController?.pushViewController(chatVC, animated: true)
            
          } else {
            print("创建group conversation 成功\(NSString.errorAlert(error as! NSError))")
            MBProgressHUD.showMessage("创建group conversation 成功", view: self.view)
          }
        })
      } else {
        print("创建group 失败  with group \(NSString.errorAlert(error as! NSError))")
        MBProgressHUD.showMessage("创建group 失败", view: self.view)
      }
    }
  }

}


extension JCHATGroupDetailViewController:JChatQuitGroupDelegate {
  func quitGroup() {
  self.tapToQuitGroup()
  }
}


extension JCHATGroupDetailViewController: UIGestureRecognizerDelegate {

}
