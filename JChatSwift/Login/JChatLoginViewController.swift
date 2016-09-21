//
//  JChatLoginViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JChatLoginViewController: UIViewController {

  @IBOutlet weak var userNameTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var loginBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.layoutAllViews()
    
    let gesture = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func layoutAllViews() {
    self.navigationController?.navigationBar.isTranslucent = false
    if UserDefaults.standard.object(forKey: klastLoginUserName) == nil {
      self.navigationItem.hidesBackButton = true
    } else {
      let leftBtn = UIButton(type: .custom)
      leftBtn.frame = kNavigationLeftButtonRect
      leftBtn.setImage(UIImage(named: "goBack"), for: UIControlState())
      leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
      leftBtn.addTarget(self, action: #selector(self.backClick), for: .touchUpInside)
      self.title = "登录"
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }
    
    self.view.backgroundColor = UIColor.white
    self.loginBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: UIControlState())
    self.loginBtn.setBackgroundColor(UIColor(netHex: 0x498d67), forState: .highlighted)
    self.loginBtn.layer.cornerRadius = 4
    self.loginBtn.layer.masksToBounds = true
    self.userNameTF.becomeFirstResponder()
  }

  func backClick() {
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
    
    print("\(alertString)")
    
    return false
  }
  
  @IBAction func clickToLogin(_ sender: AnyObject) {
    print("Action - Login")
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    
    if self.checkValidUsername(self.userNameTF.text!, password: self.passwordTF.text!) {
      MBProgressHUD.showMessage("正在登录", toView: self.view)
      JMSGUser.login(withUsername: self.userNameTF.text!, password: self.passwordTF.text! , completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          NotificationCenter.default.post(name: Notification.Name(rawValue: kupdateUserInfo), object: nil)
          let appDelegate = UIApplication.shared.delegate
          self.userLoginSave()
          appDelegate!.window!!.rootViewController = JChatMainTabViewController.sharedInstance
        } else {
          DispatchQueue.main.async(execute: { () -> Void in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
          })
          MBProgressHUD.showMessage(NSString.errorAlert(error as! NSError), view: self.view)
        }
      })
      
    }
  }

  func userLoginSave() {
    UserDefaults.standard.set(self.userNameTF.text, forKey: kuserName)
    UserDefaults.standard.set(self.userNameTF.text, forKey: klastLoginUserName)
    UserDefaults.standard.synchronize()
  }
  
  func handleTap() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  @IBAction func clickToRegister(_ sender: AnyObject) {

    let registerCtl = JCHATRegisterViewController()
    self.navigationController?.pushViewController(registerCtl, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

  }

}

extension JChatLoginViewController: UIGestureRecognizerDelegate {
  
}
