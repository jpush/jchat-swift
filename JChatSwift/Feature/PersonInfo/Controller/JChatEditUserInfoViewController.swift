//
//  JChatEditUserInfoViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/2.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

let textNumberLimit = 30
class JChatEditUserInfoViewController: UIViewController {
  var baseLine:UIView!
  var infoTextField:UITextField!
  var deleteBtn:UIButton!
  var textNumberLable:UILabel!
  var descriptLable:UILabel!
  var updateType:JMSGUserField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.layoutAllViews()
    self.setupNavigation()
    self.setData()
    self.infoTextField.becomeFirstResponder()

  }

  func setupNavigation() {
    
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.isTranslucent = false

    let rightBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.clickToSave))
    rightBtn.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem = rightBtn
    
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
  
  func clickToSave() {
    if self.updateType == .fieldsNickname {
      if self.getStringByteLength(self.infoTextField.text) > textNumberLimit {
        MBProgressHUD.showMessage("输入的用户名超过30字节限制", view: self.view)
        return
      }
    }
    JMSGUser.updateMyInfo(withParameter: self.infoTextField.text!, userFieldType: self.updateType) { (resultObject, error) -> Void in
      MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      if error == nil {
        NotificationCenter.default.post(name: Notification.Name(rawValue: kAccountChangeNotification), object: nil)
        MBProgressHUD.showMessage("修改成功", view: self.view)
        _ = self.navigationController?.popViewController(animated: true)
      } else {
        MBProgressHUD.showMessage("修改成功", view: self.view)
      }
    }
  }
  
  func layoutAllViews() {
    self.view.backgroundColor = UIColor.white
    
    self.baseLine = UIView()
    self.baseLine.backgroundColor = kSeparatorColor
    self.view.addSubview(self.baseLine)
    
    self.infoTextField = UITextField()
    self.infoTextField.textColor = UIColor(netHex: 0x2d2d2d)
    self.view.addSubview(self.infoTextField)
    
    self.deleteBtn = UIButton()
    self.deleteBtn.setBackgroundImage(UIImage(named: "set_btn_del_"), for: UIControlState())
    self.deleteBtn.setBackgroundImage(UIImage(named: "set_btn_del_pre_"), for: .highlighted)
    self.view.addSubview(self.deleteBtn)
    
    self.textNumberLable = UILabel()
    self.textNumberLable.font = UIFont.systemFont(ofSize: 16)
    self.textNumberLable.textColor = kPlaceHoldTextColor
    self.textNumberLable.textAlignment = .center
    self.view.addSubview(self.textNumberLable)
    
    self.descriptLable = UILabel()
    self.descriptLable.font = UIFont.systemFont(ofSize: 12)
    self.descriptLable.textColor = kPlaceHoldTextColor
    self.view.addSubview(self.descriptLable)
    
    self.infoTextField.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(self.view).offset(27)
      make.right.equalTo(self.textNumberLable.snp.left).offset(10)
      make.left.equalTo(self.view).offset(10)
    }
    
    self.baseLine.snp.makeConstraints { (make) -> Void in
      make.left.right.equalTo(self.view)
      make.height.equalTo(0.5)
      make.top.equalTo(self.infoTextField.snp.bottom).offset(3)
    }
    
    self.textNumberLable.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(self.baseLine).offset(-4)
      make.size.equalTo(CGSize(width: 42, height: 12))
      make.right.equalTo(self.view)
    }
    
    self.deleteBtn.snp.makeConstraints { (make) -> Void in
      make.size.equalTo(CGSize(width: 16, height: 16))
      make.bottom.equalTo(self.textNumberLable.snp.top).offset(-4)
      make.centerX.equalTo(self.textNumberLable.snp.centerX)
    }
    
    self.descriptLable.snp.makeConstraints { (make) -> Void in
      make.right.left.equalTo(self.view).offset(19)
      make.top.equalTo(self.baseLine.snp.bottom).offset(3)
      make.height.equalTo(13)
    }
  }
  
  func setData() {
    let user = JMSGUser.myInfo()
    switch self.updateType as JMSGUserField {
      case .fieldsNickname:
        self.deleteBtn.isHidden = false
        self.textNumberLable.isHidden = false
        self.descriptLable.text = "好名字可以让你的朋友更加容易记住你"
        if user.nickname == nil {
          self.infoTextField.placeholder = "请输入你的姓名"
        } else {
          self.infoTextField.placeholder = user.nickname
        }
        self.infoTextField.addTarget(self, action: #selector(self.textFieldDidChangeName), for: .editingChanged)
        self.title = "修改昵称"
      break
      case .fieldsSignature:
        self.descriptLable.isHidden = true
        self.infoTextField.addTarget(self, action: #selector(self.textFieldDidChangeName), for: .editingChanged)
        if user.signature == nil {
          self.infoTextField.placeholder = "请输入你的签名"
        } else {
          self.infoTextField.placeholder = user.signature
        }
        self.title = "修改签名"
      break
      case .fieldsRegion:
        self.deleteBtn.isHidden = true
        self.textNumberLable.isHidden = true
        
        self.descriptLable.isHidden = true
        if user.region == nil {
          self.infoTextField.placeholder = "请输入你所在的地区"
        } else {
          self.infoTextField.placeholder = user.region
        }
        self.title = "修改地区"
      break
    default:
      break
    }

  }
  
  func textFieldDidChange() {
    self.textNumberLable.text = "\(self.infoTextField.text?.characters.count)"
  }
  
  func textFieldDidChangeName() {
    if self.getStringByteLength(self.infoTextField.text) > textNumberLimit {
      self.infoTextField.text = self.infoTextField.text![0..<((self.infoTextField.text?.characters.count)! - 1)]
      
      MBProgressHUD.showMessage("最多输入 \(textNumberLimit) 个字节", view: self.view)
      return
    }
    
    self.textNumberLable.text = "\(textNumberLimit - self.getStringByteLength(self.infoTextField.text))"
  }

  func getStringByteLength(_ str:String?) -> Int {
    return (str?.utf8Array.count)!
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}

extension JChatEditUserInfoViewController: UIGestureRecognizerDelegate {
  
}
