//
//  JChatLoginViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

//let kuserName = "userName"


let kNavigationLeftButtonRect = CGRectMake(0, 0, 30, 30)
let kGoBackBtnImageOffset = UIEdgeInsetsMake(0, 0, 0, 15)
class JChatLoginViewController: UIViewController {

  @IBOutlet weak var userNameTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var loginBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.layoutAllViews()
    
    let gesture = UITapGestureRecognizer(target: self, action:Selector("handleTap"))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func layoutAllViews() {
    self.navigationController?.navigationBar.translucent = false
    if NSUserDefaults.standardUserDefaults().objectForKey(klastLoginUserName) == nil {
      self.navigationItem.hidesBackButton = true
    } else {
      let leftBtn = UIButton(type: .Custom)
      leftBtn.frame = kNavigationLeftButtonRect
      leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
      leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
      leftBtn.addTarget(self, action: Selector("backClick"), forControlEvents: .TouchUpInside)
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }
    
    self.view.backgroundColor = UIColor.whiteColor()
    self.loginBtn.setBackgroundColor(UIColor(netHex: 0x6fd66b), forState: .Normal)
    self.loginBtn.setBackgroundColor(UIColor(netHex: 0x498d67), forState: .Highlighted)
    self.loginBtn.layer.cornerRadius = 4
    self.loginBtn.layer.masksToBounds = true
    self.userNameTF.becomeFirstResponder()
  }

  @objc func backClick() {
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
    
    print("\(alertString)")
    
    return false
  }
  
  @IBAction func clickToLogin(sender: AnyObject) {
    print("Action - Login")
    UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
    
    if self.checkValidUsername(self.userNameTF.text!, password: self.passwordTF.text!) {
      MBProgressHUD.showMessage("正在登陆", toView: self.view)
      JMSGUser.loginWithUsername(self.userNameTF.text!, password: self.passwordTF.text! , completionHandler: { (resultObject, error) -> Void in
        if error == nil {
          NSNotificationCenter.defaultCenter().postNotificationName(kupdateUserInfo, object: nil)
          self.userLoginSave()
        } else {
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
          })
          MBProgressHUD.showMessage(NSString.errorAlert(error), toView: self.view)
        }
      })
      
    }
  }

  func userLoginSave() {
    NSUserDefaults.standardUserDefaults().setObject(self.userNameTF.text, forKey: kuserName)
    NSUserDefaults.standardUserDefaults().setObject(self.userNameTF.text, forKey: klastLoginUserName)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  @objc func handleTap() {
    UIApplication.sharedApplication().sendAction(Selector("resignFirstResponder"), to: nil, from: nil, forEvent: nil)
  }
  
  @IBAction func clickToRegister(sender: AnyObject) {
//    JCHATRegisterViewController *registerCtl = [[JCHATRegisterViewController alloc] initWithNibName:@"JCHATRegisterViewController" bundle:nil];
//    [self.navigationController pushViewController:registerCtl animated:YES];
    let registerCtl = JCHATRegisterViewController()
    self.navigationController?.pushViewController(registerCtl, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

  }

}

extension JChatLoginViewController: UIGestureRecognizerDelegate {
  
}
