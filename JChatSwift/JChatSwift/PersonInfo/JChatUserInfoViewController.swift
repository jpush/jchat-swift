//
//  JChatUserInfoViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/1.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JChatUserInfoViewController: UIViewController {

  var personTable:UITableView!
  var titleArr:NSArray!
  var imgArr:NSArray!
  var infoArr:NSMutableArray!
  
  var genderPicker:UIPickerView!
  var pickerDataArr:NSArray!
  var genderNumber:NSNumber!
  var selectFlagGender:Bool!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.setupDataSource()
    self.layoutAllViews()
  }
  
  func layoutAllViews() {
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.translucent = false
    self.title = "个人信息"
    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: Selector("backClick"), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)

    self.personTable = UITableView()
    self.personTable.tableFooterView = UIView()
    self.personTable.separatorStyle = .None
    self.personTable.delegate = self
    self.personTable.dataSource = self
    self.personTable.scrollEnabled = false
    self.view.addSubview(self.personTable)
    let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("clickTable"))
    self.personTable.backgroundView = UIView()
    self.personTable.backgroundView!.addGestureRecognizer(gesture)
    
    self.personTable.snp_makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.view)
    }
    
    self.genderPicker = UIPickerView()
    self.genderPicker.delegate = self
    self.genderPicker.dataSource = self
    self.view.addSubview(self.genderPicker)
    self.genderPicker.snp_makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
      make.height.right.equalTo(100)
      make.bottom.equalTo(self.view).offset(100)
    }
  }
  
  @objc func backClick() {
    self.navigationController?.popViewControllerAnimated(true)
  }

  @objc func clickTable() {

    if selectFlagGender! {
      JMSGUser.updateMyInfoWithParameter(self.genderNumber, userFieldType: .FieldsGender, completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          print("Action update gender success")
        } else {
          print("Action update gender fail")
        }
      })
    }
    self.showSelectGenderView(false)
  }

  func setupDataSource() {
    self.selectFlagGender = false
    var name:String? = ""
    let user = JMSGUser.myInfo()
    if user.nickname == nil {
      name = user.username
    } else {
      name = user.nickname
    }
    
    self.titleArr = ["昵称", "性别", "地区", "个性签名"];
    self.imgArr = ["wo_20", "gender", "location_21", "signature"];
    self.pickerDataArr = ["男", "女"];
    self.loadUserInfoData()
  }
  
  func loadUserInfoData() {
    self.infoArr = NSMutableArray()
    var name:String? = ""
    let user = JMSGUser.myInfo()
    if user.nickname == nil {
      name = user.username
    } else {
      name = user.nickname
    }
    self.infoArr.addObject(name!)
    self.genderNumber = 1
    switch user.gender {
    case .Unknown:
      self.infoArr.addObject("未知")
      break
    case .Female:
      self.infoArr.addObject("女")
      break
    default:
      self.infoArr.addObject("男")
      break
    }
    
    if user.region != nil {
      self.infoArr.addObject(user.region!)
    } else {
      self.infoArr.addObject("")
    }
    
    if user.signature != nil {
      self.infoArr.addObject(user.signature!)
    } else {
      self.infoArr.addObject("")
    }
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JChatUserInfoViewController: UIPickerViewDataSource, UIPickerViewDelegate {

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerDataArr.count
  }

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerDataArr[row] as? String
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 && row == 0 {
      self.genderNumber = 1
      self.infoArr[1] = "男"
    } else {
      if component == 0 && row == 1 {
        self.genderNumber = 2
        self.infoArr[1] = "女"
      } else {
        self.genderNumber = 0
      }
    }
    self.personTable.reloadData()
  }

  
}

extension JChatUserInfoViewController: UIGestureRecognizerDelegate {

}

extension JChatUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.titleArr.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.registerClass(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCellWithIdentifier(identify) as? JChatAboutMeCell
    }
    let tittle = self.titleArr![indexPath.row] as! String
    let imgName = self.imgArr![indexPath.row] as! String
    let info = self.infoArr![indexPath.row] as! String

    cell?.setCellData(tittle, icon: imgName, info: info)
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.selected = false
    
    let editUserInfoVC = JChatEditUserInfoViewController()
    switch indexPath.row {
    case 0:
      editUserInfoVC.updateType = .FieldsNickname
      break
    case 2:
      editUserInfoVC.updateType = .FieldsRegion
      break
    case 3:
      editUserInfoVC.updateType = .FieldsSignature
      break
    default:
      self.selectFlagGender = true
      self.showSelectGenderView(true)
      return
      break
    }
    self.navigationController?.pushViewController(editUserInfoVC, animated: true)
  }

  func showSelectGenderView(flag: Bool) {
    if flag {
      self.view.setNeedsDisplay()
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        self.genderPicker.snp_updateConstraints(closure: { (make) -> Void in
          make.bottom.equalTo(self.view.snp_bottom)
        })
      self.view.setNeedsDisplay()
      })
    } else {
      self.view.setNeedsDisplay()
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        self.genderPicker.snp_updateConstraints(closure: { (make) -> Void in
          make.bottom.equalTo(self.view.snp_bottom).offset(100)
        })
      self.view.setNeedsDisplay()
      })
    }
  }
}