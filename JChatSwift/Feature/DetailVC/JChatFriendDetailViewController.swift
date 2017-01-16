//
//  JChatFriendDetailViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/8.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

let kSkipToSingleChatViewState = "SkipToSingleChatViewState"

class JChatFriendDetailViewController: UIViewController {
  var user:JMSGUser!
  var isGroupFlag:Bool?
  var isMyFriend:Bool?
  
  var infoTable:UITableView!
  var nameLabel:UILabel!
  var headView:UIImageView!
  
  var titleArr:NSArray!
  var imgArr:NSArray!
  var infoArr:NSMutableArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupNavigationBar()
    self.loadUserInfoData()
    
    self.layoutAllViews()
    
  }
  
  func setupNavigationBar() {
      self.navigationController?.interactivePopGestureRecognizer?.delegate = self
      self.title = "详情资料"
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
  
  func layoutAllViews() {

    self.view.backgroundColor = UIColor.white
    
    self.infoTable = UITableView(frame: CGRect.zero)
    self.view.addSubview(self.infoTable)
    self.infoTable.delegate = self
    self.infoTable.dataSource = self
    self.infoTable.separatorStyle = .none

    self.infoTable.snp.makeConstraints { (make) -> Void in
      make.left.bottom.right.top.equalTo(self.view)
    }
    
    let tableHeadView = UIView(frame: CGRect(x: 0, y: 0, width: kApplicationWidth, height: 150))
    tableHeadView.backgroundColor = UIColor.white
    self.headView = UIImageView()
    tableHeadView.addSubview(self.headView)
    self.headView.layer.cornerRadius = 35
    self.headView.layer.masksToBounds = true
    self.headView.snp.makeConstraints { (make) -> Void in
      make.center.equalTo(tableHeadView)
      make.size.equalTo(CGSize(width: 70, height: 70))
    }
    
    self.nameLabel = UILabel()
    self.nameLabel.text = user.displayName()
    self.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    self.nameLabel.textAlignment = .center

    tableHeadView.addSubview(nameLabel)
    self.nameLabel.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.headView.snp.bottom).offset(10)
      make.left.right.equalTo(tableHeadView)
      make.height.equalTo(19)
    }
    self.infoTable.tableHeaderView = tableHeadView
  }

  func loadUserInfoData() {
    if JChatDataBaseManager.sharedInstance.selectContact(currentUser: JMSGUser.myInfo().username, user: self.user) == "" {
      self.isMyFriend = false
    } else {
      self.isMyFriend = true
    }
    
    self.titleArr = ["性别", "地区", "个性签名"]
    self.imgArr = ["gender", "location_21", "signature"]

    self.infoArr = NSMutableArray()
    switch self.user.gender {
    case .unknown:
      self.infoArr.add("未知")
      break
    case .male:
      self.infoArr.add("男")
      break
    case .female:
      self.infoArr.add("女")
      break
      
    }
    
    if self.user.region == nil {
      self.infoArr.add("")
    } else {
      self.infoArr.add(self.user.region!)
    }
    
    if self.user.signature == nil {
      self.infoArr.add("")
    } else {
      self.infoArr.add(self.user.signature!)
    }
    
    _ = MBProgressHUD.showMessage("正在加载", toView: self.view)
    
    JMSGUser.userInfoArray(withUsernameArray: [self.user.username]) { (resultObject, error) -> Void in
      _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error == nil {
        let user = ((resultObject as! Array<JMSGUser>)[0] as! JMSGUser)
        self.user = user
        user.thumbAvatarData({ (data, objId, error) -> Void in
          if error == nil {
            if data != nil {
              self.headView.image = UIImage(data: data!)
            } else {
              self.headView.image = UIImage(named: "headDefalt")
            }
          } else {
            self.headView.image = UIImage(named: "headDefalt")
          }
        })

      } else {
        self.headView.image = UIImage(named: "headDefalt")
      }
      
      self.infoTable.reloadData()
    }
    
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


extension JChatFriendDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.isMyFriend! ? 5 : 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (indexPath as NSIndexPath).row >= 3 {
      identify = "JChatFriendDetailSendMsgCell"
      var cell:JChatFriendDetailSendMsgCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendDetailSendMsgCell
      if cell == nil {
        tableView.register(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
        cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatFriendDetailSendMsgCell
      }
      
      if indexPath.row == 3 {
        if self.isMyFriend! { //发送消息
          cell!.setClickSendMsgCallback({
            
            for var ctl in (self.navigationController?.childViewControllers)! {
              if ctl.isKind(of: JChatChattingViewController.self) {
                
                if self.isGroupFlag! {
                  self.navigationController?.popToRootViewController(animated: true)
                  NotificationCenter.default.post(name: Notification.Name(rawValue: kSkipToSingleChatViewState), object: self.user)
                } else {
                  self.navigationController?.popToViewController(ctl, animated: true)
                }
              }
              
              if ctl.isKind(of: JChatContactsViewController.self) {
                self.navigationController?.popToRootViewController(animated: false)
                JChatMainTabViewController.sharedInstance.selectedIndex = 0
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSkipToSingleChatViewState), object: self.user)
              }
            }
          })
          return cell!
        } else {
          cell?.setClickAddFriendCallback {
            let addFriendVC = JChatAddFriendViewController()
            addFriendVC.username = self.user.username
            self.navigationController?.pushViewController(addFriendVC, animated: true)
          }
          return cell!
        }
      }
      
      if indexPath.row == 4 {
        cell!.setClickDeleteCallback({
          let alertView = UIAlertView(title: "删除好友", message: "确定要删除好友 \(self.user.displayName()) 吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
          alertView.show()
        })
        return cell!
      }
      
      
    }
    
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    }
    let tittle = self.titleArr![(indexPath as NSIndexPath).row] as! String
    let imgName = self.imgArr![(indexPath as NSIndexPath).row] as! String
    let info = self.infoArr![(indexPath as NSIndexPath).row] as! String
    
    cell?.setFriendCellData(tittle, icon: imgName, info: info)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath as NSIndexPath).row == 3 {
      return 80
    }
    return 57;
  }
}

extension JChatFriendDetailViewController: UIAlertViewDelegate {
  
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 0 { return }
    MBProgressHUD.showMessage("正在删除", toView: self.view)
    JMSGFriendManager.removeFriend(withUsername: self.user.username, appKey: JMSSAGE_APPKEY, completionHandler: { (result, error) in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error != nil {
        MBProgressHUD.showMessage("删除好友失败！", view: self.view)
      }
      NotificationCenter.default.post(name: Notification.Name(rawValue: kDeleteFriendNotificaion), object: self.user.username)
      self.navigationController?.popViewController(animated: true)
    })
    
  }
}



extension JChatFriendDetailViewController: UIGestureRecognizerDelegate {

}
