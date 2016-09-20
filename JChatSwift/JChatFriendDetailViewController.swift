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
  
  var infoTable:UITableView!
  var nameLabel:UILabel!
  var headView:UIImageView!
  
  var titleArr:NSArray!
  var imgArr:NSArray!
  var infoArr:NSMutableArray!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupNavigationBar()
    self.layoutAllViews()
    self.loadUserInfoData()
  }
  
  func setupNavigationBar() {
      self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//      self.navigationController?.navigationBar.translucent = false
      self.title = "详情资料"
      let leftBtn = UIButton(type: .Custom)
      leftBtn.frame = kNavigationLeftButtonRect
      leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
      leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
      leftBtn.addTarget(self, action: #selector(self.backClick), forControlEvents: .TouchUpInside)
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
  }
  
  func backClick() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func layoutAllViews() {

    self.view.backgroundColor = UIColor.whiteColor()
    
    self.infoTable = UITableView(frame: CGRectZero)
    self.view.addSubview(self.infoTable)
    self.infoTable.delegate = self
    self.infoTable.dataSource = self
    self.infoTable.separatorStyle = .None

    self.infoTable.snp_makeConstraints { (make) -> Void in
      make.left.bottom.right.top.equalTo(self.view)
    }
    
    let tableHeadView = UIView(frame: CGRect(x: 0, y: 0, width: kApplicationWidth, height: 150))
    tableHeadView.backgroundColor = UIColor.whiteColor()
    self.headView = UIImageView()
    tableHeadView.addSubview(self.headView)
    self.headView.layer.cornerRadius = 35
    self.headView.layer.masksToBounds = true
    self.headView.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(tableHeadView)
      make.size.equalTo(CGSize(width: 70, height: 70))
    }
    
    self.nameLabel = UILabel()
    self.nameLabel.text = user.displayName()
    self.nameLabel.font = UIFont.boldSystemFontOfSize(18)
    self.nameLabel.textAlignment = .Center

    tableHeadView.addSubview(nameLabel)
    self.nameLabel.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.headView.snp_bottom).offset(10)
      make.left.right.equalTo(tableHeadView)
      make.height.equalTo(19)
    }
    self.infoTable.tableHeaderView = tableHeadView
  }

  func loadUserInfoData() {
    self.titleArr = ["性别", "地区", "个性签名"]
    self.imgArr = ["gender", "location_21", "signature"]

    self.infoArr = NSMutableArray()
    switch self.user.gender {
    case .Unknown:
      self.infoArr.addObject("未知")
      break
    case .Male:
      self.infoArr.addObject("男")
      break
    case .Female:
      self.infoArr.addObject("女")
      break
      
    }
    
    if self.user.region == nil {
      self.infoArr.addObject("")
    } else {
      self.infoArr.addObject(self.user.region!)
    }
    
    if self.user.signature == nil {
      self.infoArr.addObject("")
    } else {
      self.infoArr.addObject(self.user.signature!)
    }
    
    
    MBProgressHUD.showMessage("正在加载", toView: self.view)
    JMSGUser.userInfoArrayWithUsernameArray([self.user.username]) { (resultObject, error) -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      let arr = ["adsf","sadf"] as Array
      print(arr[0])
      
      if error == nil {
        let user = (resultObject as! Array<JMSGUser>)[0]
        user.thumbAvatarData({ (data, objId, error) -> Void in
          if error == nil {
            if data != nil {
              self.headView.image = UIImage(data: data)
            } else {
              self.headView.image = UIImage(named: "headDefalt")
            }
          } else {
            self.headView.image = UIImage(named: "headDefalt")
            MBProgressHUD.showMessage("获取数据失败", view: self.view)
          }
        })

      } else {
        self.headView.image = UIImage(named: "headDefalt")
        MBProgressHUD.showMessage("获取数据失败", view: self.view)
      }
      self.infoTable.reloadData()
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


extension JChatFriendDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row == 3 {
      identify = "JChatFriendDetailSendMsgCell"
      var cell:JChatFriendDetailSendMsgCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatFriendDetailSendMsgCell
      if cell == nil {
        tableView.registerNib(UINib(nibName: identify, bundle: nil), forCellReuseIdentifier: identify)
        cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatFriendDetailSendMsgCell
      }
      cell!.setClickSendMsgCallback({
        
        for var ctl in (self.navigationController?.childViewControllers)! {
          if ctl.isKindOfClass(JChatChattingViewController) {
            
            if self.isGroupFlag! {
              self.navigationController?.popToRootViewControllerAnimated(true)
              NSNotificationCenter.defaultCenter().postNotificationName(kSkipToSingleChatViewState, object: self.user)
            } else {
              self.navigationController?.popToViewController(ctl, animated: true)
            }
          }
        }
      })
      return cell!
    }
    
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    }
    let tittle = self.titleArr![indexPath.row] as! String
    let imgName = self.imgArr![indexPath.row] as! String
    let info = self.infoArr![indexPath.row] as! String
    
    cell?.setFriendCellData(tittle, icon: imgName, info: info)
    return cell!
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 3 {
      return 80
    }
    return 57;
  }
}


extension JChatFriendDetailViewController: UIGestureRecognizerDelegate {

}
