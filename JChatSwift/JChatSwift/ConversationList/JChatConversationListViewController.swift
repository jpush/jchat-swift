//
//  JChatConversationListViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

let kDBMigrateStartNotification = "DBMigrateStartNotification"
let kDBMigrateFinishNotification = "DBMigrateFinishNotification"
let kLogin_NotifiCation = "loginNotification"
let kCreatGroupState = "creatGroupState"

@objc(JChatConversationListViewController)
class JChatConversationListViewController: UIViewController {

  var conversationArr:NSMutableArray!
  var conversationListTable:UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.conversationArr = NSMutableArray()
    
    self.setupNavigation()
    self.layoutAllViews()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.getConversationList()

  }
  
  func setupNavigation() {
    self.navigationController?.navigationBar.translucent = false
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.title = "会话"
    let rightBtn = UIButton(type: .Custom)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
    rightBtn.addTarget(self, action: Selector("showBubbleView"), forControlEvents: .TouchUpInside)
    rightBtn.setImage(UIImage(named: "createConversation"), forState: .Normal)
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15 * UIScreen.mainScreen().scale)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    
  }

  @objc func showBubbleView() {
    if (JChatAlertViewManager.sharedInstance.isShowing == true) {
      JChatAlertViewManager.sharedInstance.hidenAll()
    } else {
      JChatAlertViewManager.sharedInstance.showBubbleBtn(inView: self.view, delegate: self)
    }
  }
  
  func layoutAllViews() {
    self.conversationListTable = UITableView()
    self.conversationListTable.tableFooterView = UIView()
    self.conversationListTable.delegate = self
    self.conversationListTable.dataSource = self
    self.conversationListTable.estimatedRowHeight = 60
    self.conversationListTable.rowHeight = UITableViewAutomaticDimension
    self.view.addSubview(self.conversationListTable)
    self.conversationListTable.snp_makeConstraints { (make) -> Void in
      make.top.right.left.bottom.equalTo(self.view)
    }
  }

  func getConversationList() {
    JMSGConversation.allConversations { (resultObject, error) -> Void in
      if error == nil {
        self.conversationArr.removeAllObjects()
        self.conversationArr.addObjectsFromArray(resultObject as! [AnyObject])
      } else {
        self.conversationArr.removeAllObjects()
      }
      self.conversationListTable.reloadData()
    }
  }
  
  func addNotifications() {

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("netWorkConnectClose"), name: kJPFNetworkDidCloseNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("netWorkConnectSetup"), name: kJPFNetworkDidSetupNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectSucceed"), name: kJPFNetworkDidCloseNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("isConnecting"), name: kJPFNetworkIsConnectingNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dBMigrateFinish"), name: kDBMigrateFinishNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("alreadyLoginClick"), name: kLogin_NotifiCation, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("creatGroupSuccessToPushView:"), name: kCreatGroupState, object: nil)
  }
  
  @objc func netWorkConnectClose() {
    self.title = "未连接"
  }

  @objc func netWorkConnectSetup() {
    self.title = "收取中.."
  }
  
  @objc func connectSucceed() {
     self.title = "会话"
  }
  
  @objc func isConnecting() {
    self.title = "链接中.."
  }
  
  @objc func dBMigrateFinish() {

  }
  
  @objc func alreadyLoginClick() {

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}


extension JChatConversationListViewController: UITableViewDataSource,UITableViewDelegate {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let identify = "JChatConversationListCell"
    var cell:JChatConversationListCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatConversationListCell
    
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatConversationListCell
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatConversationListCell
    }
    
    cell?.setCellData(self.conversationArr.objectAtIndex(indexPath.row) as! JMSGConversation)
    return cell!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.conversationArr.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.selected = false
    
    let chattingVC = JChatChattingViewController()
    chattingVC.hidesBottomBarWhenPushed = true
    chattingVC.conversation = self.conversationArr.objectAtIndex(indexPath.row) as! JMSGConversation
    self.navigationController?.pushViewController(chattingVC, animated: true)
  }

}


extension JChatConversationListViewController: UIGestureRecognizerDelegate {

}


extension JChatConversationListViewController: JChatBubbleAlertViewDelegate {
  func clickBubbleFristBtn() {
    MBProgressHUD.showMessage("正在创建群组", toView: self.view)
    JMSGGroup.createGroupWithName(JMSGUser.myInfo().displayName(), desc: "", memberArray: nil) { (group, error) -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      if error == nil {
        JMSGConversation.createGroupConversationWithGroupId((group as! JMSGGroup).gid, completionHandler: { (groupConversation, error) -> Void in
          
          if error == nil {
            let conversationVC = JChatChattingViewController()
            conversationVC.conversation = groupConversation as! JMSGConversation
            conversationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(conversationVC, animated: true)
          } else {
            print("createGroup error with \(NSString.errorAlert(error))")
          }
        })

      } else {
        print("createGroup error with \(NSString.errorAlert(error))")
      }

    }
  }
  
  func clickBubbleSecondBtn() {
    let alertView = UIAlertView(title: "添加好友", message: "输入好友用户名!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
    alertView.alertViewStyle = .PlainTextInput
    alertView.show()
  }
}


extension JChatConversationListViewController: UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if buttonIndex == 0 { return }

    if alertView.textFieldAtIndex(0)?.text == "" {
      MBProgressHUD .showMessage("请输入用户名", view: self.view)
      return
    } else {
      MBProgressHUD.showMessage("正在创建单聊", toView: self.view)
      JMSGConversation.createSingleConversationWithUsername((alertView.textFieldAtIndex(0)?.text)!, completionHandler: { (singleConversation, error) -> Void in
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
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