//
//  JChatAlreadyLoginViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JChatAlreadyLoginViewController: UIViewController {
  @IBOutlet weak var userNameLabel: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "极光IM"
    let username = NSUserDefaults.standardUserDefaults().objectForKey(klastLoginUserName) as! String
    userNameLabel.setTitle(username, forState: .Normal)
    self.addGesture()
  }

  func addGesture() {
    let gesture = UITapGestureRecognizer(target: self, action:#selector(JChatAlreadyLoginViewController.handleTap))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  @objc func handleTap() {
    UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
  }
  
  @IBAction func clickToLogin(sender: AnyObject) {

    let username = NSUserDefaults.standardUserDefaults().objectForKey(klastLoginUserName) as! String
    let password = passwordTF.text
    MBProgressHUD.showMessage("正在登录", toView: self.view)
    JMSGUser.loginWithUsername(username, password: password!) { (resultObject, error) -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      if error == nil {
        MBProgressHUD.showMessage("登录成功", view: self.view)
        NSNotificationCenter.defaultCenter().postNotificationName(kupdateUserInfo, object: nil)
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate!.window!!.rootViewController = JChatMainTabViewController.sharedInstance
        
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: kuserName)
      } else {
        MBProgressHUD.showMessage("\(NSString.errorAlert(error))", view: self.view)
      }
    }
  }
  
  @IBAction func clickToRegister(sender: AnyObject) {
    let registerCtl = JCHATRegisterViewController()
    self.navigationController?.pushViewController(registerCtl, animated: true)
  }
  

  @IBAction func switchToLogin(sender: AnyObject) {
    let loginVC = JChatLoginViewController()
    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

}


extension JChatAlreadyLoginViewController: UIGestureRecognizerDelegate {

}
