//
//  JCHATRegisterViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/29.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JCHATRegisterViewController: UIViewController {

  @IBOutlet weak var usernameTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var registerBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigationBar()
    self.layoutAllViews()
  }
  
  func setupNavigationBar() {
    self.title = "极光IM"
    let leftBtn = UIButton(type: .custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  func backClick() {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func layoutAllViews(){
    self.registerBtn.layer.cornerRadius = 4
    self.registerBtn.layer.masksToBounds = true
    self.registerBtn.setBackgroundColor(UIColor(netHex: 0x3f80de), forState: UIControlState())
    self.registerBtn.setBackgroundColor(UIColor(netHex: 0x2840b0), forState: .highlighted)
    self.usernameTF.becomeFirstResponder()
    self.passwordTF.isSecureTextEntry = true
    self.passwordTF.returnKeyType = .default
  }

  @objc func doBack(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func checkValidUsername(_ username: String, password:String) -> Bool{
    if password != "" && username != "" {
      return true
    }
    
    var alertString = ""
    if username == "" {
      alertString = "用户名不能为空"
    } else {
      alertString = "密码不能为空"
    }
    
    MBProgressHUD.showMessage(alertString, view: self.view)
    return false
  }
  
  @IBAction func clickToRegister(_ sender: AnyObject) {
    print("Action - clickToRegister")
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    if self.checkValidUsername(usernameTF.text!, password: passwordTF.text!) {
      MBProgressHUD.showMessage("正在注册", view: self.view)
      JMSGUser.register(withUsername: usernameTF.text!, password: passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
          MBProgressHUD.showMessage("注册成功,正在自动登录", view: self.view)
          JMSGUser.login(withUsername: self.usernameTF.text!, password: self.passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
              MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if error == nil {
              NotificationCenter.default.post(name: Notification.Name(rawValue: kAccountChangeNotification), object: nil)
              self.userLoginSave()

              let detailVC = JCHATSetDetailViewController()
              self.navigationController?.pushViewController(detailVC, animated: true)
              
            } else {
              print("login fail error \(NSString.errorAlert(error as! NSError))")
              MBProgressHUD.showMessage(NSString.errorAlert(error as! NSError), view: self.view)
            }
          })
        } else {
          JMSGHttpErrorCode.errorHttpUserExist.rawValue
          print("")
          print("login fail error \(NSString.errorAlert(error as! NSError))")
          MBProgressHUD.showMessage(NSString.errorAlert(error as! NSError), view: self.view)
        }
      })
    }
  }
  
  func userLoginSave() {
    UserDefaults.standard.set(self.usernameTF.text, forKey: kuserName)
    UserDefaults.standard.set(self.usernameTF.text, forKey: klastLoginUserName)
    UserDefaults.standard.synchronize()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}











