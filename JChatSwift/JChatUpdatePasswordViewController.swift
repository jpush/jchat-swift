//
//  JChatUpdatePasswordViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/3/3.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import MBProgressHUD

class JChatUpdatePasswordViewController: UIViewController {

  @IBOutlet weak var oldPassword: UITextField!
  
  @IBOutlet weak var newPassword: UITextField!
  
  @IBOutlet weak var comfortNewPassword: UITextField!
  
  @IBOutlet weak var finishiBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigation()
  }

  func setupNavigation() {
    self.title = "修改密码"
    let leftBtn = UIButton(type: .Custom)
    leftBtn.frame = kNavigationLeftButtonRect
    leftBtn.setImage(UIImage(named: "goBack"), forState: .Normal)
    leftBtn.imageEdgeInsets = kGoBackBtnImageOffset
    leftBtn.addTarget(self, action: #selector(self.doBack), forControlEvents: .TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    
    self.navigationController?.navigationBar.translucent = false
  }
  
  func doBack() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func clickToUpdatePassword(sender: AnyObject) {
    
    if self.oldPassword.text == "" {
      MBProgressHUD.showMessage("请输入原密码", view: self.view)

      return
    }

    if self.newPassword.text == "" {
      MBProgressHUD.showMessage("请输入新密码", view: self.view)
      return
    }

    if self.comfortNewPassword.text == "" {
      MBProgressHUD.showMessage("请输入确认密码", view: self.view)
      return
    }
    
    if self.newPassword.text == self.comfortNewPassword.text {
      MBProgressHUD.showMessage("正在修改", toView: self.view)
      JMSGUser.updateMyPasswordWithNewPassword(self.newPassword.text!, oldPassword: self.oldPassword.text!, completionHandler: { (resultObject, error) -> Void in
        dispatch_async(dispatch_get_main_queue(), { 
          MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
        
        if error == nil {
          self.navigationController?.popViewControllerAnimated(true)
          MBProgressHUD.showMessage("修改密码成功", view: self.view)
        } else {
          MBProgressHUD.showMessage("修改密码失败", view: self.view)
          print("update password fail with error \(NSString.errorAlert(error))")
        }
      })
    } else {
      MBProgressHUD.showMessage("新密码与确认密码不相同，请重新输入", view: self.view)
      return
    }

  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
