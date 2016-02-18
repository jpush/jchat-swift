//
//  ViewController.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/15.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import SnapKit

let loginedUserName = "loginedUserName"

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let loginBtn:UIButton = UIButton()
    loginBtn.setTitle("Login", forState: .Normal)
    loginBtn.setTitleColor(UIColor.purpleColor(), forState: .Normal)
    loginBtn.layer.cornerRadius = 5
    loginBtn.layer.borderWidth = 2
    loginBtn.layer.borderColor = UIColor.purpleColor().CGColor
    loginBtn.addTarget(self, action: Selector("clickLogin"), forControlEvents: .TouchUpInside)
    self.view.addSubview(loginBtn)
    loginBtn.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.view)
      make.size.equalTo(CGSize(width: 60, height: 30))
    }

  }

  @objc func clickLogin() {
    
    if NSUserDefaults.standardUserDefaults().objectForKey(loginedUserName) == nil {
      JMSGUser.loginWithUsername("uikit1", password: "111111") { (resultObj, error) -> Void in
        if error == nil {
          NSUserDefaults.standardUserDefaults().setObject("uikit1", forKey: loginedUserName)
          let nextVC:JChatChattingViewController = JChatChattingViewController()
          let nextNC:UINavigationController = UINavigationController(rootViewController: nextVC)
          self.presentViewController(nextNC, animated: true, completion: nil)
        } else {
          let nextVC:JChatChattingViewController = JChatChattingViewController()
          let nextNC:UINavigationController = UINavigationController(rootViewController: nextVC)
          self.presentViewController(nextNC, animated: true, completion: nil)
        }
      }
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

