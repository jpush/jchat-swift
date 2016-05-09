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
    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.backClick), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    self.navigationController?.navigationBar.translucent = false
  }
  
  func backClick() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func layoutAllViews(){
    self.registerBtn.layer.cornerRadius = 4
    self.registerBtn.layer.masksToBounds = true
    self.registerBtn.setBackgroundColor(UIColor(netHex: 0x3f80de), forState: .Normal)
    self.registerBtn.setBackgroundColor(UIColor(netHex: 0x2840b0), forState: .Highlighted)
    self.usernameTF.becomeFirstResponder()
    self.passwordTF.secureTextEntry = true
    self.passwordTF.returnKeyType = .Default
  }

  @objc func doBack(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func checkValidUsername(username: String, password:String) -> Bool{
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
  
  @IBAction func clickToRegister(sender: AnyObject) {
    print("Action - clickToRegister")
    UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    if self.checkValidUsername(usernameTF.text!, password: passwordTF.text!) {
      MBProgressHUD.showMessage("正在注册", view: self.view)
      JMSGUser.registerWithUsername(usernameTF.text!, password: passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
          MBProgressHUD.showMessage("注册成功,正在自动登陆", view: self.view)
          JMSGUser.loginWithUsername(self.usernameTF.text!, password: self.passwordTF.text!, completionHandler: { (resultObject, error) -> Void in
              MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error == nil {
              
              self.userLoginSave()

              let detailVC = JCHATSetDetailViewController()
              self.navigationController?.pushViewController(detailVC, animated: true)
              
            } else {
              print("login fail error \(NSString.errorAlert(error))")
              MBProgressHUD.showMessage(NSString.errorAlert(error), view: self.view)
            }
          })
        }
      })
    }
  }
  
  func userLoginSave() {
    NSUserDefaults.standardUserDefaults().setObject(self.usernameTF.text, forKey: kuserName)
    NSUserDefaults.standardUserDefaults().setObject(self.usernameTF.text, forKey: klastLoginUserName)
    NSUserDefaults.standardUserDefaults().synchronize()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}











