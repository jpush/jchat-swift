//
//  JCHATGroupDetailViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/4.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

internal var CellIdentifier = ""
internal let kAlertViewTagClearChatRecord = 100
internal let kAlertViewTagRenameGroup = 200
internal let kAlertViewTagAddMember = 300
internal let kAlertViewTagQuitGroup = 400

class JCHATGroupDetailViewController: UIViewController {
  weak var chattingVC:JChatChattingViewController!
  var conversation:JMSGConversation!
  var memberArr:NSMutableArray!
  var groupMemberGrip:UICollectionView!
  var isEditing:Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isEditing = false
    self.view.backgroundColor = UIColor.whiteColor()
    self.setupNavigationBar()
    self.setupGroupMemberGrip()
    self.refreshMemberGrid()
  }

  func setupNavigationBar() {
    self.title = "群详情"
    self.navigationController?.navigationBar.translucent = false
  }
  
  func refreshMemberGrid() {
    self.getAllMember()
    self.groupMemberGrip.reloadData()
  }
  
  func setupGroupMemberGrip() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .Vertical
    self.groupMemberGrip = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
    self.view.addSubview(self.groupMemberGrip)
    self.groupMemberGrip.snp_makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.view)
    }
    self.groupMemberGrip.backgroundColor = UIColor.clearColor()
    self.groupMemberGrip.delegate = self
    self.groupMemberGrip.dataSource = self
    self.groupMemberGrip.minimumZoomScale = 0
    self.groupMemberGrip.registerNib(
      UINib(nibName: "JCHATMemberCollectionCell", bundle: nil),
      forCellWithReuseIdentifier: "JCHATMemberCollectionCell")
    
    self.groupMemberGrip.registerNib(
      UINib(nibName: "JCHATCollectionFootTableView", bundle: nil),
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "JCHATCollectionFootTableView")
    
    self.groupMemberGrip.backgroundView = UIView()
    let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapBackgroup"))
    self.groupMemberGrip.backgroundView?.addGestureRecognizer(tapGesture)
    
  }

  @objc func tapBackgroup() {
    self.removeEditStatus()
  }
  
  func removeEditStatus() {
    self.isEditing = false
    self.groupMemberGrip.reloadData()
  }

  func tapToAddMember() {
    let alertView = UIAlertView(
      title: "添加好友进群",
      message: "输入好友用户名!",
      delegate: self,
      cancelButtonTitle: "取消",
      otherButtonTitles: "确定")
    
    alertView.tag = kAlertViewTagAddMember
    alertView.alertViewStyle = .PlainTextInput
    alertView.show()
  }
  
  func tapToEditGroupName() {
    let alertView = UIAlertView(
      title: "输入群名称",
      message: "",
      delegate: self,
      cancelButtonTitle: "取消",
      otherButtonTitles: "确定")
    
    alertView.tag = kAlertViewTagRenameGroup
    alertView.alertViewStyle = .PlainTextInput
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
    case .Single:
      self.memberArr = [(self.conversation.target as! JMSGUser)]
      break
    case .Group:
      self.memberArr = NSMutableArray(array: (self.conversation?.target as! JMSGGroup).memberArray())
      break
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}

extension JCHATGroupDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.conversation.conversationType {
    case .Single:
      return self.memberArr.count + 1
    case .Group:
      if section != 0 { return 0 }
      
      let group = (self.conversation?.target) as! JMSGGroup // TODO: user group
      if group.owner == JMSGUser.myInfo().username {
        return self.memberArr.count + 2
      } else {
        return self.memberArr.count + 1
      }
    }
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: 52, height: 80)
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int) -> CGSize {
      return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 200)
  }
 
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      CellIdentifier = "JCHATMemberCollectionCell"
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! JCHATMemberCollectionCell
      
      switch indexPath.item {
      case self.memberArr.count + 1:
        cell.setDeleteMember()
        break
      case self.memberArr.count:
        cell.setAddMember()
        break
      default:
        let user = self.memberArr.objectAtIndex(indexPath.item) as! JMSGUser
        switch self.conversation.conversationType {
        case .Single:
          cell.setCellData(user, isDeleting: false)
          break
        case .Group:
          let group = self.conversation?.target as! JMSGGroup
          
          if group.owner == user.username {
            cell.setCellData(user, isDeleting: false)
          } else {
            cell.setCellData(user, isDeleting: self.isEditing)
          }
          break
        }

        break
      }
      return cell
  }

  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      CellIdentifier = "JCHATCollectionFootTableView"
      let footTable = self.groupMemberGrip.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: CellIdentifier, forIndexPath: indexPath) as! JCHATCollectionFootTableView
      footTable.footTable.delegate = self
      footTable.footTable.dataSource = self
      footTable.footTable.reloadData()
      return footTable
  }
  
  func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath) {
      switch indexPath.item {
      case self.memberArr.count: // 添加群成员
        self.isEditing = false
        self.groupMemberGrip.reloadData()
        self.tapToAddMember()
        break
      case self.memberArr.count + 1:  // 删除群成员
        self.isEditing = !self.isEditing
        self.groupMemberGrip.reloadData()
        break
      default:  // 点击群成员头像
        let user = self.memberArr[indexPath.item] as! JMSGUser
        let group = self.conversation?.target as! JMSGGroup
        
        if self.isEditing == true {
          if user.username == group.owner { return }
          
          let beDeletedUser = self.memberArr[indexPath.item] as! JMSGUser
          self.deleteMemberWithUserName(beDeletedUser.username)
        } else {
          if user.username == JMSGUser.myInfo().username {
          // TODO: push to JCHATPersonViewController
          } else {
          // TODO: push to JCHATFriendDetailViewController
          }
        }
        break
      }
      
  }
  
  func deleteMemberWithUserName(userName:String) {
    if memberArr.count == 1 { return }
    
    MBProgressHUD.showMessage("正在删除好友！", toView: self.view)
    (self.conversation?.target as! JMSGGroup).removeMembersWithUsernameArray([userName]) { (resultObject, error) -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      if error == nil {
        MBProgressHUD.showMessage("删除成员成功！", view: self.view)
        self.refreshMemberGrid()
      } else {
        print("removeMembersWithUsernameArray fail with error \(NSString.errorAlert(error))")
        MBProgressHUD.showMessage("删除成员错误！", view: self.view)
      }
    }
  }
}

extension JCHATGroupDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let identify = "JChatFootTableTableViewCell"
    var cell:JChatFootTableTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatFootTableTableViewCell
    
    if cell == nil {
      tableView.registerNib(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatFootTableTableViewCell
    }
  
    if self.conversation?.conversationType == .Group {
      switch indexPath.row {
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

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch self.conversation.conversationType {
    case .Single:
      return 1
    case .Group:
      return 3
    }

  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.selected = false
    if self.conversation?.conversationType == .Group {
      switch indexPath.row {
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
  
  func tableView(tableView: UITableView,
    heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return 66
  }
  
}


extension JCHATGroupDetailViewController: UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 { return }
    switch alertView.tag {
    case kAlertViewTagClearChatRecord:
      if buttonIndex == 1 {  self.conversation?.deleteAllMessages() }
      NSNotificationCenter.defaultCenter().postNotificationName(kDeleteAllMessage, object: nil)
      break
    case kAlertViewTagAddMember:
      let userName = alertView.textFieldAtIndex(0)?.text
      if userName == "" { return }
      switch self.conversation.conversationType {
      case .Single:
        self.createGroup((alertView.textFieldAtIndex(0)?.text)!)
        break
      case .Group:
        MBProgressHUD.showMessage("正在添加 \(userName!)", toView: self.view)
        (self.conversation?.target as! JMSGGroup).addMembersWithUsernameArray([userName!], completionHandler: {[weak weakSelf = self] (resultObject, error) -> Void in
          MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
          if error == nil {
            MBProgressHUD.showMessage("添加成功", view: self.view)
            weakSelf!.refreshMemberGrid()
          } else {
            MBProgressHUD.showMessage("添加失败", view: self.view)
            print("addMembersFromUsernameArray fail")
          }
          })
        break
      }

      break
    case kAlertViewTagQuitGroup:
      MBProgressHUD.showMessage("正在推出群组！", toView: self.view)
      let deletedGroup = self.conversation?.target as! JMSGGroup
      let deleteGid = deletedGroup.gid
      deletedGroup.exit({[weak weakSelf = self] (resultObject, error) -> Void in
        MBProgressHUD.hideAllHUDsForView(weakSelf!.view, animated: true)
        if error == nil {
          MBProgressHUD.showMessage("推出群组成功", view: weakSelf!.view)
          JMSGConversation.deleteGroupConversationWithGroupId(deleteGid)
          weakSelf?.navigationController?.popToRootViewControllerAnimated(true)
        } else {
          MBProgressHUD.showMessage("推出群组失败", view: weakSelf!.view)
        }
      })
      break
    case kAlertViewTagRenameGroup:
      MBProgressHUD.showMessage("更新群组名称", toView: self.view)
      let needUpdateGroup = self.conversation?.target as! JMSGGroup

      JMSGGroup.updateGroupInfoWithGroupId(needUpdateGroup.gid, name: (alertView.textFieldAtIndex(0)?.text)!, desc: needUpdateGroup.desc!, completionHandler: { (resultObject, error) -> Void in
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
  
  func createGroup(otherUserName:String) {
    MBProgressHUD.showMessage("加好友进群组", toView: self.view)
    JMSGGroup.createGroupWithName(otherUserName, desc: "", memberArray: [otherUserName, (self.conversation.target as! JMSGUser).username]) { (group, error) -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
      if error == nil {
        MBProgressHUD.showMessage("正在创建 group converation ", toView: self.view)
        JMSGConversation.createGroupConversationWithGroupId((group as! JMSGGroup).gid, completionHandler: { (conversation, error) -> Void in
          MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
          if error == nil {
            MBProgressHUD.showMessage("创建group conversation 成功", toView: self.view)
            let groupconveration = conversation as! JMSGConversation
            JMessage.removeDelegate(self.chattingVC, withConversation: self.conversation)
            self.chattingVC.conversation = groupconveration
            JMessage.addDelegate(self.chattingVC, withConversation: groupconveration)
            self.chattingVC.title = group.displayName()
            self.navigationController?.popViewControllerAnimated(true)
          } else {
            print("创建group conversation 成功\(NSString.errorAlert(error))")
            MBProgressHUD.showMessage("创建group conversation 成功", view: self.view)
          }
        })
      } else {
        print("创建group 失败  with group \(NSString.errorAlert(error))")
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