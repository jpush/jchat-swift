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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupDataSource()
    self.layoutAllViews()
  }
  
  func layoutAllViews() {
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.isTranslucent = false
    self.title = "个人信息"
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)

    self.personTable = UITableView()
    self.personTable.tableFooterView = UIView()
    self.personTable.separatorStyle = .none
    self.personTable.delegate = self
    self.personTable.dataSource = self
    self.personTable.isScrollEnabled = false
    self.view.addSubview(self.personTable)
    let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickTable))
    self.personTable.backgroundView = UIView()
    self.personTable.backgroundView!.addGestureRecognizer(gesture)
    
    self.personTable.snp.makeConstraints { (make) -> Void in
      make.left.right.top.bottom.equalTo(self.view)
    }
    
    self.genderPicker = UIPickerView()
    self.genderPicker.delegate = self
    self.genderPicker.dataSource = self
    self.view.addSubview(self.genderPicker)
    self.genderPicker.snp.makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
      make.height.right.equalTo(100)
      make.bottom.equalTo(self.view).offset(100)
    }
  }
  
  func backClick() {
    _ = self.navigationController?.popViewController(animated: true)
  }

  func clickTable() {

    if selectFlagGender! {
      JMSGUser.updateMyInfo(withParameter: self.genderNumber, userFieldType: .fieldsGender, completionHandler: { (resultObject, error) -> Void in
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
    self.infoArr.add(name!)
    self.genderNumber = 1
    switch user.gender {
    case .unknown:
      self.infoArr.add("未知")
      break
    case .female:
      self.infoArr.add("女")
      break
    default:
      self.infoArr.add("男")
      break
    }
    
    if user.region != nil {
      self.infoArr.add(user.region!)
    } else {
      self.infoArr.add("")
    }
    
    if user.signature != nil {
      self.infoArr.add(user.signature!)
    } else {
      self.infoArr.add("")
    }
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension JChatUserInfoViewController: UIPickerViewDataSource, UIPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerDataArr.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerDataArr[row] as? String
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.titleArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    identify = "JChatAboutMeCell"
    var cell:JChatAboutMeCell? = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    if cell == nil {
      tableView.register(NSClassFromString(identify), forCellReuseIdentifier: identify)
      cell = tableView.dequeueReusableCell(withIdentifier: identify) as? JChatAboutMeCell
    }
    let tittle = self.titleArr![(indexPath as NSIndexPath).row] as! String
    let imgName = self.imgArr![(indexPath as NSIndexPath).row] as! String
    let info = self.infoArr![(indexPath as NSIndexPath).row] as! String

    cell?.setCellData(tittle, icon: imgName, info: info)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isSelected = false
    
    let editUserInfoVC = JChatEditUserInfoViewController()
    switch (indexPath as NSIndexPath).row {
    case 0:
      editUserInfoVC.updateType = .fieldsNickname
      break
    case 2:
      editUserInfoVC.updateType = .fieldsRegion
      break
    case 3:
      editUserInfoVC.updateType = .fieldsSignature
      break
    default:
      self.selectFlagGender = true
      self.showSelectGenderView(true)
      break
    }
    self.navigationController?.pushViewController(editUserInfoVC, animated: true)
  }

  func showSelectGenderView(_ flag: Bool) {
    if flag {
      self.view.setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { () -> Void in
        self.genderPicker.snp.updateConstraints({ (make) -> Void in
          make.bottom.equalTo(self.view.snp.bottom)
        })
      self.view.setNeedsDisplay()
      })
    } else {
      self.view.setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { () -> Void in
        self.genderPicker.snp.updateConstraints({ (make) -> Void in
          make.bottom.equalTo(self.view.snp.bottom).offset(100)
        })
      self.view.setNeedsDisplay()
      })
    }
  }
}
