//
//  JChatConversationListViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD


@objc(JChatConversationListViewController)
class JChatConversationListViewController: UIViewController {

  var conversationArr:NSMutableArray!
  var conversationListTable:JChatConversationTable!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.conversationArr = NSMutableArray()
    JMessage.add(self, with: nil)
    self.setupNavigation()
    self.layoutAllViews()
    self.addNotifications()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getConversationList()
  }
  
  func setupNavigation() {
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.title = "会话"
    let rightBtn = UIButton(type: .custom)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
    rightBtn.addTarget(self, action: #selector(self.showBubbleView), for: .touchUpInside)
    rightBtn.setImage(UIImage(named: "createConversation"), for: UIControlState())
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15 * UIScreen.main.scale)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    
  }

  func showBubbleView() {
    if (JChatAlertViewManager.sharedInstance.isShowing == true) {
      JChatAlertViewManager.sharedInstance.hidenAll()
    } else {
      JChatAlertViewManager.sharedInstance.showBubbleBtn(inView: self.view, delegate: self)
    }
  }
  
  func hiddenBubbleView() {
    JChatAlertViewManager.sharedInstance.hidenAll()
  }
  
  func layoutAllViews() {
    self.conversationListTable = JChatConversationTable()
    self.conversationListTable.touchDelegate = self
    self.conversationListTable.tableFooterView = UIView()
    self.conversationListTable.delegate = self
    self.conversationListTable.dataSource = self
    self.conversationListTable.estimatedRowHeight = 60
    self.conversationListTable.rowHeight = UITableViewAutomaticDimension
    self.view.addSubview(self.conversationListTable)
    self.conversationListTable.snp.makeConstraints { (make) -> Void in
      make.top.right.left.bottom.equalTo(self.view)
    }
  }

  func getConversationList() {
    JMSGConversation.allConversations { (resultObject, error) -> Void in
      if error == nil {
        self.conversationArr.removeAllObjects()
        self.conversationArr.addObjects(from: (resultObject as! [AnyObject]).reversed())
      } else {
        self.conversationArr.removeAllObjects()
      }
      self.conversationListTable.reloadData()
    }
  }
  
  func addNotifications() {

    NotificationCenter.default.addObserver(self, selector: #selector(self.netWorkConnectClose), name: NSNotification.Name.jpfNetworkDidClose, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.netWorkConnectSetup), name: NSNotification.Name.jpfNetworkDidSetup, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.connectSucceed), name: NSNotification.Name.jpfNetworkDidClose, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.isConnecting), name: NSNotification.Name.jpfNetworkIsConnecting, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.dBMigrateFinish), name: NSNotification.Name(rawValue: kDBMigrateFinishNotification), object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.alreadyLoginClick), name: NSNotification.Name(rawValue: kLogin_NotifiCation), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.skipToSingleChat(_:)), name: NSNotification.Name(rawValue: kSkipToSingleChatViewState), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.didLoginJpush), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
  }
  
  func skipToSingleChat(_ notification:Notification) {
    let user:JMSGUser = (notification.object as AnyObject) as! JMSGUser
    let singleChatVC = JChatChattingViewController()
    
    JMSGConversation.createSingleConversation(withUsername: user.username) { (resultObject, error) in
      if error == nil {
        singleChatVC.conversation = resultObject as! JMSGConversation
        singleChatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(singleChatVC, animated: true)
      } else {
        print("fail to create single conversation")
      }
    }
    
  }
  
  func netWorkConnectClose() {
    
    DispatchQueue.main.async {
      self.title = "未连接"
    }
  }

  func didLoginJpush() {
    DispatchQueue.main.async {
      self.title = "会话"
    }
  }
  func netWorkConnectSetup() {
    DispatchQueue.main.async {
      self.title = "收取中.."
    }
  }
  
  func connectSucceed() {
    DispatchQueue.main.async {
      self.title = "会话"
    }
 
  }
  
  func isConnecting() {
    DispatchQueue.main.async { 
      self.title = "链接中.."
    }
    
  }
  
  func dBMigrateFinish() {

  }
  
  func alreadyLoginClick() {

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}

extension JChatConversationListViewController: TouchTableViewDelegate {
  func TableViewTouchBegin() {
    self.hiddenBubbleView()
  }
}


extension JChatConversationListViewController: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identify = "JChatConversationListCell"
    var cell:JChatConversationListCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatConversationListCell
    
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatConversationListCell
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatConversationListCell
    }
    
    cell?.setCellData(self.conversationArr.object(at: (indexPath as NSIndexPath).row) as! JMSGConversation)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.conversationArr.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    let chattingVC = JChatChattingViewController()
    chattingVC.hidesBottomBarWhenPushed = true
    chattingVC.conversation = self.conversationArr.object(at: (indexPath as NSIndexPath).row) as! JMSGConversation
    self.navigationController?.pushViewController(chattingVC, animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let conversation = self.conversationArr[(indexPath as NSIndexPath).row] as! JMSGConversation
    
    if conversation.conversationType == .single {
      JMSGConversation.deleteSingleConversation(withUsername: (conversation.target as! JMSGUser).username)
    } else {
      JMSGConversation.deleteGroupConversation(withGroupId: (conversation.target as! JMSGGroup).gid)
    }
    
    self.conversationArr.removeObject(at: (indexPath as NSIndexPath).row)
    tableView.deleteRows(at: [indexPath], with: .none)
  }
}


extension JChatConversationListViewController: UIGestureRecognizerDelegate {

}


extension JChatConversationListViewController: JChatBubbleAlertViewDelegate {
  func clickBubbleFristBtn() {
    MBProgressHUD.showMessage("正在创建群组", toView: self.view)
    JMSGGroup.createGroup(withName: JMSGUser.myInfo().displayName(), desc: "", memberArray: nil) { (group, error) -> Void in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error == nil {
        JMSGConversation.createGroupConversation(withGroupId: (group as! JMSGGroup).gid, completionHandler: { (groupConversation, error) -> Void in
          
          if error == nil {
            let conversationVC = JChatChattingViewController()
            conversationVC.conversation = groupConversation as! JMSGConversation
            conversationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(conversationVC, animated: true)
          } else {
            print("createGroup error with \(NSString.errorAlert(error as! NSError))")
          }
        })

      } else {
        print("createGroup error with \(NSString.errorAlert(error as! NSError))")
      }

    }
  }
  
  func clickBubbleSecondBtn() {
    let alertView = UIAlertView(title: "添加好友", message: "输入好友用户名!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
    alertView.alertViewStyle = .plainTextInput
    alertView.show()
  }
}


extension JChatConversationListViewController: UIAlertViewDelegate {
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if buttonIndex == 0 { return }

    if alertView.textField(at: 0)?.text == "" {
      MBProgressHUD .showMessage("请输入用户名", view: self.view)
      return
    } else {
      MBProgressHUD.showMessage("正在创建单聊", toView: self.view)
      JMSGConversation.createSingleConversation(withUsername: (alertView.textField(at: 0)?.text)!, completionHandler: { (singleConversation, error) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
          MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        })
        
        if error == nil {
          let chattingVC = JChatChattingViewController()
          chattingVC.hidesBottomBarWhenPushed = true
          chattingVC.conversation = singleConversation as! JMSGConversation
          self.navigationController?.pushViewController(chattingVC, animated: true)
          
        } else {
          MBProgressHUD.showMessage("添加的用户不存在", view: self.view)
        }
      })
    }
  }
}


extension JChatConversationListViewController: JMessageDelegate {

  func onReceive(_ message: JMSGMessage!, error: NSError!) {
    print("Action -- onReceivemessage \(message)")
    self.getConversationList()
    
  }
  func onConversationChanged(_ conversation: JMSGConversation!) {
    print("Action -- onConversationChanged")
    self.getConversationList()
  }

  func onGroupInfoChanged(_ group: JMSGGroup!) {
    print("Action -- onGroupInfoChanged")
    self.getConversationList()
  }


}
