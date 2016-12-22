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
    self.navigationController?.navigationBar.isTranslucent = false
    let username = UserDefaults.standard.object(forKey: klastLoginUserName) as? String
    userNameLabel.setTitle(username, for: UIControlState())
    self.addGesture()
  }

  func addGesture() {
    let gesture = UITapGestureRecognizer(target: self, action:#selector(JChatAlreadyLoginViewController.handleTap))
    gesture.delegate = self
    self.view.addGestureRecognizer(gesture)
  }
  
  func handleTap() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  @IBAction func clickToLogin(_ sender: AnyObject) {

    let username = UserDefaults.standard.object(forKey: klastLoginUserName) as! String
    let password = passwordTF.text
    MBProgressHUD.showMessage("正在登录", toView: self.view)
    JMSGUser.login(withUsername: username, password: password!) { (resultObject, error) -> Void in
      DispatchQueue.main.async(execute: { 
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      })
      
      if error == nil {
        MBProgressHUD.showMessage("登录成功", view: self.view)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kupdateUserInfo), object: nil)
        let appDelegate = UIApplication.shared.delegate
        appDelegate!.window!!.rootViewController = JChatMainTabViewController.sharedInstance
        
        UserDefaults.standard.set(username, forKey: kuserName)
      } else {
        MBProgressHUD.showMessage("\(NSString.errorAlert(error as! NSError))", view: self.view)
      }
    }
  }
  
  @IBAction func clickToRegister(_ sender: AnyObject) {
    let registerCtl = JCHATRegisterViewController()
    self.navigationController?.pushViewController(registerCtl, animated: true)
  }
  

  @IBAction func switchToLogin(_ sender: AnyObject) {
    let loginVC = JChatLoginViewController()
    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

}


extension JChatAlreadyLoginViewController: UIGestureRecognizerDelegate {

}
